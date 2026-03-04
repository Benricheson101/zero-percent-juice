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

    Player.load(
        love.graphics.getWidth() * 0.2,
        love.graphics.getHeight() / 2,
        0,
        0,
        300,
        300,
        50,
        50,
        300,
        300,
        o.scale,
        o.offsetX,
        o.offsetY)

    Background.load(
        o.scale,
        o.offsetX,
        o.offsetY)

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