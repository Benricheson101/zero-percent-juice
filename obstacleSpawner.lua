local Obstacle = require('obstacle')
local ObstacleSpawner = {}
local Obstacles = {}

local designWidth = 1280
local designHeight = 720

function ObstacleSpawner.load(opts)
    --ObstacleSpawner.spawnTimer = opts.spawnTimer
    ObstacleSpawner.baseSpawnDistance = opts.baseSpawnDistance
    ObstacleSpawner.spawnDistance = ObstacleSpawner.baseSpawnDistance
    ObstacleSpawner.baseVelocityX = opts.baseVelocityX
    ObstacleSpawner.velocityX = ObstacleSpawner.baseVelocityX
    ObstacleSpawner.showHitboxes = false
end

-- Spawns in obstacles at a random position offscreen after the player has traveled a certain distance
-- Deletes obstacles if they travel to the left offscreen
--- @param dt number deltaTime
function ObstacleSpawner.update(dt)
    ObstacleSpawner.spawnDistance = ObstacleSpawner.spawnDistance
        - (ObstacleSpawner.velocityX * dt)
    if ObstacleSpawner.spawnDistance < 0 then
        ObstacleSpawner.spawnDistance = ObstacleSpawner.spawnDistance
            + ObstacleSpawner.baseSpawnDistance
        ObstacleSpawner.spawn(
            math.random(designHeight * 0.05, designHeight * 0.95)
        )
    end

    for i = #Obstacles, 1, -1 do
        Obstacles[i]:update(dt)
        if Obstacles[i].posX < (-0.1 * designWidth) then
            table.remove(Obstacles, i)
        end
    end
end

-- Draws each obstacle
function ObstacleSpawner.draw()
    for i = #Obstacles, 1, -1 do
        Obstacles[i]:draw()
    end
end

-- Shows hitboxes of obstacles when h key is pressed
--- @param key string key that was pressed
function ObstacleSpawner.keypressed(key)
    if key == 'h' then
        ObstacleSpawner.showHitboxes = not ObstacleSpawner.showHitboxes
        for i = #Obstacles, 1, -1 do
            Obstacles[i].showHitboxes = ObstacleSpawner.showHitboxes
        end
    end
end

-- Spawns an obstacle offscreen at a certain Y position
--- @param spawnPosY number the y posiiton of the new object
function ObstacleSpawner.spawn(spawnPosY)
    local o = Obstacle.new {
        posX = designWidth * 1.5,
        posY = spawnPosY,
        velocityX = ObstacleSpawner.velocityX,
    }
    o:setPosY(spawnPosY)
    table.insert(Obstacles, #Obstacles + 1, o)
end

-- Checks if any obstacles are colliding with another object
-- If a collision is detected, remove that obstacle and return true
-- else, return false
--- @param posX number the object's X position (center)
--- @param posY number the object's Y position (center)
--- @param dim number the distance from the center of the object to the edge
--- @return boolean collisionDetected whether a collision has been detected or not
function ObstacleSpawner.checkCollision(posX, posY, dim)
    local collisionDetected = false

    for i = #Obstacles, 1, -1 do
        local distance = math.sqrt(
            (posX - Obstacles[i].posX) ^ 2 + (posY - Obstacles[i].posY) ^ 2
        )
        local collided = distance < dim / 2 + Obstacles[i].dim / 2
        if collided then
            collisionDetected = true
            table.remove(Obstacles, i)
        end
    end

    return collisionDetected
end

-- Updates velocityX to be the baseVelocityX plus the newVelocityX
-- then, updates the velocityX of each obstacle to this new value
--- @param newVelocityX number how much x velocity the objects should be at above the base x velocity
function ObstacleSpawner.updateObstacleVelocityX(newVelocityX)
    ObstacleSpawner.velocityX = ObstacleSpawner.baseVelocityX + newVelocityX
    for i = #Obstacles, 1, -1 do
        Obstacles[i].velocityX = ObstacleSpawner.velocityX
    end
end

return ObstacleSpawner
