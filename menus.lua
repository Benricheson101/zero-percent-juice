local M = {}

--aliases to make life easier
local rectangle = love.graphics.rectangle
local circle = love.graphics.circle
local width = love.graphics.getWidth
local height = love.graphics.getHeight
local setColor = love.graphics.setColor
local setLineWidth = love.graphics.setLineWidth
local arc = love.graphics.arc
local matrixPush = love.graphics.push
local matrixPop = love.graphics.pop
local rotate = love.graphics.rotate
local translate = love.graphics.translate
local mouseX = love.mouse.getX
local mouseY = love.mouse.getY
local text = love.graphics.print
local textf = love.graphics.printf

--global variables
all_upgrades = {1,1,1,1,1} --dummy values for now
consolas_32 = love.graphics.newFont("assets/consola.ttf", 32)


-- main menu:
-- load save
-- upgrades
-- start game
function M.drawMainMenu()
    love.graphics.printf("Main Menu", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Press ....... to Start", 0, 200, love.graphics.getWidth(), "center")
end

-- how much currency
-- available upgrades
function M.drawUpgradesMenu()
    love.graphics.clear(160/255, 129/255, 112/255)
    --tank
    setColor(137/255, 137/255, 137/255)
    rectangle("fill", width()/2-200, height()/2-200, 400, 500)
    --pressure gauge
    local maxAngle = math.rad(-45)
    local minAngle = math.rad(-180)
    local distToCenter = math.sqrt( (mouseX() - width()/2)^2 + (mouseY() - height()/2)^2 )
    local inCenter = false
    local needleAngle = maxAngle
    if distToCenter > 100 then
        if distToCenter > 500 then
            needleAngle = minAngle
        else
            distToCenter = distToCenter - 100
            local t = distToCenter / 400
            needleAngle = maxAngle + t * (minAngle - maxAngle)--lerp
        end
    else 
        inCenter = true
    end

    setColor(1, 1, 1)
    circle("fill", width()/2, height()/2, 100)
    if inCenter then
        setColor(1,1,0)
    else
        setColor(0.2, 0.2, 0.2)
    end
    setLineWidth(5)
    circle("line", width()/2, height()/2, 100)
    setColor(0, 0.8, 0)
    arc("fill", width()/2, height()/2, 80, math.rad(-180), math.rad(-100))
    setColor(0.95, 0.95, 0)
    arc("fill", width()/2, height()/2, 80, math.rad(-100), math.rad(-45))
    setColor(0.8, 0, 0)
    arc("fill", width()/2, height()/2, 80, math.rad(-45), math.rad(0))
    setColor(1, 1, 1)
    circle("fill", width()/2, height()/2, 70)
    --the needle on the guage
    

    matrixPush()
    translate(width()/2, height()/2)
    rotate(needleAngle)
    -- translate(-width()/2, -height()/2)
    setColor(0.4,0.4,0.4)
    rectangle("fill",0,-5, 75, 10)
    matrixPop()
    setColor(0,0,0)
    text("Pressure", width()/2 - 25, height()/2 + 50)

    for i=1, #all_upgrades do
        --draw each upgrade box
        setColor(140/255, 135/255, 135/255)
        local topX = 20+ (width()-190)*((i-1)%2)
        local topY = 50 + math.floor((i-1)/2)*110
        rectangle("fill", topX, topY, 150, 100)
        setLineWidth(3)
        setColor(0.3,0.3,0.3)
        rectangle("line", topX, topY, 150, 70) -- icon / name box
        rectangle("line", topX, topY+70, 75, 30) -- price box
        rectangle("line", topX+75, topY+70, 75, 30) -- level box
        setColor(0,0,0)
        text("Upgrade " .. i, topX + 10, topY + 10) -- upgrade name
        text("$" .. (all_upgrades[i]*10), topX + 10, topY + 75)-- price
        text("Level: " .. all_upgrades[i], topX + 80, topY+75)-- level
        --draw upgrade icon here
        
    end

    setColor(232/255, 220/255, 44/255)
    textf("Currency: $$$$$$", consolas_32,190, 20,width()-2*190, "center")

end

function M.drawSplash()
end

return M
