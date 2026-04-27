local http = require('socket.http')
local json = require('JSON')
local ltn12 = require('ltn12')
local Scene = require('renderer.scene')
local UIButton = require('ui.button')
local UILeaderboardEntry = require('ui.leaderboardEntry')
local Ui = require('util.ui')
local config = require('util.config')
local constants = require('util.constants')
local fonts = require('util.fonts')

---@class LeaderboardEntry
---@field name string
---@field score number

---@class LeaderboardScene : Scene
---@field entries LeaderboardEntry[]
---@field backButton UIButton
local LeaderboardScene = {}
setmetatable(LeaderboardScene, { __index = Scene })
LeaderboardScene.__index = LeaderboardScene

---@return LeaderboardEntry[]
local function fetchLeaderboard()
    local responseBodyChunks = {}

    local b = http.request {
        url = config.leaderboard_api .. '/leaderboard',
        method = 'GET',
        headers = {
            ['Content-Type'] = 'application/json',
        },
        sink = ltn12.sink.table(responseBodyChunks),
    }

    local respBody = table.concat(responseBodyChunks)
    ---@type LeaderboardEntry[]
    local body = { { name = 'No highscores yet!', score = 0 } }
    if b ~= nil then
        local parsedBody = json:decode(respBody)
        if parsedBody ~= nil and type(parsedBody) == "table" then
            body = parsedBody
        end
    end

    return body
end

function LeaderboardScene:new()
    local o = setmetatable({}, self)

    o.entries = {}

    return o
end

function LeaderboardScene:enter()
    self.entries = fetchLeaderboard()
    self.backButton = UIButton:new {
        text = '\u{f00d}',
        width = fonts.faSolid30:getWidth('\u{f00d}') + 40,
        height = fonts.faSolid30:getBaseline() + 40,
        font = 'faSolid30',
        onClick = function(btn)
            btn.scene.scene_manager:transition('mainmenu')
        end,
    }
    self.backButton.scene = self.scene_manager.active
end

function LeaderboardScene:draw()
    love.graphics.clear(constants.colors.menu.bg)

    local titleText = 'Leaderboard'
    local titleFont = fonts.impact75

    love.graphics.setFont(titleFont)
    love.graphics.setColor(constants.colors.menu.button_fill)

    love.graphics.printf(
        titleText,
        0,
        math.floor(Ui:getHeight() * 0.25)
            - math.floor(titleFont:getHeight() / 2),
        Ui:getWidth(),
        'center'
    )

    local start = 0.35 * Ui:getHeight()
    local gap = Ui:scaleDimension(15)

    for i, entry in ipairs(self.entries) do
        local le = UILeaderboardEntry:new(entry, i)
        love.graphics.draw(le:draw(), 0, start)

        start = start + fonts.impact50:getHeight() + gap

        -- stop displaying them if it runs off the page
        if (start + fonts.impact50:getHeight()) >= Ui:getHeight() then
            break
        end
    end

    local buttonX = Ui:getWidth()
        - Ui:scaleDimension(25)
        - Ui:scaleDimension(self.backButton.width)
    local buttonY = Ui:scaleDimension(25)
    local btn = self.backButton

    btn.x = buttonX
    btn.y = buttonY

    self.backButton.worldBounds = {
        { btn.x, btn.y },
        {
            btn.x + Ui:scaleDimension(btn.width),
            btn.y + Ui:scaleDimension(btn.height),
        },
    }

    local mX, mY = love.mouse.getPosition()
    if btn:isWithin(mX, mY) then
        btn:hover(mX, mY)
    end

    love.graphics.draw(self.backButton:draw(), buttonX, buttonY)
end

function LeaderboardScene:mousepressed(x, y)
    if self.backButton:isWithin(x, y) then
        self.backButton:onclick(x, y)
    end
end

function LeaderboardScene:update()
    self.backButton:update()
end

return LeaderboardScene
