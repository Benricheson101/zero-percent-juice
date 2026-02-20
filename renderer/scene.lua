-- Abstract class for a game scene. Each scene can override the love2d callback methods that
-- it needs to use. The function signatures are below. An example scene implementation
-- can be found in `./scenes/example.lua`
---@class Scene
---@field new fun(self: Scene): Scene
---@field enter fun(self: Scene)
---@field exit fun(self: Scene)
--
---@field update? fun(self: SceneManager, dt: number)
---@field draw? fun(self: SceneManager)
---@field keypressed? fun(self: SceneManager, key: string, scancode: string, isrepeat: boolean)
---@field keyreleased? fun(self: SceneManager, key: string, scancode: string)
---@field mousepressed? fun(self: SceneManager, x: number, y: number, button: number, istouch: boolean, presses: number)
---@field mousereleased? fun(self: SceneManager, x: number, y: number, button: number, istouch: boolean, presses: number)
---@field resize? fun(self: SceneManager, w: number, h: number)
local Scene = {}
Scene.__index = Scene

---Creates a new scene
function Scene:new()
    local o = setmetatable({}, self)
    return o
end

---Lifecycle method called when a scene becomes the active scene
function Scene:enter() end

---Lifecycle method called when a scene is no longer the active scene
function Scene:exit() end

return Scene
