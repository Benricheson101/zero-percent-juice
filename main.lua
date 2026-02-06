Object = require('classic') -- this MUST be first
require('upgrades') --do this before menus

Screen = 'splash'

local menus = require('menus')
local constants = require('constants')
local util = require('util')

local SplashMenu = require('menu.splash')
local MainMenu = require('menu.mainmenu')

local window_width
local window_height


function love.load()
    window_width, window_height = love.graphics.getDimensions()
    love.window.setIcon(love.image.newImageData('assets/logo.png'))
end

function love.draw()
    love.graphics.print('Hello World', 400, 300)
    love.graphics.print(
        'width: ' .. window_width .. '\nheight: ' .. window_height
    )

    if Screen == 'main_menu' then
        -- menus.drawMainMenu()
        MainMenu.draw()
    elseif Screen == 'loading' then
        menus.drawSplash()
    elseif Screen == 'upgrades' then
        menus.drawUpgradesMenu()
    elseif Screen == 'splash' then
        SplashMenu.draw()
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
