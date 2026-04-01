local Scene = require('renderer.scene')
local UITextbox = require('ui.textbox')
local Ui = require('util.ui')
local fonts = require('util.fonts')
local http = require('socket.http')
local ltn12 = require('ltn12')
local json = require('JSON')
local Player = require('player')
local constants = require('util.constants')

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

    http.request {
        url = 'http://localhost:8000/score',
        method = 'POST',
        headers = {
            ['Content-Type'] = 'application/json',
            ['Content-Length'] = tostring(#requestBody),
        },
        source = ltn12.source.string(requestBody),
        sink = ltn12.sink.table(responseBody),
    }
end

function LeaderboardSubmitScene:new()
    local o = setmetatable({}, self)
    o.input = ''
    o.liveInput = ''
    return o
end

function LeaderboardSubmitScene:enter()
    love.keyboard.setKeyRepeat(true)
    self.textbox = UITextbox:new {
        width = 900,
        focused = true,
        placeholder = 'Enter your name for the leaderboard...',
        maxLength = 32,
        onSubmit = function(tb, value)
            tb.focused = false
            self.input = value

            submitScore(value, Player.score)
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
end

return LeaderboardSubmitScene
