---@class Upgrade
Upgrade = Object:extend()

---@param name string The name of the upgrade
---@param drawIconFunc function A function that draws the icon sprite
---@param priceFunc function A function that returns the price based on level
---@param unlockScore number The score required to unlock this upgrade
function Upgrade:new(name, drawIconFunc, priceFunc, unlockScore)
    self.name = name
    self.drawIconFunc = drawIconFunc
    self.priceFunc = priceFunc
    self.unlockScore = unlockScore
    self.level = 0
end

---@param x number The x position to draw the icon
---@param y number The y position to draw the icon
function Upgrade:drawIcon(x, y)
    self.drawIconFunc(x, y, self.level)
end

---@return number The price of the upgrade based on its current level
function Upgrade:getPrice()
    return self.priceFunc(self.level)
end

---@type Upgrade[]
all_upgrades = {
    --example upgrades, It may aslo be a good idea to make real sub classes for each upgrade
    Upgrade(
        'Speed Boost', --name
        function(x, y, level) -- drawIconFunc
            love.graphics.setColor(0, 0, 1)
            love.graphics.rectangle('fill', x + 50, y + 15, 50, 50)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print('S', x + 75, y + 35)
        end,
        function(level)
            return (level + 1) * 15
        end, -- priceFunc
        0 -- unlockScore
    ),
    Upgrade(
        'Fuel Efficiency', --name
        function(x, y, level) -- drawIconFunc
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle('fill', x + 50, y + 15, 50, 50)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print('F', x + 75, y + 35)
        end,
        function(level)
            return (level + 1) * 20
        end, -- priceFunc
        10 -- unlockScore
    ),
    Upgrade(
        'Shield Strength', -- name
        function(x, y, level) -- drawIconFunc
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle('fill', x + 50, y + 15, 50, 50)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print('H', x + 75, y + 35)
        end,
        function(level)
            return (level + 1) * 25
        end, -- priceFunc
        20 -- unlockScore
    ),
}
