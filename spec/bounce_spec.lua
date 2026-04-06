local Player = require('player')
local Camera = require('camera')

describe('Bounce_Test_Suite', function()
    local tolerance = 0.001

    local function approxEqual(actual, expected)
        return math.abs(actual - expected) < tolerance
    end

    describe('calculateBounce', function()
        it('calculates bounce with positive velocity and positive camera velocity', function()
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
            assert.is_true(bounce1 ~= bounce2)
        end)

        it('calculates bounce with different velY values', function()
            Camera.velocityX = 100
            local bounce1 = Player.calculateBounce(-30, 300)
            local bounce2 = Player.calculateBounce(-60, 300)
            local expected1 = 30 * 100 * (0.5 * math.abs(100) / 300)
            local expected2 = 60 * 100 * (0.5 * math.abs(100) / 300)
            assert.is_true(approxEqual(bounce1, expected1))
            assert.is_true(approxEqual(bounce2, expected2))
            assert.is_true(bounce2 > bounce1)
        end)
    end)
end)