local EntitySpawner = require('entitySpawner')
local GameScene = require('scenes.game')

describe('EntitySpawner', function ()

    describe('new', function ()

        it('creates a new instance of entitySpawner with the correct parameters', function ()

            ---@diagnostic disable-next-line: redundant-parameter
            local entitySpawner = EntitySpawner:new {
                spawnUpgradeName = 'Rock Reducer',
                spawnDistance = 1000,
                baseVelocityX = 50,
                image = 'images/Obstacle.png',
                spawnUpgradeEffectFunc = GameScene.obsticaleSpawFrequencyCalculation,

            }
            
            assert.are.equal(1000, entitySpawner.spawnDistance)
            assert.are.equal(50, entitySpawner.baseVelocityX)
            assert.are.equal('images/Obstacle.png', entitySpawner.image)

        end)
        
    end)

    describe('update', function ()

        it('Updates entities and determines if a new entity should be spawned in', function ()
        
            ---@diagnostic disable-next-line: redundant-parameter
            local entitySpawner = EntitySpawner:new {
                spawnUpgradeName = 'Rock Reducer',
                spawnDistance = 1000,
                baseVelocityX = 50,
                image = 'images/Obstacle.png',
                spawnUpgradeEffectFunc = GameScene.obsticaleSpawFrequencyCalculation,
            }

            entitySpawner:update(1)

            assert.are.equal(950, entitySpawner.spawnDistance)
        
        end)
        
    end)

    describe('spawn', function ()

        it('creates a new entity at a specific position', function ()

            ---@diagnostic disable-next-line: redundant-parameter
            local entitySpawner = EntitySpawner:new {
                spawnUpgradeName = 'Rock Reducer',
                spawnDistance = 1000,
                baseVelocityX = 50,
                image = 'images/Obstacle.png',
                spawnUpgradeEffectFunc = GameScene.obsticaleSpawFrequencyCalculation,
            }

            entitySpawner:spawn(200)

            assert.are.equal(200, entitySpawner.entities[1].posY)
            
        end)

    end)

    describe('checkCollision', function ()

        it('Checks if any entities are colliding with another object at the given dimensions', function ()

            ---@diagnostic disable-next-line: redundant-parameter
            local entitySpawner = EntitySpawner:new {
                spawnUpgradeName = 'Rock Reducer',
                spawnDistance = 1000,
                baseVelocityX = 50,
                image = 'images/Obstacle.png',
                spawnUpgradeEffectFunc = GameScene.obsticaleSpawFrequencyCalculation,
            }

            entitySpawner:spawn(200)

            local collided = entitySpawner:checkCollision(1920, 200, 10)

            assert.are.equal(true, collided)
            
        end)
        
    end)
    
end)