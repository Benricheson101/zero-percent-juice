local Ui = require("util.ui")

local fonts = {}

--the deault font, never changes, try to avoid this
fonts.default = love.graphics.getFont()

---Reloads all fonts with the correct scaling factor
function fonts:reload()
    local scale = Ui:getScale()
    self.impact75 = love.graphics.newFont("assets/fonts/impact.ttf", 75 * scale)
end

return fonts