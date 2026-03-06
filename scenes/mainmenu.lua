local Scene = require('renderer.scene')
local UIButton = require('ui.button')
local Ui = require('util.ui')
local constants = require("util.constants")

---@class MainMenuScene : Scene
local MainMenuScene = {}
setmetatable(MainMenuScene, {__index = Scene})
MainMenuScene.__index = MainMenuScene

---@type BaseUIElement[]
local mainMenu = {
    UIButton:new {
        text = "Start Game",
        width = 200,
        height = 200/3,
        onClick = function (self)
            print('clicked Start Game')
            self.scene.scene_manager:transition('game')
        end
    },
    UIButton:new {
        text = "Leaderboard",
        width = 200,
        height = 200/3,
        onClick = function ()
            print('clicked Leaderboard')
        end
    },
    UIButton:new {
        text = "Exit",
        width = 200,
        height = 200/3,
        onClick = function ()
            print('clicked Exit')
            love.event.quit(0)
        end
    },
}

function MainMenuScene:enter()
    for _, elem in ipairs(mainMenu) do
        elem.scene = self.scene_manager.active
        elem.x = 50
    end
end

function MainMenuScene:draw()
    love.graphics.clear(constants.colors.menu.bg)

    -- draw menu buttons

    local start = 0.5 * Ui:getHeight()
    local gap = 25

    for _, elem in ipairs(mainMenu) do
        elem.x = Ui.centerX - math.floor(elem.canvas:getWidth() / 2)
        elem.y = start

        local tlX = elem.x
        local tlY = elem.y
        local brX = elem.canvas:getWidth() + tlX
        local brY = elem.canvas:getHeight() + tlY

        elem.worldBounds = {
            {tlX, tlY},
            {brX, brY},
        }

        local mouseX, mouseY = love.mouse.getPosition()
        local hover = elem:isWithin(mouseX, mouseY)
        if hover then
            elem:hover(mouseX, mouseY)
        end

        love.graphics.draw(elem:draw(), tlX, tlY)

        start = start + elem.canvas:getHeight() + gap
    end
end

function MainMenuScene:mousepressed(x, y)
    for _, elem in ipairs(mainMenu) do
        if elem:isWithin(x, y) then
            elem:onclick(x, y)
            break
        end
    end
end

function MainMenuScene:update(dt)
    for _, elem in ipairs(mainMenu) do
        elem:update(dt)
    end
end

return MainMenuScene
