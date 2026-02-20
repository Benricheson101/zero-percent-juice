local Ui = require("util.ui")

local loadingScreen = {}

local boxes = {
    love.graphics.newImage("assets/loadingScreen/natural fruit blend.png"),
    love.graphics.newImage("assets/loadingScreen/artifical flavour blend.png"),
    love.graphics.newImage("assets/loadingScreen/Experimental Flavour Synthesis.png")
}

local counter = 0


function loadingScreen.draw()
    love.graphics.clear(0,0,0)
    local posX,posY =Ui:scaleCoord(280,0)
    local dim = Ui:scaleDimension(720)
    local index = 1
    if counter > 5 then
        index = 2
    end
    if counter > 10 then
        index = 3
    end
    local percent = 1- (counter/10)
    percent = math.max(percent,0)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(boxes[index],posX,posY,0,dim/boxes[index]:getPixelWidth(),dim/boxes[index]:getPixelHeight())
    love.graphics.setColor(0,0,0)
    local textX,textY = Ui:scaleCoord(640,360)
    love.graphics.print(math.floor(percent*100) .. "%",textX,textY)
end

function loadingScreen.update(dt)
    counter = counter + dt
end


return loadingScreen