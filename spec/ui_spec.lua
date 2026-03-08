local Ui = require('util.ui')

local designWidth = 1280
local designHeight = 720

describe('Ui', function()
    before_each(function()
        Ui.scale = 1
        Ui.centerX = designWidth / 2
        Ui.centerY = designHeight / 2
        Ui.top = 0
        Ui.left = 0
    end)
    describe('reload', function()
        it('calculates scale factor for 16:9 aspect ratio', function()
            Ui:reload(1280, 720)
            assert.are.equal(1, Ui.scale)
        end)

        it('calculates scale factor for larger width', function()
            Ui:reload(2560, 720)
            assert.are.equal(1, Ui.scale)
        end)

        it('calculates scale factor for larger height', function()
            Ui:reload(2560, 1440)
            assert.are.equal(2, Ui.scale)
        end)

        it('calculates scale factor for non-standard aspect ratio', function()
            Ui:reload(1920, 1080)
            assert.are.equal(1.5, Ui.scale)
        end)

        it('calculates centerX and centerY', function()
            Ui:reload(1280, 720)
            assert.are.equal(640, Ui.centerX)
            assert.are.equal(360, Ui.centerY)
        end)

        it('calculates top and left offsets', function()
            Ui:reload(1280, 720)
            assert.are.equal(0, Ui.top)
            assert.are.equal(0, Ui.left)
        end)

        it('calculates top and left for non-standard size', function()
            Ui:reload(1920, 1080)
            assert.are.equal(0, Ui.top)
            assert.are.equal(0, Ui.left)
        end)
    end)

    describe('scaleCoord', function()
        before_each(function()
            Ui:reload(1280, 720)
        end)

        it('returns original coordinates at scale 1', function()
            local x, y = Ui:scaleCoord(100, 200)
            assert.are.equal(100, x)
            assert.are.equal(200, y)
        end)

        it('scales coordinates based on scale factor', function()
            Ui:reload(2560, 1440)
            local x, y = Ui:scaleCoord(100, 200)
            assert.are.equal(200, x)
            assert.are.equal(400, y)
        end)

        it('applies left and top offsets', function()
            Ui:reload(2560, 720)
            local x, y = Ui:scaleCoord(0, 0)
            assert.are.equal(640, x)
            assert.are.equal(0, y)
        end)
    end)

    describe('scaleDimension', function()
        before_each(function()
            Ui:reload(1280, 720)
        end)

        it('returns original dimension at scale 1', function()
            assert.are.equal(100, Ui:scaleDimension(100))
        end)

        it('scales dimension based on scale factor', function()
            Ui:reload(2560, 1440)
            assert.are.equal(200, Ui:scaleDimension(100))
        end)
    end)

    describe('getScale', function()
        it('returns current scale', function()
            Ui:reload(1280, 720)
            assert.are.equal(1, Ui:getScale())
        end)

        it('returns updated scale after reload', function()
            Ui:reload(2560, 1440)
            assert.are.equal(2, Ui:getScale())
        end)
    end)

    describe('default values', function()
        it('has default scale of 1', function()
            assert.are.equal(1, Ui.scale)
        end)

        it('has default centerX at designWidth / 2', function()
            assert.are.equal(640, Ui.centerX)
        end)

        it('has default centerY at designHeight / 2', function()
            assert.are.equal(360, Ui.centerY)
        end)

        it('has default top of 0', function()
            assert.are.equal(0, Ui.top)
        end)

        it('has default left of 0', function()
            assert.are.equal(0, Ui.left)
        end)
    end)
end)
