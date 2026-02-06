Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle.new()

    local self = setmetatable({}, Obstacle)

    self.xPos = love.graphics.getWidth()
    self.yPos = 0
    self.velocityX = 100
    self.width = 25
    self.height = 25

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

return Obstacle