local Upgrade = require('upgrade')
local colors = require('util.color')
local assets = require('util.assets')

local upgrades = {
    Upgrade:new('Tank Pressure', function(x, y, scale) --starting speed
        love.graphics.setColor(colors.hex(0x545454))
        love.graphics.rectangle(
            'fill',
            x + 50 * scale,
            y + 20 * scale,
            40 * scale,
            50 * scale
        ) --"tank"
        love.graphics.setColor(colors.hex(0xFF0000))
        local verticies = { -- explosion verticies
            x + 90 * scale,
            y + 40 * scale,
            x + 100 * scale,
            y + 28 * scale,
            x + 98 * scale,
            y + 38 * scale,
            x + 110 * scale,
            y + 34 * scale,
            x + 98 * scale,
            y + 42 * scale,
            x + 108 * scale,
            y + 44 * scale,
            x + 97 * scale,
            y + 46 * scale,
            x + 105 * scale,
            y + 55 * scale,
            x + 90 * scale,
            y + 46 * scale,
        }
        local triangles = love.math.triangulate(verticies)
        for i, triangle in ipairs(triangles) do
            love.graphics.polygon('fill', triangle) --draw the explosion
        end
        love.graphics.setColor(colors.hex(0x545454))
        love.graphics.setLineWidth(3 * scale)
        --the guy that is being away
        love.graphics.arc(
            'line',
            'open',
            x + 102 * scale,
            y + 41 * scale,
            23 * scale,
            math.rad(45),
            math.rad(-45)
        )
        love.graphics.circle('fill', x + 121 * scale, y + 28 * scale, 7 * scale)
        love.graphics.line(
            x + 118 * scale,
            y + 57 * scale,
            x + 106 * scale,
            y + 53 * scale
        )
        love.graphics.line(
            x + 118 * scale,
            y + 57 * scale,
            x + 108 * scale,
            y + 63 * scale
        )
        love.graphics.line(
            x + 124 * scale,
            y + 41 * scale,
            x + 117 * scale,
            y + 38 * scale
        )
        love.graphics.line(
            x + 124 * scale,
            y + 41 * scale,
            x + 117 * scale,
            y + 43 * scale
        )
    end, function(level)
        return 7 * (level + 1) * level + 10
    end),
    Upgrade:new(
        'Rock Reducer',
        function(x, y, scale) --Obstacle spacing upgrade
            local sprite = assets.loadImage('images/Obstacle.png', 'nearest')
            love.graphics.setColor(colors.hex(0xFFFFFF))
            love.graphics.draw(
                sprite,
                x + 20 * scale,
                y + 20 * scale,
                0,
                3 * scale,
                3 * scale
            )
            love.graphics.draw(
                sprite,
                x + 140 * scale,
                y + 20 * scale,
                0,
                3 * scale,
                3 * scale
            )
            love.graphics.setLineWidth(3 * scale)
            love.graphics.setColor(colors.hex(0x545454))
            love.graphics.line(
                x + 80 * scale,
                y + 45 * scale,
                x + 130 * scale,
                y + 45 * scale
            )
            love.graphics.polygon(
                'fill',
                x + 70 * scale,
                y + 45 * scale,
                x + 80 * scale,
                y + 40 * scale,
                x + 80 * scale,
                y + 50 * scale
            )
            love.graphics.polygon(
                'fill',
                x + 140 * scale,
                y + 45 * scale,
                x + 130 * scale,
                y + 40 * scale,
                x + 130 * scale,
                y + 50 * scale
            )
        end,
        function(level)
            return 8 * (level + 1) * level + 25
        end
    ),
    Upgrade:new('Rock Buster', function(x, y, scale) --Obstacle damage upgrade
        local sprite = assets.loadImage('images/Obstacle.png', 'nearest')
        love.graphics.setColor(colors.hex(0xFFFFFF))
        love.graphics.draw(
            sprite,
            x + 90 * scale,
            y + 15 * scale,
            0,
            4.5 * scale,
            4.5 * scale
        )
        love.graphics.setColor(colors.hex(0x5B537C))
        -- partilces coming of the rock
        love.graphics.polygon(
            'fill',
            x + 90 * scale,
            y + 15 * scale,
            x + 98 * scale,
            y + 15 * scale,
            x + 100 * scale,
            y + 35 * scale
        )
        love.graphics.polygon(
            'fill',
            x + 80 * scale,
            y + 70 * scale,
            x + 86 * scale,
            y + 70 * scale,
            x + 94 * scale,
            y + 55 * scale
        )

        --the guy smashing the rock
        love.graphics.setColor(colors.hex(0x545454))
        love.graphics.circle('fill', x + 75 * scale, y + 45 * scale, 7 * scale)
        love.graphics.setLineWidth(3 * scale)
        love.graphics.line(
            x + 75 * scale,
            y + 45 * scale,
            x + 45 * scale,
            y + 45 * scale
        )
        love.graphics.line(
            x + 45 * scale,
            y + 45 * scale,
            x + 35 * scale,
            y + 40 * scale
        )
        love.graphics.line(
            x + 45 * scale,
            y + 45 * scale,
            x + 35 * scale,
            y + 50 * scale
        )

        love.graphics.line(
            x + 55 * scale,
            y + 45 * scale,
            x + 70 * scale,
            y + 55 * scale
        )
        love.graphics.line(
            x + 55 * scale,
            y + 45 * scale,
            x + 48 * scale,
            y + 37 * scale
        )
    end, function(level)
        return 8 * (level + 1) * level + 30
    end),
    Upgrade:new('Coin Replictor', function(x, y, scale) --Coin spawn upgrade
        local sprite = assets.loadImage('images/Coin.png', 'nearest')
        love.graphics.setColor(colors.hex(0xFFFFFF))
        love.graphics.draw(
            sprite,
            x + 20 * scale,
            y + 30 * scale,
            0,
            2 * scale,
            2 * scale
        )
        love.graphics.draw(
            sprite,
            x + 140 * scale,
            y + 20 * scale,
            0,
            2 * scale,
            2 * scale
        )
        love.graphics.draw(
            sprite,
            x + 150 * scale,
            y + 40 * scale,
            0,
            2 * scale,
            2 * scale
        )
        love.graphics.draw(
            sprite,
            x + 125 * scale,
            y + 30 * scale,
            0,
            2 * scale,
            2 * scale
        )
        love.graphics.setLineWidth(3 * scale)
        love.graphics.setColor(colors.hex(0x545454))
        love.graphics.line(
            x + 60 * scale,
            y + 45 * scale,
            x + 110 * scale,
            y + 45 * scale
        )
        love.graphics.polygon(
            'fill',
            x + 120 * scale,
            y + 45 * scale,
            x + 110 * scale,
            y + 40 * scale,
            x + 110 * scale,
            y + 50 * scale
        )
    end, function(level)
        return 8 * (level + 1) * level + 40
    end),
    Upgrade:new('Profit Boost', function(x, y, scale) --Coin value upgrade
        local sprite = assets.loadImage('images/Coin.png', 'nearest')
        love.graphics.setColor(colors.hex(0xFFFFFF))
        love.graphics.draw(
            sprite,
            x + 80 * scale,
            y + 20 * scale,
            0,
            3 * scale,
            3 * scale
        )
        love.graphics.setColor(colors.hex(0x545454))
        love.graphics.setLineWidth(3 * scale)
    end, function(level)
        return 9 * (level + 1) * level + 45
    end),
    Upgrade:new("Boosters", function (x ,y, scale)
        love.graphics.setColor(colors.hex(0xFFFFFF))
        local sprite = assets.loadImage('images/Powerup.png', 'nearest')
        love.graphics.draw(
            sprite,
            x + 75 * scale,
            y + 20 * scale,
            0,
            3 * scale,
            3 * scale
        )
    end, function(level)
        return 150+(40 * level * level)
    end),
    Upgrade:new("Boost Power", function (x ,y, scale)
        local sprite = assets.loadImage('assets/upgradeScreen/SuperPowerup.png', 'nearest')
        love.graphics.setColor(colors.hex(0xFFFFFF))
        love.graphics.draw(
            sprite,
            x + 75 * scale,
            y + 20 * scale,
            0,
            3 * scale,
            3 * scale
        )
    end, function(level)
        return 10 * (level + 1) * level + 50
    end),
}

---Get an upgrade by name
---@param name string the name of the upgrade to find
---@return Upgrade|nil the upgrade with the given name or nil if there is not upgrade with that name
upgrades.getUpgrade = function(name)
    for i = 1, #upgrades do
        if upgrades[i].name == name then
            return upgrades[i]
        end
    end
    return nil
end

return upgrades
