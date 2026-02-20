local Ui = require("util.ui")
local SceneManager = require("renderer.scenemanager")

local ExampleScene = require("scenes.example")
local GameScene = require("scenes.game")
local LoadingScreen = require("scenes.loadingScreen")

---@type SceneManager
local scene_manager

function love.load()
    scene_manager = SceneManager:new {
        example = ExampleScene:new(),
        game = GameScene:new(),
        loading = LoadingScreen:new()
    }

    -- Initialize the Ui scaling factor
    Ui:reload()
    --tmp
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    love.window.updateMode(w, h, {resizable=true})

    scene_manager:transition('loading')
end

function love.keypressed(key, ...)
	if key == "escape" then
		love.event.quit()
        return
	end

    scene_manager:keypressed(key, ...)
end

function love.resize(w, h)
    --whe the window is resized, update the Ui scaling factor
    Ui:reload()
    scene_manager:resize(w, h)
end

function love.draw() scene_manager:draw() end
function love.update(...) scene_manager:update(...) end
function love.keyreleased(...) scene_manager:keyreleased(...) end
function love.mousepressed(...) scene_manager:mousepressed(...) end
function love.mousereleased(...) scene_manager:mousereleased(...) end
