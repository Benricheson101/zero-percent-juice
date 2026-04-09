local Scene = require('renderer.scene')
local UITextbox = require('ui.textbox')
local Ui = require('util.ui')
local fonts = require('util.fonts')
local http = require('socket.http')
local ltn12 = require('ltn12')
local json = require('JSON')
local Player = require('player')
local constants = require('util.constants')
local config = require('util.config')

---@class LeaderboardSubmitScene : Scene
local LeaderboardSubmitScene = {}
setmetatable(LeaderboardSubmitScene, { __index = Scene })
LeaderboardSubmitScene.__index = LeaderboardSubmitScene

---@param name string
---@param score number
local function submitScore(name, score)
    local requestBody = json:encode {
        name = name,
        score = score,
    }
    local responseBody = {}

    local body = http.request {
        url = config.leaderboard_api .. '/score',
        method = 'POST',
        headers = {
            ['Content-Type'] = 'application/json',
            ['Content-Length'] = tostring(#requestBody),
        },
        source = ltn12.source.string(requestBody),
        sink = ltn12.sink.table(responseBody),
    }

    return body ~= nil
end

function LeaderboardSubmitScene:new()
    local o = setmetatable({}, self)
    o.input = ''
    o.liveInput = ''
    o.failed = false
    o.waitTime = 0
    return o
end

function LeaderboardSubmitScene:enter()
    love.keyboard.setKeyRepeat(true)
    self.failed = false
    self.waitTime = 0

    self.textbox = UITextbox:new {
        width = 900,
        focused = true,
        placeholder = 'Enter your name for the leaderboard...',
        maxLength = 32,
        onSubmit = function(tb, value)
            tb.focused = false
            self.input = value

            local success = submitScore(value, Player.score)
            if success then
                self.scene_manager:transition('gameover')
            else
                self.failed = true
            end
        end,

        onInput = function(_, value)
            self.liveInput = value
        end,
    }
end

function LeaderboardSubmitScene:exit()
    love.keyboard.setKeyRepeat(false)
end

function LeaderboardSubmitScene:draw()
    love.graphics.clear(constants.colors.menu.bg)

    local titleFont = fonts.impact75

    love.graphics.setColor(constants.colors.title)
    love.graphics.setFont(titleFont)
    love.graphics.printf(
        'Game Over',
        0,
        math.floor(Ui:getHeight() * 0.125)
            - math.floor(titleFont:getHeight() / 2),
        Ui:getWidth(),
        'center'
    )

    love.graphics.setFont(fonts.impact50)
    love.graphics.printf(
        'Score: ' .. Player.score,
        0,
        math.floor(Ui:getHeight() * 0.25)
            - math.floor(titleFont:getHeight() / 2),
        Ui:getWidth(),
        'center'
    )

    local tbcanvas = self.textbox:draw()
    tbcanvas:getWidth()

    local tbCenterX = Ui.centerX - math.floor(tbcanvas:getWidth() / 2)
    local tbCenterY =
        math.floor((Ui:getHeight() * 0.375) - tbcanvas:getHeight() / 2)

    love.graphics.draw(tbcanvas, tbCenterX, tbCenterY)

    if self.failed then
        local errorFont = fonts.tahoma25
        love.graphics.setColor(constants.colors.error)
        love.graphics.setFont(errorFont)
        love.graphics.printf(
            'Failed to submit score to leaderboard',
            0,
            Ui:getHeight() * 0.375 + tbcanvas:getHeight() / 2,
            Ui:getWidth(),
            'center'
        )
    end

    -- TODO: switch to leaderboard scene
    -- TODO: only show this screen if score is in top 10?
end

---@param str string
function LeaderboardSubmitScene:textinput(str)
    self.textbox:textinput(str)
end

---@param key string
function LeaderboardSubmitScene:keypressed(key)
    self.textbox:keypressed(key)
end

function LeaderboardSubmitScene:update(dt)
    self.textbox:update(dt)

    if not self.failed then
        return
    end

    if self.waitTime >= 2.0 then
        self.scene_manager:transition('gameover')
    else
        self.waitTime = self.waitTime + dt
    end
end

return LeaderboardSubmitScene
