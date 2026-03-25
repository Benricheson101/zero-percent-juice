local Object = require('object')
local ObjectSpawner = {}
local Objects = {}

local designWidth = 1280
local designHeight = 720

--function ObjectSpawner.load(opts)
    --ObjectSpawner.spawnTimer = opts.spawnTimer
    --ObjectSpawner.baseSpawnDistance = opts.baseSpawnDistance
    --ObjectSpawner.spawnDistance = opts.spawnDistance
    --ObjectSpawner.baseVelocityX = opts.baseVelocityX
    --ObjectSpawner.velocityX = ObjectSpawner.baseVelocityX
    --ObjectSpawner.image = opts.image
    --ObjectSpawner.showHitboxes = false
--end

function ObjectSpawner:new(opts)

    local o = {}

    setmetatable(o, {__index = self})

    o.baseSpawnDistance = opts.baseSpawnDistance
    o.spawnDistance = opts.spawnDistance
    o.baseVelocityX = opts.baseVelocityX
    o.velocityX = o.baseVelocityX
    o.image = opts.image
    o.showHitboxes = false

    o.objects = {}

    return o

end

-- Spawns in Objects at a random position offscreen after the player has traveled a certain distance
-- Deletes Objects if they travel to the left offscreen
--- @param dt number deltaTime
function ObjectSpawner:update(dt)
    self.spawnDistance = self.spawnDistance
        - (self.velocityX * dt)
    if self.spawnDistance < 0 then
        self.spawnDistance = self.spawnDistance
            + self.baseSpawnDistance
        self:spawn(
            math.random(designHeight * 0.05, designHeight * 0.95)
        )
    end

    for i = #self.objects, 1, -1 do
        self.objects[i]:update(dt)
        if self.objects[i].posX < (-0.1 * designWidth) then
            table.remove(self.objects, i)
        end
    end
end

-- Draws each Object
function ObjectSpawner:draw()
    for i = #self.objects, 1, -1 do
        self.objects[i]:draw()
    end
end

-- Shows hitboxes of Objects when h key is pressed
--- @param key string key that was pressed
function ObjectSpawner:keypressed(key)
    if key == 'h' then
        self.showHitboxes = not self.showHitboxes
        for i = #self.objects, 1, -1 do
            self.objects[i].showHitboxes = self.showHitboxes
        end
    end
end

-- Spawns an Object offscreen at a certain Y position
--- @param spawnPosY number the y posiiton of the new object
function ObjectSpawner:spawn(spawnPosY)
    local o = Object.new {
        posX = designWidth * 1.5,
        posY = spawnPosY,
        velocityX = self.velocityX,
        image = self.image
    }
    o:setPosY(spawnPosY)
    table.insert(self.objects, #self.objects + 1, o)
end

-- Checks if any Objects are colliding with another object
-- If a collision is detected, remove that Object and return true
-- else, return false
--- @param posX number the object's X position (center)
--- @param posY number the object's Y position (center)
--- @param dim number the distance from the center of the object to the edge
--- @return boolean collisionDetected whether a collision has been detected or not
function ObjectSpawner:checkCollision(posX, posY, dim)
    local collisionDetected = false

    for i = #self.objects, 1, -1 do
        local distance = math.sqrt(
            (posX - self.objects[i].posX) ^ 2 + (posY - self.objects[i].posY) ^ 2
        )
        local collided = distance < dim / 2 + self.objects[i].dim / 2
        if collided then
            collisionDetected = true
            table.remove(self.objects, i)
        end
    end

    return collisionDetected
end

-- Updates velocityX to be the baseVelocityX plus the newVelocityX
-- then, updates the velocityX of each Object to this new value
--- @param newVelocityX number how much x velocity the objects should be at above the base x velocity
function ObjectSpawner:updateObjectVelocityX(newVelocityX)
    self.velocityX = self.baseVelocityX + newVelocityX
    for i = #self.objects, 1, -1 do
        self.objects[i].velocityX = self.velocityX
    end
end

return ObjectSpawner
