---@class BaseUIElement
---@field scene Scene
---@field x integer
---@field y integer
---@field width integer
---@field height integer
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

    o.x = opts.x or 0
    o.y = opts.y or 0
    o.width = opts.width or 0
    o.height = opts.height or 0
    o.worldBounds = {
        {o.x, o.y},
        {o.width + o.x, o.height + o.y},
    }

    return o
end

---@returns love.Canvas
function BaseUIElement:draw()
    return love.graphics.newCanvas(self.width, self.height)
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

---@param dt number
function BaseUIElement:update(dt)
end

return BaseUIElement
