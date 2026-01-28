function love.load()
    --love.graphics.setBackgroundColor(1, 1, 1)

    GlobalWidth = love.graphics.getWidth()
    GlobalHeight = love.graphics.getHeight()

    player = {}
    player.x = GlobalWidth * 0.2
    player.y = GlobalHeight / 2 - 50

    PosX = 0

    VelocityX = 0
    VelocityY = 0

    AccelerationX = 100
    AccelerationY = 100

    DecelerationX = 30
    DecelerationY = 30

end

function love.update(dt)

    -- Change Velocity by Acceleration amount when arrow key is down
    -- Might change up and down to move a static amount in the future
    -- Might also add in a speed cap in the future as well
    if love.keyboard.isDown("up") then
		VelocityY = VelocityY - AccelerationY * dt
	end

    if love.keyboard.isDown("down") then
		VelocityY = VelocityY + AccelerationY * dt
	end

    if love.keyboard.isDown("left") then
		VelocityX = VelocityX - AccelerationX * dt
	end

    if love.keyboard.isDown("right") then
		VelocityX = VelocityX + AccelerationX * dt
	end


    -- Move player based on current velocity
    -- Right now player doesn't move on x-axis, PosX is updated instead
    -- Once background is included, it will appear as though the player is moving
    player.y = player.y + VelocityY * dt
    PosX = PosX + VelocityX * dt
    

    -- Loops player back to the top or bottom of the screen once they reach the upper or lower bounds
    -- Might change later to make top or bottom completely impassible instead of looping to the other side
    while player.y < 0 do
        player.y = player.y + (GlobalHeight - 100)
    end

    while player.y > GlobalHeight - 100 do
        player.y = player.y - (GlobalHeight - 100)
    end


    -- Uses deceleration to decrease the velocity and bring it closer to 0 over time
    if VelocityX > 0 then
        VelocityX = VelocityX - DecelerationX * dt
        if VelocityX < 0 then
            VelocityX = 0
        end
    end

    if VelocityX < 0 then
        VelocityX = VelocityX + DecelerationX * dt
        if VelocityX > 0 then
            VelocityX = 0
        end
    end

    if VelocityY > 0 then
        VelocityY = VelocityY - DecelerationY * dt
        if VelocityY < 0 then
            VelocityY = 0
        end
    end

    if VelocityY < 0 then
        VelocityY = VelocityY + DecelerationY * dt
        if VelocityY > 0 then
            VelocityY = 0
        end
    end

end

function love.draw()
    -- Draws a rectangle representing the player
    love.graphics.rectangle("fill", player.x, player.y, 100, 100)

    -- Displays X and Y positions and X and Y velocities
    love.graphics.print(string.format("Current X Position: %d", PosX), 0, 0)
    love.graphics.print(string.format("Current Y Position: %d", player.y), 0, 50)
    love.graphics.print(string.format("Current X Velocity: %d", VelocityX), 0, 100)
    love.graphics.print(string.format("Current Y Velocity: %d", VelocityY), 0, 150)

end