local Scene = require('renderer.scene')
local UITextbox = require('ui.textbox')
local Ui = require('util.ui')
local fonts = require('util.fonts')

---@class UITestScene : Scene
local UITestScene = {}
setmetatable(UITestScene, { __index = Scene })
UITestScene.__index = UITestScene

function UITestScene:new()
    local o = setmetatable({}, self)
    o.input = ''
    o.liveInput = ''
    return o
end

function UITestScene:enter()
    love.keyboard.setKeyRepeat(true)
    self.textbox = UITextbox:new {
        width = 900,
        focused = true,
        placeholder = 'Enter your name for the leaderboard...',
        maxLength = 32,
        onSubmit = function(tb, value)
            tb.focused = false
            print('submitted textbox:', value)
            self.input = value
        end,

        onInput = function(_, value)
            self.liveInput = value
        end,
    }
end

function UITestScene:exit()
    love.keyboard.setKeyRepeat(false)
end

function UITestScene:draw()
    love.graphics.clear()

    local titleFont = fonts.impact75

    love.graphics.setFont(titleFont)
    love.graphics.printf(
        'Game Over',
        0,
        math.floor(Ui:getHeight() * 0.125)
            - math.floor(titleFont:getHeight() / 2),
        Ui:getWidth(),
        'center'
    )

    love.graphics.setFont(fonts.impact50)
    love.graphics.printf(
        'Score: 12345',
        0,
        math.floor(Ui:getHeight() * 0.25)
            - math.floor(titleFont:getHeight() / 2),
        Ui:getWidth(),
        'center'
    )

    local tbcanvas = self.textbox:draw()
    tbcanvas:getWidth()

    local tbCenterX = Ui.centerX - math.floor(tbcanvas:getWidth() / 2)
    local tbCenterY =
        math.floor((Ui:getHeight() * 0.375) - tbcanvas:getHeight() / 2)

    love.graphics.draw(tbcanvas, tbCenterX, tbCenterY)

    local x = Ui:scaleDimension(20)
    local gap = Ui:scaleDimension(50)
    love.graphics.print('Input: ' .. self.liveInput, x, tbCenterY + gap * 2)
    if #self.input ~= 0 then
        love.graphics.print('You typed: ' .. self.input, x, tbCenterY + gap * 3)
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
