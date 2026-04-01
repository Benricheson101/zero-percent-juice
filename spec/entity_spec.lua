local Entity = require('entity')

describe('Entity', function()

    describe('new', function()
        it('creates an entity with the correct position, velocity, and image', function()

            local entity = Entity.new {
                posX = 1000,
                posY = 800,
                velocityX = 100,
                image = 'images/Obstacle.png'
            }

            assert.are.equal(1000, entity.posX)
            assert.are.equal(800, entity.posY)
            assert.are.equal(100, entity.velocityX)
            assert.are.equal('images/Obstacle.png', entity.imagePath)

        end)
    end)

    describe('update', function() 

        it('updates the position and the rotation of the entity based on the velocity and deltaTime', function() 

            local entity = Entity.new {
                posX = 1000,
                posY = 800,
                velocityX = 100,
                image = 'images/Obstacle.png'
            }

            entity:update(1)

            assert.are.equal(900, entity.posX)
            assert.are.equal(1.5, entity.rotation)

        end)

    end)

end)