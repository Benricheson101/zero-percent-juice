local LeaderboardSubmitScene = require('scenes.leaderboardSubmit')

describe('LeaderboardSubmitScene', function()
    describe('new', function()
        it('creates scene with empty input', function()
            local scene = LeaderboardSubmitScene:new()
            assert.are.equal('', scene.input)
        end)

        it('creates scene with empty liveInput', function()
            local scene = LeaderboardSubmitScene:new()
            assert.are.equal('', scene.liveInput)
        end)
    end)

    describe('textinput', function()
        it('delegates to textbox', function()
            local scene = LeaderboardSubmitScene:new()
            scene.textbox = {
                textinput = function(self, str)
                    assert.are.equal('a', str)
                end,
            }
            scene:textinput('a')
        end)
    end)

    describe('keypressed', function()
        it('delegates to textbox', function()
            local scene = LeaderboardSubmitScene:new()
            scene.textbox = {
                keypressed = function(self, key)
                    assert.are.equal('return', key)
                end,
            }
            scene:keypressed('return')
        end)
    end)

    describe('update', function()
        it('delegates to textbox', function()
            local scene = LeaderboardSubmitScene:new()
            scene.textbox = {
                update = function(self, dt)
                    assert.are.equal(0.016, dt)
                end,
            }
            scene:update(0.016)
        end)
    end)
end)
