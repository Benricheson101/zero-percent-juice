package.path = './vendor/share/lua/5.1/?.lua;' .. package.path
local Ui = require('util.ui')
local fonts = require('util.fonts')
local SceneManager = require('renderer.scenemanager')
local config = require('util.config')

local GameScene = require('scenes.game')
local LoadingScreen = require('scenes.loadingScreen')
local UpgradeScreen = require('scenes.upgradeScreen')
local MainMenuScene = require('scenes.mainmenu')
local LeaderboardSubmitScene = require('scenes.leaderboardSubmit')
local GameOverScene = require('scenes.gameOver')
local modLoader = require('modLoader')
local LeaderboardScene = require('scenes.leaderboard')

local START_SCENE = os.getenv('ZPJ_START_SCREEN') or 'loading'

---@type SceneManager
local scene_manager

function love.load()
    config:loadConfig('config.json')
    modLoader:loadMods() -- attmpt to load mods

    -- print("START SCENE", START_SCENE)
    scene_manager = SceneManager:new {
        game = GameScene:new(),
        loading = LoadingScreen:new(),
        upgrade = UpgradeScreen:new(),
        mainmenu = MainMenuScene:new(),
        leaderboardsubmit = LeaderboardSubmitScene:new(),
        leaderboard = LeaderboardScene:new(),
        gameover = GameOverScene:new(),
    }

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    Ui:reload(w, h)
    fonts:reload() -- load the fonts
    --tmp
    love.window.updateMode(w, h, { resizable = true })

    --window icon
    love.window.setIcon(love.image.newImageData('assets/logo.png'))
    love.window.setTitle('Zero Percent Juice')

    scene_manager = SceneManager:new {
        game = GameScene:new(),
        loading = LoadingScreen:new(),
        upgrade = UpgradeScreen:new(),
        mainmenu = MainMenuScene:new(),
        leaderboardsubmit = LeaderboardSubmitScene:new(),
        gameover = GameOverScene:new(),
    }

    modLoader.gameLoaded(scene_manager)

    scene_manager:transition(START_SCENE)
end

function love.keypressed(key, ...)
    if key == 'escape' then
        love.event.quit()
        return
    end

    scene_manager:keypressed(key, ...)
    modLoader.keypressed(key, ...)
end

function love.resize(w, h)
    --when the window is resized, update the Ui scaling factor
    Ui:reload(w, h)
    fonts:reload() --re scale all the fonts
    scene_manager:resize(w, h)
end

function love.draw()
    scene_manager:draw()
end
function love.update(...)
    scene_manager:update(...)
end
function love.keyreleased(...)
    scene_manager:keyreleased(...)
    modLoader.keyreleased(...)
end
function love.mousepressed(...)
    scene_manager:mousepressed(...)
    modLoader.mousepressed(...)
end
function love.mousereleased(...)
    scene_manager:mousereleased(...)
    modLoader.mousereleased(...)
end
function love.textinput(...)
    scene_manager:textinput(...)
end

function love.wheelmoved(...)
    scene_manager:wheelmoved(...)
end