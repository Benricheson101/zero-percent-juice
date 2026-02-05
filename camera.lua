local Camera = {}

function Camera.load()
    Camera.xPos = 0

    Camera.velocityX = 100
    Camera.accelerationX = 100
    Camera.decelerationX = 30
    Camera.maxVelocityX = 1200
    Camera.minVelocityX = -1200
end

function Camera.update(dt)
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		Camera.velocityX = Camera.velocityX - Camera.accelerationX * dt
	end

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		Camera.velocityX = Camera.velocityX + Camera.accelerationX * dt
	end

    Camera.xPos = Camera.xPos + Camera.velocityX * dt

    if Camera.velocityX > 0 then
        Camera.velocityX = Camera.velocityX - Camera.decelerationX * dt
        if Camera.velocityX < 0 then
            Camera.velocityX = 0
        end
    end

    if Camera.velocityX < 0 then
        Camera.velocityX = Camera.velocityX + Camera.decelerationX * dt
        if Camera.velocityX > 0 then
            Camera.velocityX = 0
        end
    end

    if Camera.velocityX > Camera.maxVelocityX then
            Camera.velocityX = Camera.maxVelocityX
    end

    if Camera.velocityX < Camera.minVelocityX then
            Camera.velocityX = Camera.minVelocityX
    end

end


return Camera