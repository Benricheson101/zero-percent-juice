local constants = require('util.constants')
local Ui = require('util.ui')
local fonts = require('util.fonts')
local str = require('util.str')

---@class UILeaderboardEntry
---@field nth number
---@field entry LeaderboardEntry
local UILeaderboardEntry = {}
UILeaderboardEntry.__index = UILeaderboardEntry

---@param n integer
---@param entry LeaderboardEntry
---@return UILeaderboardEntry
function UILeaderboardEntry:new(entry, n)
    local o = setmetatable({}, self)

    o.entry = entry
    o.nth = n
    return o
end

function UILeaderboardEntry:draw()
    local font = fonts.impact50
    local width = Ui:getWidth()
    local height = font:getHeight()

    local canvas = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(canvas)

    -- FIXME: why is the text so crispy
    local color = constants.colors.leaderboard[self.nth >= 4 and 4 or self.nth]
    love.graphics.setColor(color)

    local maxWidth = font:getWidth('M') * 15

    if self.entry.placeholder then
        love.graphics.printf(
            str.trunc(font, self.entry.name, maxWidth),
            font,
            0,
            math.floor(height / 2) - math.floor(font:getHeight() / 2),
            width,
            'center'
        )
    else
        love.graphics.printf(
            str.trunc(font, self.entry.name, maxWidth),
            font,
            -math.floor(maxWidth / 2),
            math.floor(height / 2) - math.floor(font:getHeight() / 2),
            width,
            'center'
        )

        love.graphics.printf(
            self.entry.score,
            font,
            math.floor(maxWidth / 2),
            math.floor(height / 2) - math.floor(font:getHeight() / 2),
            width,
            'center'
        )
    end

    love.graphics.setCanvas()

    return canvas
end

return UILeaderboardEntry
