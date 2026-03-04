Obstacle = {}
Obstacle.__index = Obstacle

local designWidth = 25
local designHeight = 25

function Obstacle.new(posX, posY, velocityX)

    local self = setmetatable({}, Obstacle)

    self.posX = posX
    self.posY = posY
    self.velocityX = velocityX
    self.width = 25
    self.height = 25
    self.scale = 1

    return self

end

function Obstacle:update(dt)

    self.xPos = self.xPos - (self.velocityX * dt)

end

function Obstacle:draw()

    love.graphics.rectangle("fill", self.xPos, self.yPos, self.width, self.height)

end

function Obstacle:setPosY(newPosY)

    self.yPos = newPosY

end

function Obstacle:updateScale(scale)



end

return Obstacle