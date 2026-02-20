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

local Ui = require("util.ui")


function love.load()
    -- Initialize the Ui scaling factor
    Ui:reload()
    --tmp
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    love.window.updateMode(w,h, {resizable=true})
end



function love.resize(w,h)
    --whe the window is resized, update the Ui scaling factor
    Ui:reload()
end