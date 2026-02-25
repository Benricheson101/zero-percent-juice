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

    GameScene.scale = 1
    GameScene:calculateScale()

    Player.load(
        love.graphics.getWidth() * 0.2,
        love.graphics.getHeight() / 2,
        0,
        300,
        50,
        300,
        GameScene.scale)

    Background.load(GameScene.scale)

    return o
end

function GameScene:update(dt)
    Player.update(dt)
end

function GameScene:draw()
    Background.draw()
    Player.draw()
end

-- Updates GameScene scale and passes new scale to all parts of the game
function GameScene:reload()

    GameScene:calculateScale()

    Player.updateScale(GameScene.scale)
    Background.updateScale(GameScene.scale)

end

-- Similar to ui.lua, updates current scale to be as big as possible while still fitting on screen
function GameScene:calculateScale()
    local newWidth, newHeight = love.graphics.getDimensions()

    local scaleX = newWidth / designWidth
    local scaleY = newHeight / designHeight

    GameScene.scale = math.min(scaleX, scaleY)
end

return GameScene