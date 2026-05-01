local Camera = {}

function Camera.load(Player)
    Camera.xPos = 0

    -- This recieves the value of xvelocity from player
    -- this makes more sense for an upgrade to increase max player
    -- speed rather than camera speed
    Camera.velocityX = Player.maxVelocityX
    -- Same thing for deceleration
    Camera.decelerationX = Player.decelerationX

    Camera.maxVelocityX = Player.maxVelocityX
    Camera.maxVelocityY = Player.maxVelocityY
end

function Camera.updateVelocityX(dt)
    -- Deceleration
    if Camera.velocityX > 0 then
        Camera.velocityX = Camera.velocityX - (Camera.decelerationX * dt)
        if Camera.velocityX < 0 then
            Camera.velocityX = 0
        end
    end

    -- Deceleration backwards
    if Camera.velocityX < 0 then
        Camera.velocityX = Camera.velocityX + (Camera.decelerationX * dt)
        if Camera.velocityX > 0 then
            Camera.velocityX = 0
        end
    end
end

function Camera.update(dt)
    Camera.xPos = Camera.xPos + Camera.velocityX * dt

    -- NOTE:
    -- Debug: making it possible to increase and decrease velocity
    -- normally we will not be able to do this
    -- if love.keyboard.isDown('=') then -- basically '+' without having to hit shift
    --     -- print("Increasing vel:", Camera.velocityX)
    --     -- Camera.velocityX = Camera.velocityX + 25
    --     Camera.changeVelocityX(25)
    -- end
    -- if love.keyboard.isDown('-') then
    --     -- print("Decreasing vel:", Camera.velocityX)
    --     -- Camera.velocityX = Camera.velocityX - 25
    --     Camera.changeVelocityX(-25)
    -- end
    --
    Camera.updateVelocityX(dt)

    -- print("Current vel: ", Camera.velocityX)
end

-- Similar stucture to AS would have the collision loss here but that is
-- not implemented yet (hence, leaving it out for now)

function Camera.changeVelocityX(changeX)
    local newX = Camera.velocityX + changeX

    if newX > Camera.maxVelocityX then
        newX = Camera.maxVelocityX
    end

    if Camera.velocityX > 0 and newX < 0 then
        newX = 0
    end

    if newX < 0 then
        newX = 0
    end

    Camera.velocityX = newX

    -- print('Cam Vel X:', Camera.velocityX)
    -- print('newX:', newX)
end

function Camera.getVelocityX()
    return Camera.velocityX
end

function Camera.getMaxVelocityX()
    return Camera.maxVelocityX
end

-- Also would do upgrade stuff here same as above
-- Would also do similar thing where player has the data and we just
-- pass player and handle it that way so upgrade logic is simple
-- to read and implement

return Camera
