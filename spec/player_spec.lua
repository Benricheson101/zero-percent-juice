local Player = require('player')
local Camera = require('camera')

describe('Player_Suite', function()
    local tolerance = 0.001

    local function approxEqual(actual, expected)
        return math.abs(actual - expected) < tolerance
    end

    describe('load', function()
        it('initializes player with all properties', function()
            Player.load {
                posX = 100,
                posY = 200,
                velocityX = 10,
                velocityY = 20,
                accelerationX = 300,
                accelerationY = 400,
                decelerationX = 50,
                decelerationY = 60,
                maxVelocityX = 500,
                maxVelocityY = 600,
            }

            assert.is_true(Player.posX == 100)
            assert.is_true(Player.posY == 200)
            assert.is_true(Player.velocityX == 10)
            assert.is_true(Player.velocityY == 20)
            assert.is_true(Player.accelerationX == 300)
            assert.is_true(Player.accelerationY == 400)
            assert.is_true(Player.decelerationX == 50)
            assert.is_true(Player.decelerationY == 60)
            assert.is_true(Player.maxVelocityX == 500)
            assert.is_true(Player.maxVelocityY == 600)
        end)

        it('sets default values', function()
            Player.load {
                posX = 0,
                posY = 0,
                velocityX = 0,
                velocityY = 0,
                accelerationX = 1,
                accelerationY = 1,
                decelerationX = 1,
                decelerationY = 1,
                maxVelocityX = 1,
                maxVelocityY = 1,
            }

            assert.is_true(Player.dim == 80)
            assert.is_true(Player.rotation == 0)
            assert.is_true(Player.dx == 0)
            assert.is_true(Player.dy == 0)
            assert.is_true(Player.score == 0)
            assert.is_true(Player.showHitboxes == false)
        end)
    end)

    describe('changeVelocityX', function()
        before_each(function()
            Player.load {
                posX = 100,
                posY = 200,
                velocityX = 0,
                velocityY = 0,
                accelerationX = 300,
                accelerationY = 300,
                decelerationX = 50,
                decelerationY = 50,
                maxVelocityX = 500,
                maxVelocityY = 600,
            }
        end)

        it('adds positive change within bounds', function()
            Player.changeVelocityX(100)

            assert.is_true(Player.velocityX == 100)
        end)

        it('clamps change exceeding max velocity', function()
            Player.changeVelocityX(600)

            assert.is_true(Player.velocityX == 500)
        end)

        it('clamps negative change exceeding -max velocity', function()
            Player.changeVelocityX(-600)

            assert.is_true(Player.velocityX == -500)
        end)

        it('prevents positive velocity crossing to negative', function()
            Player.velocityX = 50
            Player.changeVelocityX(-100)

            assert.is_true(Player.velocityX == 0)
        end)

        it('prevents negative velocity crossing to positive', function()
            Player.velocityX = -50
            Player.changeVelocityX(100)

            assert.is_true(Player.velocityX == 0)
        end)
    end)

    describe('getVelocityX', function()
        it('returns current velocityX', function()
            Player.velocityX = 250

            local vel = Player.getVelocityX()

            assert.is_true(vel == 250)
        end)
    end)

    describe('keypressed', function()
        before_each(function()
            Player.load {
                posX = 100,
                posY = 200,
                velocityX = 0,
                velocityY = 0,
                accelerationX = 300,
                accelerationY = 300,
                decelerationX = 50,
                decelerationY = 50,
                maxVelocityX = 500,
                maxVelocityY = 600,
            }
        end)

        it('sets direction key up', function()
            Player.keypressed('up')

            assert.is_true(Player.directionKeys.up == true)
        end)

        it('sets direction key w', function()
            Player.keypressed('w')

            assert.is_true(Player.directionKeys.w == true)
        end)

        it('sets direction key down', function()
            Player.keypressed('down')

            assert.is_true(Player.directionKeys.down == true)
        end)

        it('sets direction key s', function()
            Player.keypressed('s')

            assert.is_true(Player.directionKeys.s == true)
        end)

        it('sets direction key left', function()
            Player.keypressed('left')

            assert.is_true(Player.directionKeys.left == true)
        end)

        it('sets direction key a', function()
            Player.keypressed('a')

            assert.is_true(Player.directionKeys.a == true)
        end)

        it('sets direction key right', function()
            Player.keypressed('right')

            assert.is_true(Player.directionKeys.right == true)
        end)

        it('sets direction key d', function()
            Player.keypressed('d')

            assert.is_true(Player.directionKeys.d == true)
        end)

        it('toggles showHitboxes on h press', function()
            Player.showHitboxes = false
            Player.keypressed('h')

            assert.is_true(Player.showHitboxes == true)

            Player.keypressed('h')

            assert.is_true(Player.showHitboxes == false)
        end)
    end)

    describe('keyreleased', function()
        before_each(function()
            Player.load {
                posX = 100,
                posY = 200,
                velocityX = 0,
                velocityY = 0,
                accelerationX = 300,
                accelerationY = 300,
                decelerationX = 50,
                decelerationY = 50,
                maxVelocityX = 500,
                maxVelocityY = 600,
            }
        end)

        it('clears direction key on release', function()
            Player.directionKeys.up = true
            Player.keyreleased('up')

            assert.is_true(Player.directionKeys.up == false)
        end)

        it('clears dx on left release', function()
            Player.directionKeys.left = true
            Player.dx = -1
            Player.keyreleased('left')

            assert.is_true(Player.dx == 0)
        end)

        it('clears dx on a release', function()
            Player.directionKeys.a = true
            Player.dx = -1
            Player.keyreleased('a')

            assert.is_true(Player.dx == 0)
        end)

        it('clears dx on right release', function()
            Player.directionKeys.right = true
            Player.dx = 1
            Player.keyreleased('right')

            assert.is_true(Player.dx == 0)
        end)

        it('clears dx on d release', function()
            Player.directionKeys.d = true
            Player.dx = 1
            Player.keyreleased('d')

            assert.is_true(Player.dx == 0)
        end)
    end)

    describe('setDirection', function()
        before_each(function()
            Player.load {
                posX = 100,
                posY = 200,
                velocityX = 0,
                velocityY = 0,
                accelerationX = 300,
                accelerationY = 300,
                decelerationX = 50,
                decelerationY = 50,
                maxVelocityX = 500,
                maxVelocityY = 600,
            }
        end)

        it('sets dy to -1 when up is pressed', function()
            Player.directionKeys.up = true

            Player.setDirection()

            assert.is_true(Player.dy == -1)
        end)

        it('sets dy to 1 when down is pressed', function()
            Player.directionKeys.down = true

            Player.setDirection()

            assert.is_true(Player.dy == 1)
        end)

        it('sets dx to -1 when left is pressed', function()
            Player.directionKeys.left = true

            Player.setDirection()

            assert.is_true(Player.dx == -1)
        end)

        it('sets dx to 1 when right is pressed', function()
            Player.directionKeys.right = true

            Player.setDirection()

            assert.is_true(Player.dx == 1)
        end)

        it('handles multiple keys pressed', function()
            Player.directionKeys.up = true
            Player.directionKeys.right = true

            Player.setDirection()

            assert.is_true(Player.dy == -1)
            assert.is_true(Player.dx == 1)
        end)

        it('resets dx and dy when no keys pressed', function()
            Player.dx = 1
            Player.dy = -1

            Player.setDirection()

            assert.is_true(Player.dx == 0)
            assert.is_true(Player.dy == 0)
        end)
    end)

    describe('calculateBounce', function()
        it('calculates bounce with positive camera velocity', function()
            Camera.velocityX = 100
            local bounce = Player.calculateBounce(-50, 300)
            local expected = 50 * 100 * (0.5 * math.abs(100) / 300)

            assert.is_true(approxEqual(bounce, expected))
        end)

        it('calculates bounce with negative camera velocity', function()
            Camera.velocityX = -100
            local bounce = Player.calculateBounce(-50, 300)
            local expected = 50 * 100 * (0.5 * math.abs(-100) / 300)

            assert.is_true(approxEqual(bounce, expected))
        end)

        it('calculates bounce with zero camera velocity', function()
            Camera.velocityX = 0
            local bounce = Player.calculateBounce(-50, 300)
            local expected = 0

            assert.is_true(approxEqual(bounce, expected))
        end)

        it('calculates bounce with different maxVelX values', function()
            Camera.velocityX = 150
            local bounce1 = Player.calculateBounce(-50, 300)
            local bounce2 = Player.calculateBounce(-50, 150)
            local expected1 = 50 * 100 * (0.5 * math.abs(150) / 300)
            local expected2 = 50 * 100 * (0.5 * math.abs(150) / 150)

            assert.is_true(approxEqual(bounce1, expected1))
            assert.is_true(approxEqual(bounce2, expected2))
        end)

        it('calculates bounce with different velY values', function()
            Camera.velocityX = 100
            local bounce1 = Player.calculateBounce(-30, 300)
            local bounce2 = Player.calculateBounce(-60, 300)
            local expected1 = 30 * 100 * (0.5 * math.abs(100) / 300)
            local expected2 = 60 * 100 * (0.5 * math.abs(100) / 300)

            assert.is_true(approxEqual(bounce1, expected1))
            assert.is_true(approxEqual(bounce2, expected2))
        end)
    end)
end)
