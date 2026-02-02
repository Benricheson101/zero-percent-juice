local constants = require('constants')

local MainMenu = {}

function MainMenu.draw()
    love.graphics.clear(constants.colors.skyblue)

    love.graphics.print('Start Game')
    love.graphics.print('Leaderboard')
    love.graphics.print('Exit')
end

function MainMenu.mousepressed(x, y) end

return MainMenu
