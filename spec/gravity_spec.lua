local Player = require('player')

describe('Gravity_Test_Suite', function()
    local maxVelocityY = 300
    local HIGH_GRAVITY = 200
    local LOW_GRAVITY = 0
    describe('gravity calculations', function()
        it('Calculates multiple gravity values', function()
            for velX = 1, 100, 5 do
                local gravity = Player.getSpeedBasedGravity(velX, maxVelocityY)
                local speed = math.abs(velX)
                local t = math.min(speed / maxVelocityY, 1)
                local curve = t * t
                local calculated_gravity = HIGH_GRAVITY
                    + (LOW_GRAVITY - HIGH_GRAVITY) * curve

                assert.is_true(gravity == calculated_gravity)
            end
        end)
    end)
end)
