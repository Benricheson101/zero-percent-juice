
--- @class Upgrade
--- @field name string The name of the upgrade
--- @field drawSprite fun(x: number, y: number, scale: number)
--- @field getPriceFunction fun(level: number):number
--- @field level number The current level of the upgrade
--- @field getLevel fun(self: Upgrade):number Get the current level of the upgrade
--- @field getPrice fun(self: Upgrade):number Get the price of the next level of the upgrade
local Upgrade = {}
Upgrade.__index = Upgrade -- very nessarry apperently

---Creates a new upgreade
---@param name string The name of the upgrade
---@param drawSpriteFunciton fun(x: number, y: number, scale: number) A function that draws the sprite for the upgrade
---@param priceFuncion fun(level: number):number A function that returns the price of the next level of the upgrade based on the current level
function Upgrade:new(name, drawSpriteFunciton, priceFuncion)
    local o = setmetatable({}, self)
    o.name = name
    o.drawSprite = drawSpriteFunciton
    o.getPriceFunction = priceFuncion
    o.level = 0
    return o
end

function Upgrade:getLevel()
    return self.level
end

function Upgrade:getPrice()
    return self.getPriceFunction(self.level)
end

function Upgrade:draw(x,y,scale)
    self.drawSprite(x,y,scale)
end

-- the specifics of how each upgrade effects the game are implnted by whatever it effects, they should explicity look for the upgreade in question when preforming its funcion

return Upgrade