local Scene = require("renderer.scene")

---@class ExampleScene : Scene
local ExampleScene = {}
setmetatable(ExampleScene, {__index = Scene})
ExampleScene.__index = ExampleScene

function ExampleScene:enter()
    print("Entered example scene")
end

function ExampleScene:draw()
    love.graphics.print("Click to switch to game scene", 400, 300)
end

function ExampleScene:mousepressed()
    self.scene_manager:transition('game')
end

return ExampleScene
