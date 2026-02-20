-- uiUtill.lua

-- The object that contains Ui scalling infomration
local Ui = {}

-- The design resolution for the UI. This is the resolution that the UI was designed for and will be used as the base for scaling.
local designWidth = 1280
local designHeight = 720

-- Initialize the Ui object with default values. These will be updated when the reload function is called.
Ui.scale = 1
Ui.centerX = designWidth / 2
Ui.centerY = designHeight / 2
Ui.top = 0
Ui.left = 0

-- This function should be called whenever the window is resized to recalculate the scaling and positioning of the UI elements.
function Ui:reload()
    --get the current screen dimensions
    local screenWidth, screenHeight = love.graphics.getDimensions()
    -- calculate the scale factor for each axis
    local scaleX = screenWidth / designWidth
    local scaleY = screenHeight / designHeight
    --get the minum between them to act as the base scale. This ensures that the UI will be as large as possible while still fitting on the screen while retainting the aspect ratio.
    self.scale = math.min(scaleX, scaleY)
    self.centerX = screenWidth / 2
    self.centerY = screenHeight / 2
    self.top = self.centerY - (designHeight * self.scale) / 2
    self.left = self.centerX - (designWidth * self.scale) / 2
end

-- Calculate the scaled on screen coordinate for a given position
-- @param x The x coordinate in the design space
-- @param y The y coordinate in the design space
-- @return The scaled x and y coordinates on the screen
function Ui:scaleCoord(x,y)
    local scaledX = self.left + x * self.scale
    local scaledY = self.top + y * self.scale
    return scaledX, scaledY
end

-- Calculate the scaled dimension for a given size
-- @param dim The dimension in the design space
-- @return The scaled dimension on the screen
function Ui:scaleDimension(dim)
    return dim * self.scale
end

-- Get the current scale factor
-- @return The current scale factor
function Ui:getScale()
    return self.scale
end

return Ui