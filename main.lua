--main file here
local Game = require("game")
local Ui = require("util.ui")

Screen = "game"

function love.load()
	Ui:reload()

	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	love.window.updateMode(w, h, { resizable = true })

	Game.load()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	if Screen == "game" then
		Game.update(dt)
	end
end

function love.draw()
	if Screen == "game" then
		Game.draw()
	end
end

function love.resize(w, h)
	--whe the window is resized, update the Ui scaling factor
	Ui:reload()
end
