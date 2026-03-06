---@class BaseUIElement
---@field scene Scene
---@field canvas love.Canvas
---@field x? integer
---@field y? integer
---@field worldBounds number[][]
local BaseUIElement = {}
BaseUIElement.__index = BaseUIElement

---@class BaseUIElementOptions
---@field width integer
---@field height integer
---@field x? integer
---@field y? integer

---@param opts BaseUIElementOptions
function BaseUIElement:new(opts)
    local o = setmetatable({}, self)

    o.canvas = love.graphics.newCanvas(opts.width, opts.height)
    o.x = opts.x or 0
    o.y = opts.y or 0
    o.worldBounds = {
        {o.x, o.y},
        {o.canvas:getWidth() + o.x, o.canvas:getHeight() + o.y},
    }

    return o
end

---@returns love.Canvas
function BaseUIElement:draw()
    love.graphics.setCanvas(self.canvas)

    love.graphics.setCanvas()
    return self.canvas
end

---@param x integer
---@param y integer
function BaseUIElement:hover(x, y)
end

---@param x integer
---@param y integer
function BaseUIElement:onclick(x, y)
end

---@param x integer
---@param y integer
---@returns boolean
function BaseUIElement:isWithin(x, y)
    local tl_x, tl_y = unpack(self.worldBounds[1])
    local br_x, br_y = unpack(self.worldBounds[2])

    return x >= tl_x
        and x <= br_x
        and y >= tl_y
        and y <= br_y
end

---@param dt integer
function BaseUIElement:update(dt)
end

return BaseUIElement
