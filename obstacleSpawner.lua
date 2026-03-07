local Obstacle = require("obstacle")
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

function ObstacleSpawner.update(dt)

    ObstacleSpawner.spawnDistance = ObstacleSpawner.spawnDistance - (ObstacleSpawner.velocityX * dt)
    if ObstacleSpawner.spawnDistance < 0 then
        ObstacleSpawner.spawnDistance = ObstacleSpawner.spawnDistance + ObstacleSpawner.baseSpawnDistance
        ObstacleSpawner.spawn(math.random(designHeight * 0.05, designHeight * 0.95))
    end

    for i = #Obstacles, 1, -1 do
        Obstacles[i]:update(dt)
        if Obstacles[i].posX < (-0.1 * designWidth) then
           table.remove(Obstacles, i) 
        end
    end

end

function ObstacleSpawner.draw()

    for i = #Obstacles, 1, -1 do
        Obstacles[i]:draw()
    end

end

function ObstacleSpawner.keypressed(key)

    if key == "h" then
        ObstacleSpawner.showHitboxes = not ObstacleSpawner.showHitboxes
        for i = #Obstacles, 1, -1 do
            Obstacles[i].showHitboxes = ObstacleSpawner.showHitboxes
        end
    end

end

function ObstacleSpawner.spawn(spawnPosY)

    local o = Obstacle.new({
        posX = designWidth * 1.5,
        posY = spawnPosY,
        velocityX = ObstacleSpawner.velocityX
    })
    o:setPosY(spawnPosY)
    table.insert(Obstacles, #Obstacles + 1, o)

end

function ObstacleSpawner.checkCollision(posX, posY, dim)

    local collisionDetected = false

    for i = #Obstacles, 1, -1 do
        local distance = math.sqrt((posX - Obstacles[i].posX) ^ 2 + (posY - Obstacles[i].posY) ^ 2)
        local collided = distance < dim / 2 + Obstacles[i].dim / 2
        if collided then
            collisionDetected = true
            table.remove(Obstacles, i)
        end
    end

    return collisionDetected

end

function ObstacleSpawner.updateObstacleVelocityX(newVelocityX)

    ObstacleSpawner.velocityX = ObstacleSpawner.baseVelocityX + newVelocityX
    for i = #Obstacles, 1, -1 do
        Obstacles[i].velocityX = ObstacleSpawner.velocityX
    end

end

return ObstacleSpawner