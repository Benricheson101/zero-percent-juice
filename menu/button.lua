local constants = require('constants')

---@class MenuButton
local MenuButton = {}

function MenuButton:new(o)
    o = o or {}

    self.font = o.font or constants.fonts.button
    self.text = o.text or 'Button Text'
    self.state = o.state or 'default'

    self.width = o.width or self.font:getWidth(self.text)
    self.height = o.height or self.font:getHeight()

    -- self.canvas = o.canvas or love.graphics.newCanvas(o.width, o.height)

    self.canvas = o.canvas or love.graphics.newCanvas(self.width, self.height)

    self.on_click = o.on_click or function() end

    self.world_bounds = {
        { x = 0, y = 0 },
        { x = 0, y = 0 },
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

function MenuButton:draw()
    love.graphics.setCanvas(self.canvas)

    love.graphics.clear(
        self.state == 'hover' and constants.colors.ui.button_stroke_hover
            or constants.colors.ui.button_stroke
    )

    love.graphics.setColor(constants.colors.ui.button_background)

    love.graphics.rectangle('fill', 10, 10, self.width - 20, self.height - 20)

    love.graphics.setColor(constants.colors.ui.button_fill)
    love.graphics.setFont(self.font)

    love.graphics.printf(
        self.text,
        0,
        math.floor(self.height / 2) - math.floor(self.font:getHeight() / 2),
        self.width,
        'center'
    )

    love.graphics.setCanvas()

    return self.canvas
end

return MenuButton
