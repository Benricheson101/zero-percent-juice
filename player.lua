local Ui = require('util.ui')

local Player = {}

-- local designWidth = 1280
local designHeight = 720
local designScale = 5

function Player.load(opts)
    Player.posX = opts.posX
    Player.posY = opts.posY

    Player.velocityX = opts.velocityX
    Player.velocityY = opts.velocityY

    Player.accelerationX = opts.accelerationX
    Player.accelerationY = opts.accelerationY

    Player.decelerationX = opts.decelerationX
    Player.decelerationY = opts.decelerationY

    Player.maxVelocityX = opts.maxVelocityX
    Player.maxVelocityY = opts.maxVelocityY

    Player.decelerationX = opts.decelerationX
    Player.decelerationY = opts.decelerationY

    Player.maxVelocityX = opts.maxVelocityX
    Player.maxVelocityY = opts.maxVelocityY

    love.graphics.setDefaultFilter('nearest', 'nearest')
    Player.image = love.graphics.newImage('images/TempPlayer.png')
    love.graphics.setDefaultFilter('linear', 'linear')

    Player.dim = Player.image:getHeight() * designScale
    Player.rotation = 0

    Player.dx = 0
    Player.dy = 0

    -- Player.updateScale(scale)
    Player.showHitboxes = false

    Player.directionKeys = {
        up = false,
        down = false,
        left = false,
        right = false,
        w = false,
        a = false,
        s = false,
        d = false,
    }
end

-- Updates Player's velocity, position, and rotation
--- @param dt number deltaTime
function Player.update(dt)
    -- Player.updateVelocityX(dt)
    Player.updateVelocityY(dt)

    Player.setDirection()

    Player.updateVelocityX(dt)
    Player.updateVelocityY(dt)

    Player.updatePosY(dt)

    -- Slowly rotates player
    Player.rotation = (Player.rotation + (dt * 3)) % (2 * math.pi)

    -- Slowly rotates player
    Player.rotation = (Player.rotation + (dt * 3)) % (2 * math.pi)
end

-- NOTE: This probably is a temp function, Camera will handle the x velocity
-- Updates Player's X velocity
--- @param dt number deltaTime
function Player.updateVelocityX(dt)
    -- Changes player velocity when left/right or a/d is pressed
    Player.velocityX = Player.velocityX
        + (Player.accelerationX * dt * Player.dx)

    -- Slowly decreases their velocity over time
    if Player.velocityX > 0 then
        Player.velocityX = Player.velocityX - Player.decelerationX * dt
        if Player.velocityX < 0 then
            Player.velocityX = 0
        end
    end
    if Player.velocityX < 0 then
        Player.velocityX = Player.velocityX + Player.decelerationX * dt
        if Player.velocityX > 0 then
            Player.velocityX = 0
        end
    end

    -- Caps player velocity
    -- if Player.velocityX > Player.maxVelocityX then
    --         Player.velocityX = Player.maxVelocityX
    -- end
    -- if Player.velocityX < (Player.maxVelocityX * -1) then
    --         Player.velocityX = (Player.maxVelocityX * -1)
    -- end
end

-- Updates Player's Y velocity
--- @param dt number deltaTime
function Player.updateVelocityY(dt)
    -- Changes player velocity when up/down or w/s is pressed
    Player.velocityY = Player.velocityY
        + (Player.accelerationY * dt * Player.dy)

    -- Slowly decreases their velocity over time
    if Player.velocityY > 0 then
        Player.velocityY = Player.velocityY - Player.decelerationY * dt
        if Player.velocityY < 0 then
            Player.velocityY = 0
        end
    end

    if Player.velocityY < 0 then
        Player.velocityY = Player.velocityY + Player.decelerationY * dt
        if Player.velocityY > 0 then
            Player.velocityY = 0
        end
    end

    -- if Player.velocityY > Player.maxVelocityY then
    --         Player.velocityY = Player.maxVelocityY
    -- end
    if Player.velocityY < 0 then
        Player.velocityY = Player.velocityY + Player.decelerationY * dt
        if Player.velocityY > 0 then
            Player.velocityY = 0
        end
    end

    -- Caps player velocity
    if Player.velocityY > Player.maxVelocityY then
        Player.velocityY = Player.maxVelocityY
    end

    if Player.velocityY < (Player.maxVelocityY * -1) then
        Player.velocityY = (Player.maxVelocityY * -1)
    end

    -- if Player.velocityY < (Player.maxVelocityY * -1) then
    --         Player.velocityY = (Player.maxVelocityY * -1)
    -- end
end

-- Updates Player's Y position
--- @param dt number deltaTime
function Player.updatePosY(dt)
    -- Updates player position based on velocity and time
    Player.posY = Player.posY + Player.velocityY * dt

    -- If player reaches upper or lower bound of the game, they will stop and have their velocity set to 0
    if Player.posY < (Player.dim / 2) then
        Player.posY = (Player.dim / 2)
        Player.velocityY = 0
    end
    if Player.posY > (designHeight - (Player.dim / 2)) then
        Player.posY = (designHeight - (Player.dim / 2))
        Player.velocityY = 0
    end

    -- Slowly rotates player
    Player.rotation = (Player.rotation + (dt * 3)) % (2 * math.pi)
end

-- Scales and draws player sprite
function Player.draw()
    local posX, posY = Ui:scaleCoord(Player.posX, Player.posY)
    local scale = Ui:getScale()
    love.graphics.draw(
        Player.image,
        posX,
        posY,
        Player.rotation,
        scale * designScale,
        scale * designScale,
        Player.image:getWidth() / 2,
        Player.image:getHeight() / 2
    )

    if Player.showHitboxes then
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle(
            'fill',
            posX,
            posY,
            Player.image:getWidth() * scale * designScale / 2
        )
    end
end

-- Changes player movement direction when keys are pressed
-- Also shows player's hitbox when h is pressed
---@param key string key that was pressed
function Player.keypressed(key)
    if Player.directionKeys[key] ~= nil then
        Player.directionKeys[key] = true
    end

    if key == 'h' then
        Player.showHitboxes = not Player.showHitboxes
    end
end

-- Sets player movement direction back to 0 when key is released
---@param key string key that was released
function Player.keyreleased(key)
    if key == 'left' or key == 'a' or key == 'right' or key == 'd' then
        Player.dx = 0
    end

    if Player.directionKeys[key] ~= nil then
        Player.directionKeys[key] = false
    end
end

function Player.setDirection()
    local dx, dy = 0, 0

    if Player.directionKeys['up'] or Player.directionKeys['w'] then
        dy = dy - 1
    end
    if Player.directionKeys['down'] or Player.directionKeys['s'] then
        dy = dy + 1
    end

    if Player.directionKeys['left'] or Player.directionKeys['a'] then
        dx = dx - 1
    end
    if Player.directionKeys['right'] or Player.directionKeys['d'] then
        dx = dx + 1
    end

    Player.dx = dx
    Player.dy = dy
end

-- Returns current x velocity
--- @return number Player.velocityX current x velocity
function Player.getVelocityX()
    return Player.velocityX
end

function Player.changeVelocityX(changeX)
    local newX = Player.velocityX + changeX

    if newX > Player.maxVelocityX then
        newX = Player.maxVelocityX
    end
    if newX < (-1 * Player.maxVelocityX) then
        newX = -1 * Player.maxVelocityX
    end

    if Player.velocityX > 0 and newX < 0 then
        newX = 0
    end
    if Player.velocityX < 0 and newX > 0 then
        newX = 0
    end

    Player.velocityX = newX
end

Player.money = 1000

return Player
