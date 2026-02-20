local Scene = require("renderer.scene")
local Player = require('player')

---@class GameScene : Scene
local GameScene = {}
setmetatable(GameScene, {__index = Scene})
GameScene.__index = GameScene

function GameScene:new()
    local o = setmetatable({}, self)

    Player.load(
        love.graphics.getWidth() * 0.2,
        love.graphics.getHeight() / 2,
        0,
        300,
        50,
        300
    )

    return o
end

function GameScene:update(dt)
    Player.update(dt)
end

function GameScene:draw()
    Player.draw()
end

return GameScene
