Game = {}

local Player = require('player')

function Game.load()
    Player.load(love.graphics.getWidth() * 0.2, love.graphics.getHeight() / 2,
                0, 300, 50, 300)
end

function Game.update(dt)
    
    Player.update(dt)

end

function Game.draw()

    Player.draw()

end

return Game