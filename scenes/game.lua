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
    o:calculateScale()

    Player.load(
        love.graphics.getWidth() * 0.2,
        love.graphics.getHeight() / 2,
        0,
        300,
        50,
        300,
        o.scale)

    Background.load(o.scale)

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

    Player.updateScale(self.scale)
    Background.updateScale(self.scale)

end

-- Similar to ui.lua, updates current scale to be as big as possible while still fitting on screen
function GameScene:calculateScale()
    local newWidth, newHeight = love.graphics.getDimensions()

    local scaleX = newWidth / designWidth
    local scaleY = newHeight / designHeight

    self.scale = math.min(scaleX, scaleY)
end

return GameScene