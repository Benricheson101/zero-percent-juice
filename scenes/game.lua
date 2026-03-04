local Scene = require("renderer.scene")
local Player = require('player')
local Background = require('background')

local designWidth = 1280
local designHeight = 720

---@class GameScene : Scene
local GameScene = {}
setmetatable(GameScene, {__index = Scene})
GameScene.__index = GameScene

function GameScene:new()
    local o = setmetatable({}, self)

    o.scale = 1
    o.offsetX = 0
    o.offsetY = 0
    o:calculateScale()

    Player.load({
        posX = love.graphics.getWidth() * 0.2,
        posY = love.graphics.getHeight() / 2,
        velocityX = 0,
        velocityY = 0,
        accelerationX = 300,
        accelerationY = 300,
        decelerationX = 50,
        decelerationY = 50,
        maxVelocityX = 300,
        maxVelocityY = 300,
        scale = o.scale,
        offsetX = o.offsetX,
        offsetY = o.offsetY})

    Background.load({
        scale = o.scale,
        offsetX = o.offsetX,
        offsetY = o.offsetY})

    return o
end

function GameScene:update(dt)
    Player.update(dt)
end

function GameScene:draw()
    love.graphics.setColor(1, 1, 1)
    Background.draw()
    Player.draw()
end

-- Updates GameScene scale and passes new scale to all parts of the game
function GameScene:reload()

    self:calculateScale()

    Player.updateScale(self.scale, self.offsetX, self.offsetY)
    Background.updateScale(self.scale, self.offsetX, self.offsetY)

end

-- Similar to ui.lua, updates current scale to be as big as possible while still fitting on screen
function GameScene:calculateScale()
    local newWidth, newHeight = love.graphics.getDimensions()

    local scaleX = newWidth / designWidth
    local scaleY = newHeight / designHeight

    self.scale = math.min(scaleX, scaleY)
    self.offsetX = (love.graphics.getWidth() - (designWidth * self.scale)) / 2
    self.offsetY = (love.graphics.getHeight() - (designHeight * self.scale)) / 2

end

function GameScene:keypressed(key)

    Player.keypressed(key)

end

return GameScene