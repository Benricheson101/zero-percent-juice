local Ui = require('util.ui')

Entity = {}
Entity.__index = Entity

local designWidth = 1280
local designHeight = 720
local designScale = 5

function Entity.new(opts)
    local self = setmetatable({}, Entity)

    self.posX = opts.posX
    self.posY = opts.posY
    self.velocityX = opts.velocityX

    love.graphics.setDefaultFilter('nearest', 'nearest')
    self.image = love.graphics.newImage(opts.image)
    love.graphics.setDefaultFilter('linear', 'linear')

    self.dim = self.image:getHeight() * designScale
    self.rotation = 0

    self.showHitboxes = false

    return self
end

-- Moves and rotates the Entity based on the deltaTime
--- @param dt number deltaTime
function Entity:update(dt)
    self.posX = self.posX - (self.velocityX * dt)

    self.rotation = (self.rotation + (dt * 1.5)) % (2 * math.pi)
end

-- Scales and draws each Entity
function Entity:draw()
    local posX, posY = Ui:scaleCoord(self.posX, self.posY)
    local scale = Ui:getScale()
    love.graphics.draw(
        self.image,
        posX,
        posY,
        self.rotation,
        scale * designScale,
        scale * designScale,
        self.image:getWidth() / 2,
        self.image:getHeight() / 2
    )

    if self.showHitboxes then
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle(
            'fill',
            posX,
            posY,
            self.image:getWidth() * scale * designScale / 2
        )
    end
end

-- Sets the Entity's Y position
--- @param newPosY number new Y position
function Entity:setPosY(newPosY)
    self.posY = newPosY
end

return Entity
