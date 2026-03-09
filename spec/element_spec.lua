local BaseUIElement = require('ui.element')

describe('BaseUIElement', function()
    describe('new', function()
        it('creates element with default values', function()
            local element = BaseUIElement:new({})

            assert.are.equal(0, element.x)
            assert.are.equal(0, element.y)
            assert.are.equal(0, element.width)
            assert.are.equal(0, element.height)
        end)

        it('creates element with custom values', function()
            local element = BaseUIElement:new({
                x = 100,
                y = 200,
                width = 300,
                height = 50,
            })

            assert.are.equal(100, element.x)
            assert.are.equal(200, element.y)
            assert.are.equal(300, element.width)
            assert.are.equal(50, element.height)
        end)

        it('sets worldBounds correctly', function()
            local element = BaseUIElement:new({
                x = 100,
                y = 200,
                width = 300,
                height = 50,
            })

            assert.are.equal(100, element.worldBounds[1][1])
            assert.are.equal(200, element.worldBounds[1][2])
            assert.are.equal(400, element.worldBounds[2][1])
            assert.are.equal(250, element.worldBounds[2][2])
        end)
    end)

    describe('isWithin', function()
        local element

        before_each(function()
            element = BaseUIElement:new({
                x = 100,
                y = 100,
                width = 200,
                height = 100,
            })
        end)

        it('returns true when point is inside bounds', function()
            assert.is_true(element:isWithin(150, 150))
            assert.is_true(element:isWithin(100, 100))
            assert.is_true(element:isWithin(300, 200))
        end)

        it('returns false when point is outside bounds', function()
            assert.is_false(element:isWithin(50, 150))
            assert.is_false(element:isWithin(350, 150))
            assert.is_false(element:isWithin(150, 50))
            assert.is_false(element:isWithin(150, 250))
        end)

        it('returns false when point is on boundary edge', function()
            assert.is_false(element:isWithin(99, 150))
            assert.is_false(element:isWithin(301, 150))
            assert.is_false(element:isWithin(150, 99))
            assert.is_false(element:isWithin(150, 201))
        end)
    end)

    describe('hover', function()
        it('is a no-op function', function()
            local element = BaseUIElement:new({ width = 100, height = 50 })
            assert.has_no_errors(function()
                element:hover(50, 25)
            end)
        end)
    end)

    describe('onclick', function()
        it('is a no-op function', function()
            local element = BaseUIElement:new({ width = 100, height = 50 })
            assert.has_no_errors(function()
                element:onclick(50, 25)
            end)
        end)
    end)

    describe('update', function()
        it('is a no-op function', function()
            local element = BaseUIElement:new({ width = 100, height = 50 })
            assert.has_no_errors(function()
                element:update(0.016)
            end)
        end)
    end)
end)
