Upgrade = Object:extend()

function Upgrade:new(name, drawIconFunc, priceFunc, unlockScore)
    self.name = name
    self.drawIconFunc = drawIconFunc
    self.priceFunc = priceFunc
    self.unlockScore = unlockScore
    self.level = 0
end

function Upgrade:drawIcon(x, y)
    self.drawIconFunc(x, y, self.level)
end

function Upgrade:getPrice()
    return self.priceFunc(self.level)
end

all_upgrades = {
    --example upgrades
    Upgrade(
        "Speed Boost",--name
        function(x, y, level) -- drawIconFunc
            setColor(0, 0, 1)
            rectangle("fill", x, y, 50, 50)
            setColor(1, 1, 1)
            text("S", x + 15, y + 15)
        end,
        function(level) return (level + 1) * 15 end, -- priceFunc
        0 -- unlockScore
    ),
    Upgrade(
        "Fuel Efficiency", --name
        function(x, y, level)-- drawIconFunc
            setColor(0, 1, 0)
            rectangle("fill", x, y, 50, 50)
            setColor(1, 1, 1)
            text("F", x + 15, y + 15)
        end,
        function(level) return (level + 1) * 20 end,-- priceFunc
        10-- unlockScore
    ),
    Upgrade(
        "Shield Strength",-- name
        function(x, y, level) -- drawIconFunc
            setColor(1, 0, 0)
            rectangle("fill", x, y, 50, 50)
            setColor(1, 1, 1)
            text("H", x + 15, y + 15)
        end,
        function(level) return (level + 1) * 25 end,-- priceFunc
        20 -- unlockScore
    )
}