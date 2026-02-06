local LeaderboardEntry = require('menu.leaderboard.entry')
local constants = require('constants')

---@class LeaderboardScreen
local LeaderboardScreen = {}

local scores = {
    {
        name = 'Ben',
        score = 1000,
    },
    {
        name = 'Ben',
        score = 500,
    },
    {
        name = 'Ben',
        score = 300,
    },
    {
        name = 'Ben',
        score = 200,
    },
    {
        name = 'Ben',
        score = 3,
    },
}

table.sort(scores, function(left, right)
    return left.score > right.score
end)

function LeaderboardScreen.draw()
    love.graphics.clear(constants.colors.skyblue)

    local start = 247
    local gap = 30

    love.graphics.printf(
        'Leaderboard',
        constants.fonts.title,
        0,
        109,
        WindowWidth,
        'center'
    )

    for i, v in ipairs(scores) do
        local le = LeaderboardEntry:new(v, i)
        love.graphics.draw(le:draw(), 0, start)

        start = start + gap + le.height
    end
end

return LeaderboardScreen
