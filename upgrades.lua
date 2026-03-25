local Upgrade = require('upgrade')
local colors = require('util.color')

local upgrades = {
    Upgrade:new('Boiler Pressure', function(x, y, scale)--starting speed
        love.graphics.setColor(colors.hex(0x545454))
        love.graphics.rectangle('fill', x+50*scale, y+20*scale, 40*scale, 50*scale)
        love.graphics.setColor(colors.hex(0xFF0000))
        local verticies = {
            x+90*scale, y+40*scale, 
            x+100*scale, y+25*scale, 
            x+98*scale, y+38*scale,
            x+110*scale, y+34*scale,
            x+98*scale, y+45*scale,
            x+105*scale, y+55*scale,
            x+90*scale, y+45*scale,

        }
        local triangles = love.math.triangulate(verticies)
        for i, triangle in ipairs(triangles) do
            love.graphics.polygon("fill", triangle)
        end
        
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
