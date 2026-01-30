local M = {}

-- main menu:
-- load save
-- upgrades
-- start game
function M.drawMainMenu()
    love.graphics.printf("Main Menu", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Press ....... to Start", 0, 200, love.graphics.getWidth(), "center")
end

-- how much currency
-- available upgrades
function M.upgradesMenu()
end

function M.splash()
end

return M
