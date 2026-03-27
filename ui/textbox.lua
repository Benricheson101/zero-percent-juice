local BaseUIElement = require('ui.element')
local Ui = require('util.ui')
local constants = require('util.constants')
local fonts = require('util.fonts')

---@class UITextbox : BaseUIElement
---@field value string
---@field focused boolean
---@field blinkRate number frequency of blink cycle
---@field blinkTime number elapsed time since blink cycle started
---@field caretVisible boolean
---@field onSubmit fun(self: UITextbox, value: string)
---@field onInput fun(self: UITextbox, value: string)
---@field placeholder string
---@field maxLength number
local UITextbox = {}
setmetatable(UITextbox, { __index = BaseUIElement })
UITextbox.__index = UITextbox

---@class UITextboxOptions : BaseUIElementOptions
---@field height? integer
---@field value? string
---@field focused? boolean
---@field blinkRate? number frequency of cursor blink (hz)
---@field onSubmit fun(self: UITextbox, value: string)
---@field onInput? fun(self: UITextbox, value: string)
---@field placeholder? string
---@field maxLength? number

---@param opts UITextboxOptions
function UITextbox:new(opts)
    local o = setmetatable({}, self)

    o.x = opts.x or 0
    o.y = opts.y or 0

    o.width = opts.width or 0
    o.height = opts.height or 0
    o.blinkRate = opts.blinkRate or 0.5
    o.blinkTime = 0
    o.caretVisible = true

    o.value = opts.value or ''
    o.onSubmit = opts.onSubmit
    o.focused = opts.focused
    o.placeholder = opts.placeholder or ''

    o.onInput = opts.onInput or function() end
    o.maxLength = opts.maxLength or 0

    return o
end

function UITextbox:draw()
    local padding = Ui:scaleDimension(4)
    local font = fonts.tahoma40

    local height = font:getHeight() + 2 * padding
    local width = Ui:scaleDimension(self.width)
    local maxTextWidth = width - 2 * padding
    local canvas = love.graphics.newCanvas(width, height)

    canvas:renderTo(function()
        love.graphics.clear(constants.colors.textbox.bg)

        local fullTextWidth = font:getWidth(self.value)
        local caretSpacing = Ui:scaleDimension(2)
        local caretWidth = Ui:scaleDimension(4)

        local textWidth, wrapped =
            font:getWrap(self.value:reverse(), maxTextWidth)
        local str = wrapped[1]:reverse()

        love.graphics.setFont(font)
        love.graphics.setColor(
            #self.value == 0 and constants.colors.textbox.placeholder
                or constants.colors.textbox.caret
        )
        love.graphics.printf(
            #self.value == 0 and self.placeholder or str,
            padding,
            (math.floor(height / 2) - math.floor(font:getHeight() / 2)),
            width - padding * 2,
            fullTextWidth >= maxTextWidth and 'right' or 'left'
        )

        if self.caretVisible or self.blinkRate == 0 then
            love.graphics.setColor(constants.colors.textbox.caret)
            love.graphics.rectangle(
                'fill',
                padding + textWidth + caretSpacing,
                padding,
                caretWidth,
                font:getHeight()
            )
        end

        love.graphics.setColor(constants.colors.textbox.bg)
    end)

    return canvas
end

function UITextbox:update(dt)
    if not self.focused then
        self.caretVisible = false
        return
    end

    if self.blinkRate ~= 0 then
        self.blinkTime = self.blinkTime + dt
        if self.blinkTime >= self.blinkRate then
            self.caretVisible = not self.caretVisible
            self.blinkTime = 0
        end
    end
end

function UITextbox:keypressed(key)
    if not self.focused then
        return
    end

    if key == 'backspace' then
        self.value = self.value:sub(1, -2)
    elseif key == 'return' then
        self:onSubmit(self.value)
    else
        return
    end

    self:onInput(self.value)
end

function UITextbox:textinput(str)
    if self.focused then
        if #self.value <= self.maxLength then
            self.value = self.value .. str
            self:onInput(self.value)
        end
    end
end

return UITextbox
