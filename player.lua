local Player = {}

function Player.load()
    Player.xPos = GlobalWidth * .2
    Player.yPos = love.graphics.getHeight() / 2
    Player.radius = 25

    -- Only Y because that is all the player is doing.
    Player.velocityY = 0
    Player.accelerationY = 100
    Player.decelerationY = 30
    Player.maxVelocityY = 600
    Player.minVelocityY = -600
end

function Player.update(dt)
    -- Acceleration (only up and down)
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		Player.velocityY = Player.velocityY - Player.accelerationY * dt
	end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
		Player.velocityY = Player.velocityY + Player.accelerationY * dt
	end

    -- Adjusting Player Position
    Player.yPos = Player.yPos + Player.velocityY * dt

    Player.yPos = Player.yPos % GlobalHeight

    -- Deceleration
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

    if Player.velocityY < Player.minVelocityY then
            Player.velocityY = Player.minVelocityY
    end
end

function Player.draw()
    love.graphics.circle("fill", Player.xPos, Player.yPos, Player.radius)
end

function Player.collided()

    Player.velocityY = Player.velocityY - 300
    if Player.velocityY < 0 then
        Player.velocityY = 0
    end

end

return Player