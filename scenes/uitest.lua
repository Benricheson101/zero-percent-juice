local Scene = require('renderer.scene')
local UITextbox = require('ui.textbox')
local Ui = require('util.ui')

---@class UITestScene : Scene
local UITestScene = {}
setmetatable(UITestScene, {__index = Scene})
UITestScene.__index = UITestScene

function UITestScene:new()
    local o = setmetatable({}, self)
    o.input = ""
    o.liveInput = ""
    return o
end

function UITestScene:enter()
    self.textbox = UITextbox:new {
        width = 900,
        focused = true,
        placeholder = "enter your name",
        onSubmit = function (tb, value)
            tb.focused = false
            print("submitted textbox:", value)
            self.input = value
        end,

        onInput = function (tb, value)
            self.liveInput = value
        end
    }
end

function UITestScene:draw()
    love.graphics.clear()
    local x, y = Ui:scaleCoord(20, 100)
    love.graphics.draw(self.textbox:draw(), x, y)

    x, y = Ui:scaleCoord(20, 150)
    love.graphics.print("Input: " .. self.liveInput, x, y)
    if #self.input then
        x, y = Ui:scaleCoord(20, 200)
        love.graphics.print("You typed: " .. self.input, x, y)
    end
end

---@param str string
function UITestScene:textinput(str)
    self.textbox:textinput(str)
end

---@param key string
function UITestScene:keypressed(key)
    self.textbox:keypressed(key)
end

function UITestScene:update(dt)
    self.textbox:update(dt)
end

return UITestScene
