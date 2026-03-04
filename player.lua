local Player = {}

local designWidth = 1280
local designHeight = 720
local designScale = 5

function Player.load(posX, posY, velocityX, velocityY, accelerationX, accelerationY, 
                    decelerationX, decelerationY, maxVelocityX, maxVelocityY, scale,
                    offsetX, offsetY)

    Player.posX = posX
    Player.posY = posY

    Player.velocityX = velocityX
    Player.velocityY = velocityY

    Player.accelerationX = accelerationX
    Player.accelerationY = accelerationY

    Player.decelerationX = decelerationX
    Player.decelerationY = decelerationY

    Player.maxVelocityX = maxVelocityX
    Player.maxVelocityY = maxVelocityY

    love.graphics.setDefaultFilter('nearest', 'nearest')
    Player.image = love.graphics.newImage("images/TempPlayer.png")
    love.graphics.setDefaultFilter('linear', 'linear')

    Player.scale = 1
    Player.imageScale = Player.scale * designScale
    Player.dim = Player.image:getHeight() * Player.imageScale
    Player.rotation = 0

    Player.offsetX = 0
    Player.offsetY = 0

    Player.dx = 0
    Player.dy = 0

    Player.updateScale(scale, offsetX, offsetY)

end

function Player.update(dt)

    Player.updateVelocityX(dt)
    Player.updateVelocityY(dt)

    Player.updatePosY(dt)

    -- Slowly rotates player
    Player.rotation = (Player.rotation + (dt * 3)) % (2 * math.pi)

end

function Player.updateVelocityX(dt)

    -- Changes player velocity when left/right or a/d is pressed
    Player.velocityX = Player.velocityX + (Player.accelerationX * dt * Player.dx)

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
    if Player.velocityX > Player.maxVelocityX then
            Player.velocityX = Player.maxVelocityX
    end
    if Player.velocityX < (Player.maxVelocityX * -1) then
            Player.velocityX = (Player.maxVelocityX * -1)
    end

end

function Player.updateVelocityY(dt)

    -- Changes player velocity when up/down or w/s is pressed
    Player.velocityY = Player.velocityY + (Player.accelerationY * dt * Player.dy)

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

    if Player.velocityY > Player.maxVelocityY then
            Player.velocityY = Player.maxVelocityY
    end

    if Player.velocityY < (Player.maxVelocityY * -1) then
            Player.velocityY = (Player.maxVelocityY * -1)
    end

end

function Player.updatePosY(dt)

    -- Updates player position based on velocity and time
    Player.posY = Player.posY + Player.velocityY * dt

    -- If player reaches upper or lower bound of the game, they will stop and have their velocity set to 0
    if Player.posY < ((Player.dim / 2) + Player.offsetY) then
        Player.posY = (Player.dim / 2) + Player.offsetY
        Player.velocityY = 0
    end
    if Player.posY > (((designHeight * Player.scale) - (Player.dim / 2)) + Player.offsetY) then
        Player.posY = (((designHeight * Player.scale) - (Player.dim / 2)) + Player.offsetY)
        Player.velocityY = 0
    end

end


function Player.draw()

    love.graphics.draw(Player.image, Player.posX, Player.posY, Player.rotation, Player.imageScale, Player.imageScale, Player.image:getWidth() /2, Player.image:getHeight() / 2)

end

function Player.keypressed(key)

    if key == "left" or key == "a" then
        Player.dx = -1
    elseif key == "right" or key == "d" then
        Player.dx = 1
    else
        Player.dx = 0
    end

    if key == "up" or key == "w" then
        Player.dy = -1
    elseif key == "down" or key == "s" then
        Player.dy = 1
    else
        Player.dy = 0
    end

end

-- Updates player scale and all attributes that are affected by this new scale
function Player.updateScale(newScale, newOffsetX, newOffsetY)

    local prevScale = Player.scale
    local prevOffsetX = Player.offsetX
    local prevOffsetY = Player.offsetY

    Player.scale = newScale
    Player.imageScale = Player.scale * designScale
    Player.dim = Player.image:getHeight() * Player.imageScale

    Player.offsetX = newOffsetX
    Player.offsetY = newOffsetY

    Player.posX = ((Player.posX - prevOffsetX) * (Player.scale / prevScale)) + Player.offsetX
    Player.posY = ((Player.posY - prevOffsetY) * (Player.scale / prevScale)) + Player.offsetY

    Player.velocityX = Player.velocityX * (Player.scale / prevScale)
    Player.velocityY = Player.velocityY * (Player.scale / prevScale)

    Player.accelerationX = Player.accelerationX * (Player.scale / prevScale)
    Player.accelerationY = Player.accelerationY * (Player.scale / prevScale)

    Player.decelerationX = Player.decelerationX * (Player.scale / prevScale)
    Player.decelerationY = Player.decelerationY * (Player.scale / prevScale)

    Player.maxVelocityX = Player.maxVelocityX * (Player.scale / prevScale)
    Player.maxVelocityY = Player.maxVelocityY * (Player.scale / prevScale)

end

function Player.getVelocityX()
    return Player.velocityX
end

return Player