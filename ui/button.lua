local BaseUIElement = require('ui.element')
local Ui = require('util.ui')
local constants = require('util.constants')
local fonts = require('util.fonts')

---@class UIButton : BaseUIElement
---@field text string
---@field state 'hover'|'normal
---@field clickCallback fun(self: UIButton)
local UIButton = {}
setmetatable(UIButton, {__index = BaseUIElement})
UIButton.__index = UIButton

---@class UIButtonOptions : BaseUIElementOptions
---@field text string
---@field onClick fun(self: UIButton)

---@param opts UIButtonOptions
function UIButton:new(opts)
    local o = setmetatable({}, self)

    o.x = opts.x or 0
    o.y = opts.y or 0

    o.width = opts.width or 0
    o.height = opts.height or 0
    o.text = opts.text
    o.state = 'normal'

    o.worldBounds = {
        {o.x, o.y},
        {o.width + o.x, o.height + o.y},
    }

    o.clickCallback = opts.onClick

    return o
end

function UIButton:draw()
    local width, height = Ui:scaleDimension(self.width, self.height)
    local canvas = love.graphics.newCanvas(width, height)

    canvas:renderTo(function ()
        local strokeSize = Ui:scaleDimension(10)

        love.graphics.clear(
            self.state == 'hover'
            and constants.colors.menu.button_stroke_hover
            or constants.colors.menu.button_stroke_normal
        )

        love.graphics.setColor(constants.colors.menu.button_bg)
        love.graphics.rectangle(
            'fill',
            strokeSize,
            strokeSize,
            width - strokeSize * 2,
            height - strokeSize * 2
        )

        local font = fonts.tahoma30
        love.graphics.setFont(font)
        love.graphics.setColor(constants.colors.menu.button_fill)

        love.graphics.printf(
            self.text,
            0,
            math.floor(height / 2) - math.floor(font:getHeight() / 2),
            width,
            'center'
        )

    end)

    return canvas
end

function UIButton:onclick(x, y)
    self:clickCallback()
end

function UIButton:hover(x, y)
    self.state = 'hover'
end

function UIButton:update()
    self.state = 'normal'
end

return UIButton
