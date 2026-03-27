local Upgrade = require('upgrade')
local colors = require('util.color')

local upgrades = {
    Upgrade:new('Tank Pressure', function(x, y, scale)--starting speed
        love.graphics.setColor(colors.hex(0x545454))
        love.graphics.rectangle('fill', x+50*scale, y+20*scale, 40*scale, 50*scale) --"tank"
        love.graphics.setColor(colors.hex(0xFF0000))
        local verticies = { -- explosion verticies
            x+90*scale, y+40*scale, 
            x+100*scale, y+28*scale, 
            x+98*scale, y+38*scale,
            x+110*scale, y+34*scale,
            x+98*scale, y+42*scale,
            x+108*scale, y+44*scale,
            x+97*scale, y+46*scale,
            x+105*scale, y+55*scale,
            x+90*scale, y+46*scale,
        }
        local triangles = love.math.triangulate(verticies)
        for i, triangle in ipairs(triangles) do
            love.graphics.polygon("fill", triangle)--draw the explosion
        end
        love.graphics.setColor(colors.hex(0x545454))
        love.graphics.setLineWidth(3*scale)
        --the guy that is being away
        love.graphics.arc("line", "open",x+102*scale, y+41*scale, 23*scale, math.rad(45), math.rad(-45))
        love.graphics.circle("fill", x+121*scale, y+28*scale, 7*scale)
        love.graphics.line(x+118*scale, y+57*scale, x+106*scale, y+53*scale)
        love.graphics.line(x+118*scale, y+57*scale, x+108*scale, y+63*scale)
        love.graphics.line(x+124*scale, y+41*scale, x+117*scale, y+38*scale)
        love.graphics.line(x+124*scale, y+41*scale, x+117*scale, y+43*scale)
        
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
