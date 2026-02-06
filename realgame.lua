local M = {}

local constants = require('constants')
local count = 0
function M.draw()
    love.graphics.clear(constants.colors.black)

    local text = 'game game game game'

    love.graphics.setFont(constants.fonts.title)
    love.graphics.printf(
        text,
        0,
        math.floor(WindowHeight / 2)
            - math.floor(constants.fonts.title:getHeight() / 2),
        WindowWidth,
        'center'
    )
    count = count + 1
    if count > 300 then
        count = 0
        Screen = 'upgrades'
    end
end

return M
