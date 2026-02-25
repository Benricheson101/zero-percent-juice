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

end

-- Updates background scale
function Background.updateScale(newScale)

    Background.scale = newScale
    Background.offsetX = (love.graphics.getWidth() - (designWidth * Background.scale)) / 2
    Background.offsetY = (love.graphics.getHeight() - (designHeight * Background.scale)) / 2

end

return Background