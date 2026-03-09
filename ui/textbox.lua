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
local UITextbox = {}
setmetatable(UITextbox, {__index = BaseUIElement})
UITextbox.__index = UITextbox

---@class UITextboxOptions : BaseUIElementOptions
---@field height? integer
---@field value? string
---@field focused? boolean
---@field blinkRate? number frequency of cursor blink (hz)

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

    o.value = opts.value or ""

    return o
end

function UITextbox:draw()
    local padding = Ui:scaleDimension(4)
    local font = fonts.tahoma40

    local height = font:getHeight() + 2 * padding
    local width = Ui:scaleDimension(self.width)
    local maxTextWidth = width - 2 * padding
    local canvas = love.graphics.newCanvas(width, height)

    canvas:renderTo(function ()
        love.graphics.clear(constants.colors.textbox.bg)

        local fullTextWidth = font:getWidth(self.value)
        local caretSpacing = Ui:scaleDimension(2)
        local caretWidth = Ui:scaleDimension(4)

        local textWidth, wrapped = font:getWrap(self.value:reverse(), maxTextWidth)
        local str = wrapped[1]:reverse()

        love.graphics.setFont(font)
        love.graphics.setColor(0x00, 0x00, 0xff)
        love.graphics.printf(
            str,
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
    if self.blinkRate ~= 0 then
        self.blinkTime = self.blinkTime + dt
        if self.blinkTime >= self.blinkRate then
            self.caretVisible = not self.caretVisible
            self.blinkTime = 0
        end
    end
end

return UITextbox
