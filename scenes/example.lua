local Scene = require("renderer.scene")

---@class ExampleScene : Scene
local ExampleScene = {}
setmetatable(ExampleScene, {__index = Scene})
ExampleScene.__index = ExampleScene

function ExampleScene:enter()
    print("Entered example scene")
end

return ExampleScene
