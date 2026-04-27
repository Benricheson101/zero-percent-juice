local Scene = require('renderer.scene')
local http = require('socket.http')
local ltn12 = require('ltn12')
local json = require('JSON')
local config = require('util.config')
local fonts = require('util.fonts')
local Ui = require('util.ui')
local UILeaderboardEntry = require('ui.leaderboardEntry')
local constants = require('util.constants')

---@class LeaderboardEntry
---@field name string
---@field score number

---@class LeaderboardScene : Scene
---@field entries LeaderboardEntry[]
local LeaderboardScene = {}
setmetatable(LeaderboardScene, { __index = Scene })
LeaderboardScene.__index = LeaderboardScene

---@return LeaderboardEntry[]
local function fetchLeaderboard()
    local responseBodyChunks = {}

    print('fetchLeaderboard')

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
        body = json:decode(respBody)
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
end

return LeaderboardScene
