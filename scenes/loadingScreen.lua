local Ui = require("util.ui")
local Scene = require("renderer.scene")
local fonts = require("util.fonts")

---@class loadingScreen : Scene
local LoadingScreen = {}
setmetatable(LoadingScreen, {__index = Scene})
LoadingScreen.__index = LoadingScreen


--images to display during "loading"
local boxes = {
    love.graphics.newImage("assets/loadingScreen/natural fruit blend.png"),
    love.graphics.newImage("assets/loadingScreen/artifical flavour blend.png"),
    love.graphics.newImage("assets/loadingScreen/Experimental Flavour Synthesis.png")
}

local counter = 0


function LoadingScreen:draw()
    love.graphics.clear(0,0,0)
    
    local dim = Ui:scaleDimension(720)--the size the juice box images should be diplayed at
    local index = 1
    --computer the "loading" percent
    local percent1 = 1- (counter/10)
    local percent = (1 - math.cos(percent1 * math.pi)) / 2
    if(percent1 <= 0) then
        percent = percent1
    end
    --determinate what image to show based on percent
    if percent < 0.5 then
        index = 2
    end
    if percent < 0 then
        index = 3
    end
    --calculate the position to display the image
    local posX,posY =Ui:scaleCoord(280,0)

    --if we reached the end of the loading, go to the next screen
    if percent <= -0.1 then
        self.scene_manager:transition('upgrade')
    end

    --draw the background rectanlge that does down
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill",0,love.graphics.getHeight()*(1-percent),love.graphics.getWidth(),love.graphics.getHeight())

    --draw the juice box and percent text
    percent = math.max(percent,0)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(boxes[index],posX,posY,0,dim/boxes[index]:getPixelWidth(),dim/boxes[index]:getPixelHeight())
    love.graphics.setColor(0,0,0)
    local textX,textY = Ui:scaleCoord(590,340)
    love.graphics.printf(math.floor(percent*100) .. "%",fonts.impact75,textX,textY,200*Ui:getScale(),"left")--intentially aligned to the left
end

function LoadingScreen:update(dt)
    counter = counter + dt--increase the progess counter
    --if we want we can actually load assets here
end


return LoadingScreen
