local Upgrade = require('upgrade')

local upgrades = {
    Upgrade:new('Boiler Pressure', function(x, y, scale)--starting speed
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle(
            'fill',
            x + 100 * scale,
            y + 40 * scale,
            30 * scale
        )
    end, function(level)
        return 7 * (level + 1)*level+10
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
