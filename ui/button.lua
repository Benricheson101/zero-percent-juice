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

    local x, y = Ui:scaleCoord(opts.x or 0, opts.y or 0)
    o.x = x
    o.y = y

    -- FIXME: resizing doesn't resize button canvas
    local width, height = Ui:scaleCoord(opts.width, opts.height)
    o.canvas = love.graphics.newCanvas(width, height)
    o.text = opts.text
    o.state = 'normal'

    o.worldBounds = {
        {o.x, o.y},
        {o.canvas:getWidth() + o.x, o.canvas:getHeight() + o.y},
    }

    o.clickCallback = opts.onClick

    return o
end

function UIButton:draw()
    self.canvas:renderTo(function ()
        love.graphics.clear(
            self.state == 'hover'
            and constants.colors.menu.button_stroke_hover
            or constants.colors.menu.button_stroke_normal
        )

        love.graphics.setColor(constants.colors.menu.button_bg)
        love.graphics.rectangle(
            'fill',
            10,
            10,
            self.canvas:getWidth() - 20,
            self.canvas:getHeight() - 20
        )

        local font = fonts.tahoma30
        love.graphics.setFont(font)
        love.graphics.setColor(constants.colors.menu.button_fill)

        love.graphics.printf(
            self.text,
            0,
            math.floor(self.canvas:getHeight() / 2) - math.floor(font:getHeight() / 2),
            self.canvas:getWidth(),
            'center'
        )

    end)

    return self.canvas
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
