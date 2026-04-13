local Scene = require('renderer.scene')
local UIButton = require('ui.button')
local Ui = require('util.ui')
local Constants = require('util.constants')
local Fonts = require('util.fonts')

---@class GameOverScene : Scene
local GameOverScene = {}
setmetatable(GameOverScene, { __index = Scene })
GameOverScene.__index = GameOverScene

---@type BaseUIElement[]
local gameOverMenu = {
    UIButton:new {
        text = 'Retry',
        width = 200,
        height = 200 / 3,
        onClick = function(self)
            print('clicked Retry')
            self.scene.scene_manager:transition('game')
        end,
    },
    UIButton:new {
        text = 'Upgrade',
        width = 200,
        height = 200 / 3,
        onClick = function(self)
            print('clicked Leaderboard')
            self.scene.scene_manager:transition('upgrade')
        end,
    },
    UIButton:new {
        text = 'Main Menu',
        width = 200,
        height = 200 / 3,
        onClick = function(self)
            print('clicked Main Menu')
            self.scene.scene_manager:transition('mainmenu')
        end,
    },
}

function GameOverScene:enter()
    for _, elem in ipairs(gameOverMenu) do
        elem.scene = self.scene_manager.active
    end
end

function GameOverScene:draw()
    --love.graphics.clear(Constants.colors.menu.bg)

    love.graphics.setFont(Fonts.impact75)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        'Game Over!',
        0,
        math.floor(Ui:getHeight() * 0.25)
            - math.floor(Fonts.impact75:getHeight() / 2),
        Ui:getWidth(),
        'center'
    )

    local start = 0.5 * Ui:getHeight()
    local gap = Ui:scaleDimension(25)

    for _, elem in ipairs(gameOverMenu) do
        local width, height = Ui:scaleDimension(elem.width, elem.height)

        elem.x = Ui.centerX - math.floor(width / 2)
        elem.y = start

        local tlX = elem.x
        local tlY = elem.y
        local brX = width + tlX
        local brY = height + tlY

        elem.worldBounds = {
            { tlX, tlY },
            { brX, brY },
        }

        local mouseX, mouseY = love.mouse.getPosition()
        local hover = elem:isWithin(mouseX, mouseY)
        if hover then
            elem:hover(mouseX, mouseY)
        end

        love.graphics.draw(elem:draw(), tlX, tlY)

        start = start + height + gap
    end
end

function GameOverScene:mousepressed(x, y)
    for _, elem in ipairs(gameOverMenu) do
        if elem:isWithin(x, y) then
            elem:onclick(x, y)
            break
        end
    end
end

function GameOverScene:update(dt)
    for _, elem in ipairs(gameOverMenu) do
        elem:update(dt)
    end
end

return GameOverScene
