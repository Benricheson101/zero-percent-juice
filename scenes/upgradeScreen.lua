local Ui = require("util.ui")
local Scene = require("renderer.scene")
local fonts = require("util.fonts")
local color = require("util.color")

---@class upgradeScreen : Scene
local UpgradeScreen = {}
setmetatable(UpgradeScreen, {__index = Scene})
UpgradeScreen.__index = UpgradeScreen

local tankBody = love.graphics.newImage("assets/upgradeScreen/tank_gradient.png")
local tankTop = love.graphics.newImage("assets/upgradeScreen/tank_top.png")

--- Draws the juice tank witht the pressure valve at the inptut position
--- @param pressure number the pressure of the juice in the tank, between 0 and 1
local function drawTank(pressure)
    --the tank its self
    local topTankX,topTankY = Ui:scaleCoord(640-250,150)
    local tankWidth = Ui:scaleDimension(500)
    local topHeight = Ui:scaleDimension(187.5)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(tankTop,topTankX,topTankY,0,tankWidth/tankTop:getWidth(),topHeight/tankTop:getHeight())
    local bodyHeight = love.graphics.getHeight() - topTankY - topHeight
    love.graphics.draw(tankBody,topTankX,topTankY+topHeight,0,tankWidth/tankBody:getWidth(),bodyHeight/tankBody:getHeight())

    --the juice text
    local textX,textY = Ui:scaleCoord(440,300)
    local textWidth = Ui:scaleDimension(400)
    love.graphics.setColor(0,0,0)
    love.graphics.printf('"Juice"',fonts.impact75,textX,textY,textWidth,"center")
end

function UpgradeScreen:draw()
    love.graphics.clear(color.hex(0xa08170))
    
    drawTank(0.5)
end

return UpgradeScreen