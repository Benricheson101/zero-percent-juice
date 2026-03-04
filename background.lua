local Ui = require("util.ui")

local Background = {}

local designWidth = 1280
local designHeight = 720

function Background.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    Background.image = love.graphics.newImage("images/Background.png")
    love.graphics.setDefaultFilter('linear', 'linear')

end

function Background.draw()

    love.graphics.draw(Background.image, Background.offsetX, Background.offsetY, 0, Background.scale, Background.scale)

    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, Ui:scaleDimension(designWidth), Ui.top)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 0, Ui:scaleDimension(designHeight) + Ui.top, Ui:scaleDimension(designWidth), Ui.top)
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", 0, 0, Ui.left, Ui:scaleDimension(designWidth))
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", Ui:scaleDimension(designWidth) + Ui.left, 0, Ui.left, Ui:scaleDimension(designWidth))

    love.graphics.setColor(1, 1, 1)

end

return Background