function love.load()

    DebugPrint = false

    GlobalHeight = love.graphics.getHeight()
    GlobalWidth = love.graphics.getWidth()

    Camera = {}
    Camera.x = 0

    Player = {}
    Player.y = GlobalHeight / 2

    TotalDistance = 0

    VelocityX = 0
    VelocityY = 0

    AccelerationX = 100
    AccelerationY = 100

    DecelerationX = 30
    DecelerationY = 30

    -- Image testing
    Background = love.graphics.newImage("TEST_ONLY_IMAGE.png")
    BackgroundHeight = Background:getHeight()
    BackgroundWidth = Background:getWidth()
end

function love.keypressed(key)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("f11") then
        DebugPrint = not DebugPrint
    end
end

function love.update(dt)
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		VelocityY = VelocityY - AccelerationY * dt
	end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
		VelocityY = VelocityY + AccelerationY * dt
	end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		VelocityX = VelocityX - AccelerationX * dt
	end

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		VelocityX = VelocityX + AccelerationX * dt
	end

    Player.y = Player.y + VelocityY * dt
    Camera.x = Camera.x + VelocityX * dt

    -- Calculates the furthest score.
    if not (TotalDistance > Camera.x) then
        local calculatedDistance = VelocityX * dt
        if calculatedDistance > 0 then
            TotalDistance = TotalDistance + calculatedDistance
        end
    end
    

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
    -- love.graphics.print(table.concat({
    --     string.format("Current X Position: %d\n", PosX),
    --     string.format("Current Y Position: %d\n", player.y),
    --     string.format("Current X Velocity: %d\n", VelocityX),
    --     string.format("Current Y Velocity: %d\n", VelocityY)
    -- }))

    local offset = Camera.x % BackgroundWidth
    love.graphics.draw(Background, -offset, 0)

    if DebugPrint then
        love.graphics.print(table.concat({
            string.format("Total Distance: %d\n", TotalDistance),
            string.format("Current Camera X Position: %d\n", Camera.x),
            string.format("Current Player Y Position: %d\n", Player.y),
            string.format("Current Camera X Velocity: %d\n", VelocityX),
            string.format("Current Player Y Velocity: %d\n", VelocityY),
            string.format("FPS: %d\n", love.timer.getFPS())
        }))
    end
    
    love.graphics.circle("fill", GlobalWidth * .2, Player.y, 25)    
end