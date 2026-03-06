local Ui = require("util.ui")

local Player = {}

-- local designWidth = 1280
local designHeight = 720
local designScale = 5

function Player.load(opts)
	Player.posX = opts.posX
	Player.posY = opts.posY

	Player.velocityX = opts.velocityX
	Player.velocityY = opts.velocityY

	Player.accelerationX = opts.accelerationX
	Player.accelerationY = opts.accelerationY

	Player.decelerationX = opts.decelerationX
	Player.decelerationY = opts.decelerationY

	Player.maxVelocityX = opts.maxVelocityX
	Player.maxVelocityY = opts.maxVelocityY

	love.graphics.setDefaultFilter("nearest", "nearest")
	Player.image = love.graphics.newImage("images/TempPlayer.png")
	love.graphics.setDefaultFilter("linear", "linear")

	Player.dim = Player.image:getHeight() * designScale
	Player.rotation = 0

	Player.dx = 0
	Player.dy = 0

	-- Player.updateScale(scale)
end

function Player.update(dt)
	-- Player.updateVelocityX(dt)
	Player.updateVelocityY(dt)

	Player.updatePosY(dt)

	-- Slowly rotates player
	Player.rotation = (Player.rotation + (dt * 3)) % (2 * math.pi)
end

function Player.updateVelocityX(dt)
	-- Changes player velocity when left/right or a/d is pressed
	Player.velocityX = Player.velocityX + (Player.accelerationX * dt * Player.dx)

	-- Slowly decreases their velocity over time
	if Player.velocityX > 0 then
		Player.velocityX = Player.velocityX - Player.decelerationX * dt
		if Player.velocityX < 0 then
			Player.velocityX = 0
		end
	end
	if Player.velocityX < 0 then
		Player.velocityX = Player.velocityX + Player.decelerationX * dt
		if Player.velocityX > 0 then
			Player.velocityX = 0
		end
	end

	-- Caps player velocity
	-- if Player.velocityX > Player.maxVelocityX then
	--         Player.velocityX = Player.maxVelocityX
	-- end
	-- if Player.velocityX < (Player.maxVelocityX * -1) then
	--         Player.velocityX = (Player.maxVelocityX * -1)
	-- end
end

function Player.updateVelocityY(dt)
	-- Changes player velocity when up/down or w/s is pressed
	Player.velocityY = Player.velocityY + (Player.accelerationY * dt * Player.dy)

	-- Slowly decreases their velocity over time
	if Player.velocityY > 0 then
		Player.velocityY = Player.velocityY - Player.decelerationY * dt
		if Player.velocityY < 0 then
			Player.velocityY = 0
		end
	end

	if Player.velocityY < 0 then
		Player.velocityY = Player.velocityY + Player.decelerationY * dt
		if Player.velocityY > 0 then
			Player.velocityY = 0
		end
	end

	-- if Player.velocityY > Player.maxVelocityY then
	--         Player.velocityY = Player.maxVelocityY
	-- end

	-- if Player.velocityY < (Player.maxVelocityY * -1) then
	--         Player.velocityY = (Player.maxVelocityY * -1)
	-- end
end

function Player.updatePosY(dt)
	-- Updates player position based on velocity and time
	Player.posY = Player.posY + Player.velocityY * dt

	-- If player reaches upper or lower bound of the game, they will stop and have their velocity set to 0
	if Player.posY < (Player.dim / 2) then
		Player.posY = (Player.dim / 2)
		Player.velocityY = 0
	end
	if Player.posY > (designHeight - (Player.dim / 2)) then
		Player.posY = (designHeight - (Player.dim / 2))
		Player.velocityY = 0
	end

	-- Slowly rotates player
	Player.rotation = (Player.rotation + (dt * 3)) % (2 * math.pi)
end

function Player.draw()
	local posX, posY = Ui:scaleCoord(Player.posX, Player.posY)
	local scale = Ui:getScale()
	love.graphics.draw(
		Player.image,
		posX,
		posY,
		Player.rotation,
		scale * designScale,
		scale * designScale,
		Player.image:getWidth() / 2,
		Player.image:getHeight() / 2
	)
end

function Player.keypressed(key)
	if key == "left" or key == "a" then
		Player.dx = -1
	elseif key == "right" or key == "d" then
		Player.dx = 1
	else
		Player.dx = 0
	end

	if key == "up" or key == "w" then
		Player.dy = -1
	elseif key == "down" or key == "s" then
		Player.dy = 1
	else
		Player.dy = 0
	end
end

function Player.keyreleased(key)
	if key == "left" or key == "a" or key == "right" or key == "d" then
		Player.dx = 0
	end

	if key == "up" or key == "w" or key == "down" or key == "s" then
		Player.dy = 0
	end
end

function Player.getVelocityX()
	return Player.velocityX
end

return Player
