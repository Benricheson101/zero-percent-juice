local UIButton = require('ui.button')

describe('UIButton', function()
    describe('new', function()
        it('creates button with required text', function()
            local button = UIButton:new({
                text = 'Click Me',
                width = 200,
                height = 50,
            })

            assert.are.equal('Click Me', button.text)
        end)

        it('creates button with default values', function()
            local button = UIButton:new({
                text = 'Test',
            })

            assert.are.equal(0, button.x)
            assert.are.equal(0, button.y)
            assert.are.equal(0, button.width)
            assert.are.equal(0, button.height)
            assert.are.equal('normal', button.state)
        end)

        it('creates button with custom values', function()
            local button = UIButton:new({
                text = 'Test Button',
                x = 100,
                y = 200,
                width = 300,
                height = 75,
            })

            assert.are.equal(100, button.x)
            assert.are.equal(200, button.y)
            assert.are.equal(300, button.width)
            assert.are.equal(75, button.height)
            assert.are.equal('normal', button.state)
        end)

        it('sets initial state to normal', function()
            local button = UIButton:new({
                text = 'Test',
                width = 100,
                height = 50,
            })

            assert.are.equal('normal', button.state)
        end)

        it('stores click callback', function()
            local clicked = false
            local button = UIButton:new({
                text = 'Test',
                width = 100,
                height = 50,
                onClick = function()
                    clicked = true
                end,
            })

            assert.is_function(button.clickCallback)
            button.clickCallback()
            assert.is_true(clicked)
        end)

        it('sets worldBounds correctly', function()
            local button = UIButton:new({
                x = 100,
                y = 200,
                width = 300,
                height = 50,
            })

            assert.are.equal(100, button.worldBounds[1][1])
            assert.are.equal(200, button.worldBounds[1][2])
            assert.are.equal(400, button.worldBounds[2][1])
            assert.are.equal(250, button.worldBounds[2][2])
        end)
    end)

    describe('onclick', function()
        it('triggers click callback', function()
            local clicked = false
            local button = UIButton:new({
                text = 'Test',
                width = 100,
                height = 50,
                onClick = function()
                    clicked = true
                end,
            })

            button:onclick(50, 25)
            assert.is_true(clicked)
        end)

        it('can pass button reference to callback', function()
            local receivedButton
            local button = UIButton:new({
                text = 'Test',
                width = 100,
                height = 50,
                onClick = function(self)
                    receivedButton = self
                end,
            })

            button:onclick(50, 25)
            assert.equal(button, receivedButton)
        end)
    end)

    describe('hover', function()
        it('sets state to hover', function()
            local button = UIButton:new({
                text = 'Test',
                width = 100,
                height = 50,
            })

            assert.are.equal('normal', button.state)
            button:hover(50, 25)
            assert.are.equal('hover', button.state)
        end)
    end)

    describe('update', function()
        it('resets state to normal', function()
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
