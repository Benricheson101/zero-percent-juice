local Background = {}

local designWidth = 1280
local designHeight = 720

function Background.load(scale, offsetX, offsetY)

    Background.scale = scale
    Background.offsetX = offsetX
    Background.offsetY = offsetY

    love.graphics.setDefaultFilter('nearest', 'nearest')
    Background.image = love.graphics.newImage("images/Background.png")
    love.graphics.setDefaultFilter('linear', 'linear')

end

function Background.draw()

    love.graphics.draw(Background.image, Background.offsetX, Background.offsetY, 0, Background.scale, Background.scale)

    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), Background.offsetY)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - Background.offsetY, love.graphics.getWidth(), Background.offsetY)
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", 0, 0, Background.offsetX, love.graphics.getHeight())
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", love.graphics.getWidth() - Background.offsetX, 0, Background.offsetX, love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1)

end

-- Updates background scale
function Background.updateScale(newScale, newOffsetX, newOffsetY)

    Background.scale = newScale
    Background.offsetX = newOffsetX
    Background.offsetY = newOffsetY

end

return Background