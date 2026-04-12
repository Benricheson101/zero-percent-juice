local Camera = require('camera')

describe('Camera_Suite', function()
    local tolerance = 0.001

    local function approxEqual(actual, expected)
        return math.abs(actual - expected) < tolerance
    end

    describe('load', function()
        it('initializes camera from player properties', function()
            local mockPlayer = {
                maxVelocityX = 500,
                maxVelocityY = 400,
                decelerationX = 50
            }
            Camera.load(mockPlayer)

            assert.is_true(Camera.xPos == 0)
            assert.is_true(Camera.velocityX == 500)
            assert.is_true(Camera.decelerationX == 50)
            assert.is_true(Camera.maxVelocityX == 500)
            assert.is_true(Camera.maxVelocityY == 400)
        end)
    end)

    describe('updateVelocityX', function()
        it('decelerates positive velocity to zero', function()
            Camera.velocityX = 100
            Camera.decelerationX = 50
            Camera.updateVelocityX(2)

            assert.is_true(approxEqual(Camera.velocityX, 0))
        end)

        it('decelerates positive velocity but stays positive', function()
            Camera.velocityX = 200
            Camera.decelerationX = 50
            Camera.updateVelocityX(1)

            assert.is_true(approxEqual(Camera.velocityX, 150))
        end)

        it('decelerates negative velocity to zero', function()
            Camera.velocityX = -100
            Camera.decelerationX = 50
            Camera.updateVelocityX(2)

            assert.is_true(approxEqual(Camera.velocityX, 0))
        end)

        it('decelerates negative velocity but stays negative', function()
            Camera.velocityX = -200
            Camera.decelerationX = 50
            Camera.updateVelocityX(1)

            assert.is_true(approxEqual(Camera.velocityX, -150))
        end)

        it('handles zero velocity', function()
            Camera.velocityX = 0
            Camera.updateVelocityX(1)

            assert.is_true(Camera.velocityX == 0)
        end)
    end)

    describe('changeVelocityX', function()
        before_each(function()
            Camera.maxVelocityX = 500
            Camera.velocityX = 0
        end)

        it('adds positive change within bounds', function()
            Camera.changeVelocityX(100)

            assert.is_true(Camera.velocityX == 100)
        end)

        it('clamps change exceeding max velocity', function()
            Camera.changeVelocityX(600)

            assert.is_true(Camera.velocityX == 500)
        end)

        it('clamps negative change to zero', function()
            Camera.velocityX = 100
            Camera.changeVelocityX(-150)

            assert.is_true(Camera.velocityX == 0)
        end)

        it('prevents crossing from positive to negative', function()
            Camera.velocityX = 50
            Camera.changeVelocityX(-100)

            assert.is_true(Camera.velocityX == 0)
        end)

        it('clamps negative velocity to zero', function()
            Camera.velocityX = -100
            Camera.changeVelocityX(-50)

            assert.is_true(Camera.velocityX == 0)
        end)
    end)

    describe('getVelocityX', function()
        it('returns current velocityX', function()
            Camera.velocityX = 250

            local vel = Camera.getVelocityX()

            assert.is_true(vel == 250)
        end)
    end)
end)