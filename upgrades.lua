local Upgrade = require("upgrade")


local upgrades = {
    Upgrade:new("Upgrade 1", function(x,y,scale)
        love.graphics.setColor(1,0,0)
        love.graphics.circle("fill",x+100*scale,y+40*scale,30*scale)
    end, function(level) return 100 * (level + 1) end),
    Upgrade:new("Upgrade 2", function(x,y,scale)
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle("fill",x+50*scale,y+20*scale,100*scale,40*scale)
    end, function(level) return 150 * (level + 1) end),
    Upgrade:new("Upgrade 3", function(x,y,scale)
        love.graphics.setColor(0,0,1)
        love.graphics.polygon("fill", x+100*scale,y,x+143.3*scale,y+75*scale,x+56.7*scale,y+75*scale)
    end, function(level) return 200 * (level + 1) end),
    Upgrade:new("Upgrade 4", function(x,y,scale)
        love.graphics.setColor(1,1,0)
        love.graphics.ellipse("fill",x+100*scale,y+40*scale,30*scale,20*scale)
    end, function(level) return 250 * (level + 1) end),
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