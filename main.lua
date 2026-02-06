Object = require('classic') -- this MUST be first
require('upgrades') --do this before menus
local realgame = require('realgame')

Screen = os.getenv('ZPJ_START_SCREEN') or 'splash'

local menus = require('menus')
local constants = require('constants')
local util = require('util')

local SplashMenu = require('menu.splash')
local MainMenu = require('menu.mainmenu')

WindowWidth = 0
WindowHeight = 0

function love.load()
    WindowWidth, WindowHeight = love.graphics.getDimensions()
    love.window.setIcon(love.image.newImageData('assets/logo.png'))
    constants.fonts.default = love.graphics.getFont()
end

function love.draw()
    if Screen == 'main_menu' then
        MainMenu.draw()
    elseif Screen == 'upgrades' then
        menus.drawUpgradesMenu()
    elseif Screen == 'splash' then
        SplashMenu.draw()
    elseif Screen == 'game' then
        realgame.draw()
    end
end

function love.update(dt)
    if Screen == 'splash' then
        SplashMenu.update(dt)
    end
end

function love.keypressed(key, keyCode, isRepeat)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyreleased(key, keyCode) end

function love.mousepressed(x, y, button, istouch, presses)
    if Screen == 'upgrades' then
        menus.clickUpgradesMenu(x, y)
    elseif Screen == 'main_menu' then
        MainMenu.mousepressed(x, y)
    end
end
