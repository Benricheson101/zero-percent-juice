Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle.new()

    local self = setmetatable({}, Obstacle)

    self.posX = love.graphics.getWidth()
    self.posY = 0
    self.velocityX = 100

    return self

end

function Obstacle:update(dt)

    self.posX = self.posX - (self.velocityX * dt)

end

function Obstacle:draw()

    love.graphics.rectangle("fill", self.posX, self.posY, 25, 25)

end

function Obstacle:setPosY(newPosY)

    self.posY = newPosY

end

return Obstacle