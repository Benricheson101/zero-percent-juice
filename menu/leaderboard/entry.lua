local constants = require('constants')

---@class LeaderboardEntry
local LeaderboardEntry = {}

---@param n integer
---@return LeaderboardEntry
function LeaderboardEntry:new(o, n)
    o = o or {}

    self.font = o.font or constants.fonts.button

    self.name = o.name
    self.score = o.score

    self.width = o.width or WindowWidth
    self.height = o.height or self.font:getHeight()
    self.canvas = love.graphics.newCanvas(self.width, self.height)
    self.nth = n

    setmetatable(o, self)
    self.__index = self
    return o
end

function LeaderboardEntry:draw()
    love.graphics.setCanvas(self.canvas)

    -- FIXME: why is the text so crispy
    local color = constants.colors.leaderboard[self.nth >= 4 and 4 or self.nth]
    love.graphics.setColor(color)

    love.graphics.printf(
        self.name,
        constants.fonts.button,
        -50,
        math.floor(self.height / 2) - math.floor(self.font:getHeight() / 2),
        self.width,
        'center'
    )

    love.graphics.printf(
        self.score,
        constants.fonts.button,
        50,
        math.floor(self.height / 2) - math.floor(self.font:getHeight() / 2),
        self.width,
        'center'
    )

    love.graphics.setCanvas()

    return self.canvas
end

return LeaderboardEntry
