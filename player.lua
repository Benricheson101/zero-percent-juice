local Player = {}

local designWidth = 1280
local designHeight = 720
local designScale = 5

function Player.load(posX, posY, velocityY, accelerationY, decelerationY, maxVelocityY, scale)

    Player.posX = posX
    Player.posY = posY
    Player.velocityY = velocityY
    Player.accelerationY = accelerationY
    Player.decelerationY = decelerationY
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

    Player.updateScale(scale)

end

function Player.update(dt)

    -- Changes player velocity when up/down or w/s is pressed
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		Player.velocityY = Player.velocityY - Player.accelerationY * dt
	end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
		Player.velocityY = Player.velocityY + Player.accelerationY * dt
	end

    -- Updates player position based on velocity and time
    Player.posY = Player.posY + Player.velocityY * dt

    -- If player reaches upper or lower bound of the game, they will stop and have their velocity set to 0
    if Player.posY < ((Player.dim / 2) + Player.offsetY) then
        Player.posY = (Player.dim / 2) + Player.offsetY
        Player.velocityY = 0
    end
    if Player.posY > ((love.graphics.getHeight() - (Player.dim / 2)) - Player.offsetY) then
        Player.posY = (love.graphics.getHeight() - (Player.dim / 2)) - Player.offsetY
        Player.velocityY = 0
    end

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

    -- Caps player velocity
    if Player.velocityY > Player.maxVelocityY then
            Player.velocityY = Player.maxVelocityY
    end
    if Player.velocityY < (Player.maxVelocityY * -1) then
            Player.velocityY = (Player.maxVelocityY * -1)
    end

    -- Slowly rotates player
    Player.rotation = (Player.rotation + (dt * 3)) % (2 * math.pi)

end

function Player.draw()

    love.graphics.draw(Player.image, Player.posX, Player.posY, Player.rotation, Player.imageScale, Player.imageScale, Player.image:getWidth() /2, Player.image:getHeight() / 2)

end

-- Updates player scale and all attributes that are affected by this new scale
function Player.updateScale(newScale)

    local prevScale = Player.scale
    local prevOffsetX = Player.offsetX
    local prevOffsetY = Player.offsetY

    Player.scale = newScale
    Player.imageScale = Player.scale * designScale
    Player.dim = Player.image:getHeight() * Player.imageScale
    Player.offsetX = (love.graphics.getWidth() - (designWidth * Player.scale)) / 2
    Player.offsetY = (love.graphics.getHeight() - (designHeight * Player.scale)) / 2

    Player.posX = (Player.posX * (Player.scale / prevScale)) - prevOffsetX + Player.offsetX
    Player.posY = (Player.posY * (Player.scale / prevScale)) - prevOffsetY + Player.offsetY
    Player.velocityY = Player.velocityY * (Player.scale / prevScale)
    Player.accelerationY = Player.accelerationY * (Player.scale / prevScale)
    Player.decelerationY = Player.decelerationY * (Player.scale / prevScale)
    Player.maxVelocityY = Player.maxVelocityY * (Player.scale / prevScale)

end

return Player