local Obstacle = require("obstacle")
local ObstacleSpawner = {}
local Obstacles = {}

function ObstacleSpawner.load()

    ObstacleSpawner.spawnTimer = 5

end

function ObstacleSpawner.update(dt)

    ObstacleSpawner.spawnTimer = ObstacleSpawner.spawnTimer - dt
    if ObstacleSpawner.spawnTimer < 0 then
        ObstacleSpawner.spawnTimer = ObstacleSpawner.spawnTimer + 5
        ObstacleSpawner.spawn(math.random(love.graphics.getHeight()))
    end

    for i = #Obstacles, 1, -1 do
        Obstacles[i]:update(dt)
        if Obstacles[i].xPos < -100 then
           table.remove(Obstacles, i) 
        end
    end

end

function ObstacleSpawner.draw()

    for i = #Obstacles, 1, -1 do
        Obstacles[i]:draw()
    end

end

function ObstacleSpawner.spawn(spawnPosY)

    local o = Obstacle.new()
    o:setPosY(spawnPosY)
    table.insert(Obstacles, #Obstacles + 1, o)

end

function ObstacleSpawner.checkCollision(xPos, yPos, width, height)

    local collisionDetected = false

    for i = #Obstacles, 1, -1 do
        local collided = xPos < Obstacles[i].xPos + Obstacles[i].width and
                         Obstacles[i].xPos < xPos + width and
                         yPos < Obstacles[i].yPos + Obstacles[i].height and
                         Obstacles[i].yPos < yPos + height
        if collided then
            collisionDetected = true
            table.remove(Obstacles, i)
        end
    end

    return collisionDetected

end

return ObstacleSpawner