local Ui = require('util.ui')

local fonts = {}

--the deault font, never changes, try to avoid this
-- fonts.default = love.graphics.getFont()

---Reloads all fonts with the correct scaling factor
function fonts:reload()
    local scale = Ui:getScale()
    self.impact75 = love.graphics.newFont('assets/fonts/impact.ttf', 75 * scale)
    self.impact50 = love.graphics.newFont('assets/fonts/impact.ttf', 50 * scale)
    self.tahoma30 = love.graphics.newFont('assets/fonts/tahoma.ttf', 30 * scale)
    self.tahoma14 = love.graphics.newFont('assets/fonts/tahoma.ttf', 14 * scale)
    self.tahoma40 = love.graphics.newFont('assets/fonts/tahoma.ttf', 40 * scale)
end

return fonts
