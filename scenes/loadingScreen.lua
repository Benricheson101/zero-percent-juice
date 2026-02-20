local Ui = require("util.ui")
local Scene = require("renderer.scene")

---@class loadingScreen : Scene
local LoadingScreen = {}
setmetatable(LoadingScreen, {__index = Scene})
LoadingScreen.__index = LoadingScreen


local boxes = {
    love.graphics.newImage("assets/loadingScreen/natural fruit blend.png"),
    love.graphics.newImage("assets/loadingScreen/artifical flavour blend.png"),
    love.graphics.newImage("assets/loadingScreen/Experimental Flavour Synthesis.png")
}

local counter = 0


function LoadingScreen:draw()
    love.graphics.clear(0,0,0)
    local posX,posY =Ui:scaleCoord(280,0)
    local dim = Ui:scaleDimension(720)
    local index = 1
    local percent = 1- (counter/10)
    if percent < 0.5 then
        index = 2
    end
    if percent < 0 then
        index = 3
    end
    
    percent = math.max(percent,0)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(boxes[index],posX,posY,0,dim/boxes[index]:getPixelWidth(),dim/boxes[index]:getPixelHeight())
    love.graphics.setColor(0,0,0)
    local textX,textY = Ui:scaleCoord(640,360)
    love.graphics.print(math.floor(percent*100) .. "%",textX,textY)

    -- self.manager:transition('game')
    
end

function LoadingScreen:update(dt)
    counter = counter + dt
end


return LoadingScreen