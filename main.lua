--main file here

local Game = require('game')

Screen = 'game'

function love.load()

    Game.load()

end

function love.update(dt)

    if Screen == 'game' then
        Game.update(dt)
    end

end

function love.draw()

    if Screen == 'game' then
        Game.draw()
    end

end