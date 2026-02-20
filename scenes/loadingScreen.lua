local Ui = require("util.ui")
local Scene = require("renderer.scene")
local fonts = require("util.fonts")

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
    
    local dim = Ui:scaleDimension(720)
    local index = 1
    local percent = 1- (counter/10)
    local offsetX = 0
    local offsetY = 0
    if percent < 0.5 then
        index = 2
    end
    if percent < 0 then
        index = 3
        offsetX = 6
        offsetY = 6
    end
    local posX,posY =Ui:scaleCoord(280+offsetX,offsetY)

    
    if percent <= -0.1 then
        self.scene_manager:transition('game')
    end

    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill",0,love.graphics.getHeight()*(1-percent),love.graphics.getWidth(),love.graphics.getHeight())

    percent = math.max(percent,0)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(boxes[index],posX,posY,0,dim/boxes[index]:getPixelWidth(),dim/boxes[index]:getPixelHeight())
    love.graphics.setColor(0,0,0)
    local textX,textY = Ui:scaleCoord(590,340)
    love.graphics.printf(math.floor(percent*100) .. "%",fonts.impact75,textX,textY,200*Ui:getScale(),"left")
end

function LoadingScreen:update(dt)
    counter = counter + dt
end


return LoadingScreen
