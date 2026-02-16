--main file here
require("uiUtill")


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