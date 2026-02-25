local Ui = require("util.ui")
local Scene = require("renderer.scene")
local fonts = require("util.fonts")
local color = require("util.color")

---@class upgradeScreen : Scene
local UpgradeScreen = {}
setmetatable(UpgradeScreen, {__index = Scene})
UpgradeScreen.__index = UpgradeScreen

function UpgradeScreen:draw()
    love.graphics.clear(color.hex(0xa08170))
    local textX,textY = Ui:scaleCoord(360,200)
    love.graphics.setColor(1,1,1)
    love.graphics.printf("Upgrade Screen",fonts.impact75,textX,textY,200*Ui:getScale(),"center")
end


return UpgradeScreen