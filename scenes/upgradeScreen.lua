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
--- @param selected boolean wether theguage should be hilighted yellow
local function drawTank(pressure, selected)
    --pipe
    love.graphics.setColor(color.hex(0x6b6b6b))
    local pipeX,_ = Ui:scaleCoord(640-10,0)
    love.graphics.rectangle("fill",pipeX,0,Ui:scaleDimension(20),love.graphics.getHeight()/2)
    --the tank its self
    local topTankX,topTankY = Ui:scaleCoord(640-250,100)
    local tankWidth = Ui:scaleDimension(500)
    local topHeight = Ui:scaleDimension(187.5)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(tankTop,topTankX,topTankY,0,tankWidth/tankTop:getWidth(),topHeight/tankTop:getHeight())
    local bodyHeight = love.graphics.getHeight() - topTankY - topHeight
    love.graphics.draw(tankBody,topTankX,topTankY+topHeight,0,tankWidth/tankBody:getWidth(),bodyHeight/tankBody:getHeight())

    --the juice text
    local textX,textY = Ui:scaleCoord(440,250)
    local textWidth = Ui:scaleDimension(400)
    love.graphics.setColor(color.hex(0xc90000))
    love.graphics.printf('"Juice"',fonts.impact75,textX,textY,textWidth,"center")

    --pressure guage
    local guageX,guageY = Ui:scaleCoord(640,500)
    local guageRadius = Ui:scaleDimension(125)
    local guageInnerRadius = Ui:scaleDimension(120)
    if selected then 
        love.graphics.setColor(1,1,0)
    else
        love.graphics.setColor(0.3,0.3,0.3)
    end
    love.graphics.circle("fill",guageX,guageY,guageRadius)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill",guageX,guageY,guageInnerRadius)
    local labelRadius = Ui:scaleDimension(110)
    love.graphics.setColor(0,1,0)
    love.graphics.arc("fill",guageX,guageY,labelRadius,math.rad(-100),math.rad(-180))
    love.graphics.setColor(1,1,0)
    love.graphics.arc("fill",guageX,guageY,labelRadius,math.rad(-100),math.rad(-45))
    love.graphics.setColor(1,0,0)
    love.graphics.arc("fill",guageX,guageY,labelRadius,math.rad(-45),math.rad(0))
    local labelInnerRadius = Ui:scaleDimension(100)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill",guageX,guageY,labelInnerRadius)
    love.graphics.push()--push a new matrix onto the stack
    love.graphics.translate(guageX,guageY)--translate the matrix to the center of the guage
    love.graphics.rotate(math.pi*pressure-math.pi)--rotate the matrix by the angle of the pressure
    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill",0,Ui:scaleDimension(-5),Ui:scaleDimension(115),Ui:scaleDimension(10))
    love.graphics.pop()--pop the matrix off the stack, returning to the original coordinate system
    --pressure text
    local textX,textY = Ui:scaleCoord(440,530)
    love.graphics.setColor(0,0,0)
    love.graphics.printf("Pressure",fonts.tahoma30,textX,textY,Ui:scaleDimension(400),"center")
end

--- Draws a specific upgrade and the upgrade clicker
--- @param index number the index of the upgrade to draw, between 1 and 4
--- @param hilighted number 0 for no hilight, 1 for slight hilight, 2 for full hilight
local function drawUpgrade(index, hilighted)
    love.graphics.setColor(color.rgb(120,120,120))
    local upgradeX,upgradeY
    local vslot = math.floor((index-1)/2)
    if (index-1) %2 == 0 then
        upgradeX,upgradeY = Ui:scaleCoord(50,25+150*vslot)
    else
        upgradeX,upgradeY = Ui:scaleCoord(1030,25+150*vslot)
    end
    love.graphics.rectangle("fill",upgradeX,upgradeY,Ui:scaleDimension(200),Ui:scaleDimension(130))
    if hilighted == 0 then
        love.graphics.setColor(color.rgb(90,90,90))
    else if hilighted == 1 then
            love.graphics.setColor(color.rgb(150,150,0))
        else
            love.graphics.setColor(color.rgb(255,255,0))
        end
    end
    love.graphics.setLineWidth(Ui:scaleDimension(3))
    love.graphics.rectangle("line",upgradeX,upgradeY,Ui:scaleDimension(200),Ui:scaleDimension(80))
    love.graphics.rectangle("line",upgradeX,upgradeY+Ui:scaleDimension(80),Ui:scaleDimension(100),Ui:scaleDimension(50))
    love.graphics.rectangle("line",upgradeX+Ui:scaleDimension(100),upgradeY+Ui:scaleDimension(80),Ui:scaleDimension(100),Ui:scaleDimension(50))

    local colOff
    if (index-1) %2 == 0 then
        colOff = 50
    else
        colOff = 1030
    end

    --draw sprite here
    local titleX,titleY = Ui:scaleCoord(colOff,25+150*(vslot))
    local levelX,levelY = Ui:scaleCoord(colOff+3,25+150*(vslot)+95)
    local costX,costY = Ui:scaleCoord(colOff+103,25+150*(vslot)+95)
    love.graphics.setColor(0,0,0)
    love.graphics.printf("UPGRADE NAME HERE!",fonts.tahoma14,titleX,titleY,Ui:scaleDimension(200),"center")
    love.graphics.printf("LEVEL: XXX",fonts.tahoma14,levelX,levelY,Ui:scaleDimension(100),"left")
    love.graphics.printf("COST: $XXXXX",fonts.tahoma14,costX,costY,Ui:scaleDimension(100),"left")


end


function UpgradeScreen:draw()
    --tank
    love.graphics.clear(color.hex(0xa08170))
    local mouseX,mouseY = love.mouse.getPosition()
    local guageX,guageY = Ui:scaleCoord(640,500)
    local mouseDistance = math.sqrt((mouseX-guageX)^2+(mouseY-guageY)^2)
    local distancePercent = 0.75-(mouseDistance-Ui:scaleDimension(125))/Ui:scaleDimension(700)
    distancePercent = math.max(0,math.min(1,distancePercent))
    distancePercent = math.min(0.75,distancePercent)
    local jitter = math.sin(love.timer.getTime()*50)*0.03 * distancePercent
    distancePercent = distancePercent + jitter
    drawTank(distancePercent,mouseDistance < Ui:scaleDimension(125))

    --platrform

    --upgrades
    drawUpgrade(1,0)
    drawUpgrade(2,1)
    drawUpgrade(3,2)
    drawUpgrade(4,0)

end

return UpgradeScreen