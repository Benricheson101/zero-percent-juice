local Ui = require('util.ui')
local Assets = require('util.assets')

Entity = {}
Entity.__index = Entity

-- local designWidth = 1280
-- local designHeight = 720
local designScale = 5

function Entity.new(opts)
    local self = setmetatable({}, Entity)

    self.posX = opts.posX
    self.posY = opts.posY
    self.velocityX = opts.velocityX

    self.image = nil
    self.imagePath = opts.image

    self.dim = 16 * designScale
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

    self.image = Assets.loadImage(self.imagePath, 'nearest')

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
