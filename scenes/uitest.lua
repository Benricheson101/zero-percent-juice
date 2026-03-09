local Scene = require('renderer.scene')
local UITextbox = require('ui.textbox')

---@class UITestScene : Scene
---@field textbox UITextbox
local UITestScene = {}
setmetatable(UITestScene, {__index = Scene})
UITestScene.__index = UITestScene

function UITestScene:new()
    local o = setmetatable({}, self)
    return o
end

function UITestScene:enter()
    self.textbox = UITextbox:new {
        width = 900,
    }
end

function UITestScene:draw()
    love.graphics.clear()
    love.graphics.draw(self.textbox:draw(), 20, 100)
end

---@param str string
function UITestScene:textinput(str)
    self.textbox.value = self.textbox.value .. str
end

---@param key string
function UITestScene:keypressed(key)
    if key == "backspace" then
        self.textbox.value = self.textbox.value:sub(1, -2)
        return
    end
end

function UITestScene:update(dt)
    self.textbox:update(dt)
end

return UITestScene
