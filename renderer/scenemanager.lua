---@class SceneManager
---@field active Scene
---@field scenes table<string, Scene>
--
-- ----- love2d callback functions. copy these to ./renderer/scene.lua -----
--
---@field update fun(self: SceneManager, dt: number)
---@field draw fun(self: SceneManager)
---@field keypressed fun(self: SceneManager, key: string, scancode: string, isrepeat: boolean)
---@field keyreleased fun(self: SceneManager, key: string, scancode: string)
---@field mousepressed fun(self: SceneManager, x: number, y: number, button: number, istouch: boolean, presses: number)
---@field mousereleased fun(self: SceneManager, x: number, y: number, button: number, istouch: boolean, presses: number)
---@field resize fun(self: SceneManager, w: number, h: number)
local SceneManager = {}
SceneManager.__index = SceneManager

---@param scenes table<string, Scene> scene objects mapped to names
function SceneManager:new(scenes)
    local o = setmetatable({}, self)

    o.scenes = {}
    o.active = nil

    for name, scene in pairs(scenes) do
        o:add(name, scene)
    end

    return o
end

---Transitions from one scene to the next and runs lifecycle functions
---@param next string the next state to render
function SceneManager:transition(next)
    assert(self.scenes[next], 'cannot transition to scene ' .. ', state does not exist')

    local next_scene = self.scenes[next]

    if self.active then
        self.active:exit()
    end

    self.active = next_scene
    self.active:enter()
end

---Add (or replace) a scene in the scene manager
---@param name string
---@param scene Scene
function SceneManager:add(name, scene)
    scene.scene_manager = self
    self.scenes[name] = scene
end

local love_callbacks = {
    'update',
    'draw',
    'keypressed',
    'keyreleased',
    'mousepressed',
    'mousereleased',
    'resize',
}

for _, name in ipairs(love_callbacks) do
    ---@param self SceneManager
    SceneManager[name] = function (self, ...)
        assert(self.active, 'SceneManager is not initialized. Trying to call callback method `' .. name .. '`')

        if self.active[name] then
            self.active[name](self.active, ...)
        end
    end
end

return SceneManager
