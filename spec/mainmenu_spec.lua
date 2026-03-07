local MainMenuScene = require('scenes.mainmenu')
local UIButton = require('ui.button')

describe('MainMenuScene', function()
    describe('new', function()
        it('creates a new scene instance', function()
            local scene = MainMenuScene:new()
            assert.is_not_nil(scene)
        end)
    end)

    describe('mousepressed', function()
        local scene
        local clickedButton

        before_each(function()
            clickedButton = nil
            scene = MainMenuScene:new()
            scene.scene_manager = {
                transition = function() end,
            }
            scene:enter()
        end)

        it('calls onclick on button within bounds', function()
            local button = UIButton:new({
                x = 0,
                y = 0,
                width = 100,
                height = 50,
                onClick = function()
                    clickedButton = true
                end,
            })

            button.worldBounds = {
                {0, 0},
                {100, 50},
            }

            button:onclick(50, 25)
            assert.is_true(clickedButton)
        end)

        it('does not call onclick outside bounds', function()
            local button = UIButton:new({
                x = 0,
                y = 0,
                width = 100,
                height = 50,
                onClick = function()
                    clickedButton = true
                end,
            })

            button.worldBounds = {
                {0, 0},
                {100, 50},
            }

            local isOutside = not button:isWithin(150, 25)
            assert.is_true(isOutside)
        end)
    end)

    describe('update', function()
        local scene
        local button1Updated = false
        local button2Updated = false

        before_each(function()
            scene = MainMenuScene:new()
        end)

        it('resets button state to normal', function()
            local button = UIButton:new({
                text = 'Test',
                width = 100,
                height = 50,
            })

            button.state = 'hover'
            button:update()
            assert.are.equal('normal', button.state)
        end)
    end)
end)
