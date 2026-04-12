local Entity = require('entity')
local upgrades = require('upgrades')

--- @class EntitySpawner
--- @field spawnUpgrade Upgrade the upgrade that effects the spawn spacing of this entity type
--- @field spawnDistance number how far the player has to travel before a new entity is spawned
--- @field baseVelocityX number the base x velocity of the entities that are spawned
--- @field velocityX number the x velocity of the entities that are spawned
--- @field image string the file path of the image that the entities that are spawned will use
--- @field showHitboxes boolean whether the hitboxes of the entities that are spawned should be shown or not
--- @field spawnUpgradeEffectFunc function the function that determins how the upgrade level effects spawn
--- @field entities Entity[] the entities that have been spawned and are still on screen
--- @field new fun(opts: table): EntitySpawner
--- @field update fun(self: EntitySpawner, dt: number): nil
--- @field draw fun(self: EntitySpawner): nil
--- @field keypressed fun(self: EntitySpawner, key: string): nil
--- @field spawn fun(self: EntitySpawner, spawnPosY: number): nil
--- @field checkCollision fun(self: EntitySpawner, posX: number, posY: number, dim: number): boolean
--- @field updateEntityVelocityX fun(self: EntitySpawner, newVelocityX: number): nil
local EntitySpawner = {}

local designWidth = 1280
local designHeight = 720

--- @class EntitySpanwerOpts
--- @field spawnUpgradeName string the name of the upgrade that effects the spawn spacing of this
--- @field spawnDistance number how far the player has to travel before a new entity is spawned
--- @field baseVelocityX number the base x velocity of the entities that are spawned
--- @field image string the file path of the image that the entities that are spawned will use
--- @field spawnUpgradeEffectFunc function<number, number> the function that determins how the upgrade level effects spawn

--- Creates a new entity spawner
--- @param self EntitySpawner
--- @param opts EntitySpanwerOpts the options for the new entity spawner
--- @return EntitySpawner the new entity spawner
---@diagnostic disable-next-line: redundant-parameter
function EntitySpawner:new(opts)
    local o = {}

    setmetatable(o, { __index = self })

    local upgradeName = opts.spawnUpgradeName
    o.spawnUpgrade = upgrades.getUpgrade(upgradeName) --get the relivant upgrade for the spawn spacing of this entity type
    o.spawnDistance = opts.spawnDistance
    o.baseVelocityX = opts.baseVelocityX
    o.velocityX = o.baseVelocityX
    o.image = opts.image
    o.showHitboxes = false
    o.spawnUpgradeEffectFunc = opts.spawnUpgradeEffectFunc --the function that determins how the upgrade level effects spawn spacing

    o.entities = {}

    return o
end

-- Spawns in Entities at a random position offscreen after the player has traveled a certain distance
-- Deletes Entities if they travel to the left offscreen
--- @param dt number deltaTime
function EntitySpawner:update(dt)
    self.spawnDistance = self.spawnDistance - (self.velocityX * dt)
    if self.spawnDistance < 0 then
        local baseSpawnDistance = designWidth
        if self.spawnUpgrade == nil then
            baseSpawnDistance = self.spawnUpgradeEffectFunc(0)
        else
            baseSpawnDistance =
                self.spawnUpgradeEffectFunc(self.spawnUpgrade.level)
        end
        self.spawnDistance = self.spawnDistance + baseSpawnDistance
        self:spawn(math.random(designHeight * 0.05, designHeight * 0.95))
    end

    for i = #self.entities, 1, -1 do
        self.entities[i]:update(dt)
        if self.entities[i].posX < (-0.1 * designWidth) then
            table.remove(self.entities, i)
        end
    end
end

-- Draws each Entity
function EntitySpawner:draw()
    for i = #self.entities, 1, -1 do
        self.entities[i]:draw()
    end
end

-- Shows hitboxes of Entities when h key is pressed
--- @param key string key that was pressed
function EntitySpawner:keypressed(key)
    if key == 'h' then
        self.showHitboxes = not self.showHitboxes
        for i = #self.entities, 1, -1 do
            self.entities[i].showHitboxes = self.showHitboxes
        end
    end
end

-- Spawns an Entity offscreen at a certain Y position
--- @param spawnPosY number the y posiiton of the new entity
function EntitySpawner:spawn(spawnPosY)
    local e = Entity.new {
        posX = designWidth * 1.5,
        posY = spawnPosY,
        velocityX = self.velocityX,
        image = self.image,
    }
    e:setPosY(spawnPosY)
    table.insert(self.entities, #self.entities + 1, e)
end

-- Checks if any Entities are colliding with another entity
-- If a collision is detected, remove that Entity and return true
-- else, return false
--- @param posX number the entity's X position (center)
--- @param posY number the entity's Y position (center)
--- @param dim number the distance from the center of the entity to the edge
--- @return boolean collisionDetected whether a collision has been detected or not
function EntitySpawner:checkCollision(posX, posY, dim)
    local collisionDetected = false

    for i = #self.entities, 1, -1 do
        local distance = math.sqrt(
            (posX - self.entities[i].posX) ^ 2
                + (posY - self.entities[i].posY) ^ 2
        )
        local collided = distance < (dim / 2 + self.entities[i].dim / 2)
        if collided then
            collisionDetected = true
            table.remove(self.entities, i)
        end
    end

    return collisionDetected
end

-- Updates velocityX to be the baseVelocityX plus the newVelocityX
-- then, updates the velocityX of each Entity to this new value
--- @param newVelocityX number how much x velocity the entities should be at above the base x velocity
function EntitySpawner:updateEntityVelocityX(newVelocityX)
    self.velocityX = self.baseVelocityX + newVelocityX
    for i = #self.entities, 1, -1 do
        self.entities[i].velocityX = self.velocityX
    end
end

return EntitySpawner
