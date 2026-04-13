local GameScene = require('scenes.game')
local Ui = require('util.ui')
local Camera = require('camera')

describe('GameScene', function()
    describe('new', function()
        it('creates a new game scene', function()
            local game = GameScene:new()
            assert.is_not_nil(game)
        end)
    end)

    describe('checkObstacleCollision', function()
        it(
            'checks if an obstacle has collided with the player at the given position',
            function()
                local game = GameScene:new()

                game.ObstacleSpawner:spawn(200)
                game.ObstacleSpawner.entities[1].posX = 300

                game:checkCollision(300, 200, 10)

                assert.are.equal(450.0, Camera.velocityX)
            end
        )
    end)
end)
