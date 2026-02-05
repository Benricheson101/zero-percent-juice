local Player = require("player")
local Camera = require("camera")
local Sound = require("sound")

function love.load()

    DebugPrint = false

    GlobalHeight = love.graphics.getHeight()
    GlobalWidth = love.graphics.getWidth()

    Player.load()
    Camera.load()
    Sound.load()

    TotalDistance = 0

    -- Image testing
    Background = love.graphics.newImage("images/TEST_ONLY_IMAGE.png")
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
    Sound.keypressed(key)
end

function love.update(dt)
    Player.update(dt)
    Camera.update(dt)
    Sound.update(dt, Camera.velocityX)

    if not (TotalDistance > Camera.xPos) then
        local calculatedDistance = Camera.velocityX * dt
        if calculatedDistance > 0 then
            TotalDistance = TotalDistance + calculatedDistance
        end
    end
end


function love.draw()
    local offset = Camera.xPos % BackgroundWidth
    
    -- Temporal accumulation blur based on velocity
    local velocity = math.abs(Camera.velocityX)
    local numBlurFrames = math.floor(velocity / 80)
    local maxAlpha = math.min(velocity / 400, 0.85)
    
    -- Draw blur frames (older frames first, more transparent)
    for blurFrame = numBlurFrames, 1, -1 do
        local timeDelta = blurFrame * 0.022
        local pastX = Camera.xPos - (Camera.velocityX * timeDelta)
        local pastOffset = pastX % BackgroundWidth
        
        local alpha = (blurFrame / (numBlurFrames + 1)) * maxAlpha
        love.graphics.setColor(1, 1, 1, alpha)
        
        for i = -1, 2 do
            local x = (i * BackgroundWidth) - pastOffset
            love.graphics.draw(Background, x, 0)
        end
    end
    
    -- Present frame
    love.graphics.setColor(1, 1, 1, 1)
    for i = -1, 2 do
        local x = (i * BackgroundWidth) - offset
        love.graphics.draw(Background, x, 0)
    end

    if DebugPrint then
        love.graphics.print(table.concat({
            string.format("Total Distance: %d\n", TotalDistance),
            string.format("Current Camera X Position: %d\n", Camera.xPos),
            string.format("Current Player Y Position: %d\n", Player.yPos),
            string.format("Current Camera X Velocity: %d\n", Camera.velocityX),
            string.format("Current Player Y Velocity: %d\n", Player.velocityY),
            string.format("FPS: %d\n", love.timer.getFPS())
        }))
    end
    
    Player.draw()
end