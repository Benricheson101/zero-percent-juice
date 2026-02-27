local Background = {}

local designWidth = 1280
local designHeight = 720

function Background.load(scale)

    Background.scale = scale
    Background.offsetX = (love.graphics.getWidth() - (designWidth * Background.scale)) / 2
    Background.offsetY = (love.graphics.getHeight() - (designHeight * Background.scale)) / 2

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
function Background.updateScale(newScale)

    Background.scale = newScale
    Background.offsetX = (love.graphics.getWidth() - (designWidth * Background.scale)) / 2
    Background.offsetY = (love.graphics.getHeight() - (designHeight * Background.scale)) / 2

end

return Background