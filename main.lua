local Player = require("player")
local Camera = require("camera")
local Sound = require("sound")
local ObstacleSpawner = require("obstacleSpawner")

-- Includes for POST request to leaderboard server
local http = require("socket.http")
local ltn12 = require("ltn12")

function RestartGame()
	GameState = "playing"
	PlayerName = ""
	TotalDistance = 0
	Camera.load()
	Player.load()
	ObstacleSpawner.load()

	print("Game restarted!")
end

function love.load()
	DebugPrint = false

	PlayerName = ""
	MaxNameLength = 15

	GameState = "playing"

	GlobalHeight = love.graphics.getHeight()
	GlobalWidth = love.graphics.getWidth()

	Player.load()
	Camera.load()
	Sound.load()
	ObstacleSpawner.load()

	TotalDistance = 0

	-- Image testing
	Background = love.graphics.newImage("images/TEST_ONLY_IMAGE.png")
	BackgroundHeight = Background:getHeight()
	BackgroundWidth = Background:getWidth()
end

function love.textinput(t)
	if GameState == "name_entry" then
		if t:match("^[a-zA-Z]$") and #PlayerName < MaxNameLength then
			PlayerName = PlayerName .. t
		end
	end
end

function love.keypressed(key)
	if GameState == "name_entry" then
		if key == "backspace" then
			PlayerName = PlayerName:sub(1, -2)
		elseif key == "return" then
			if #PlayerName < 1 then
				return
			end

			print("Submitted name: " .. PlayerName)

			local url = "http://localhost:8000/submit/"
			local json_body = string.format('{"name": "%s", "score": %d}', PlayerName, math.floor(TotalDistance))

			local response_body = {}

			-- I hate the way this has to be done
			local result, code, headers = http.request({
				url = url,
				method = "POST",
				headers = {
					["content-type"] = "application/json",
					["content-length"] = tostring(#json_body),
				},
				source = ltn12.source.string(json_body),
				sink = ltn12.sink.table(response_body),
			})

			print("Status code:", code)
			print("Response body:", table.concat(response_body))

			RestartGame()
		end
		return
	end

	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	if love.keyboard.isDown("f11") then
		DebugPrint = not DebugPrint
	end

	Sound.keypressed(key)
end

function love.update(dt)
	if GameState == "playing" then
		if Camera.velocityX <= 0 then
			--GameState = "name_entry"
			--return
		end

		Player.update(dt)
		Camera.update(dt)
		Sound.update(dt, Camera.velocityX)
		ObstacleSpawner.update(dt)
		if ObstacleSpawner.checkCollision(Player.xPos - Player.radius, Player.yPos - Player.radius, Player.radius * 2, Player.radius * 2) then
			Camera.collision()
		end

		if not (TotalDistance > Camera.xPos) then
			local calculatedDistance = Camera.velocityX * dt
			if calculatedDistance > 0 then
				TotalDistance = TotalDistance + calculatedDistance
			end
		end
	end
end

function love.draw()
	local offset = Camera.xPos % BackgroundWidth

	-- Temporal accumulation blur based on velocity
	local velocity = math.abs(Camera.velocityX)
	local numBlurFrames = math.floor(velocity / 80)
	local maxAlpha = math.min(velocity / 400, 0.85)

	-- Draw blur frames (older frames first, more transparent)
	for blurFrame = numBlurFrames, 1, -1 do
		local timeDelta = blurFrame * 0.022
		local pastX = Camera.xPos - (Camera.velocityX * timeDelta)
		local pastOffset = pastX % BackgroundWidth

		local alpha = (blurFrame / (numBlurFrames + 1)) * maxAlpha
		love.graphics.setColor(1, 1, 1, alpha)

		for i = -1, 2 do
			local x = (i * BackgroundWidth) - pastOffset
			love.graphics.draw(Background, x, 0)
		end
	end

	-- Present frame
	love.graphics.setColor(1, 1, 1, 1)
	for i = -1, 2 do
		local x = (i * BackgroundWidth) - offset
		love.graphics.draw(Background, x, 0)
	end

	if DebugPrint then
		love.graphics.print(table.concat({
			string.format("GameState: %s\n", GameState),
			string.format("Total Distance: %d\n", TotalDistance),
			string.format("Current Camera X Position: %d\n", Camera.xPos),
			string.format("Current Player Y Position: %d\n", Player.yPos),
			string.format("Current Camera X Velocity: %d\n", Camera.velocityX),
			string.format("Current Player Y Velocity: %d\n", Player.velocityY),
			string.format("FPS: %d\n", love.timer.getFPS()),
		}))
	end

	Player.draw()
	ObstacleSpawner.draw()

	if GameState == "name_entry" then
		love.graphics.setColor(0, 0, 0, 0.8)
		love.graphics.rectangle("fill", 0, 0, GlobalWidth, GlobalHeight)

		local boxW = GlobalWidth * 0.6
		local boxH = 250
		local boxX = (GlobalWidth - boxW) / 2
		local boxY = (GlobalHeight - boxH) / 2

		love.graphics.setColor(0.15, 0.15, 0.15)
		love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)

		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("line", boxX, boxY, boxW, boxH)

		love.graphics.printf("Game Over", boxX, boxY + 30, boxW, "center")
		love.graphics.printf(string.format("Score: %d", math.floor(TotalDistance)), boxX, boxY + 70, boxW, "center")
		love.graphics.printf("Enter your name: ", boxX, boxY + 110, boxW, "center")
		love.graphics.printf(PlayerName, boxX, boxY + 140, boxW, "center")

		love.graphics.setColor(0.6, 0.6, 0.6)
		love.graphics.printf("Press ENTER to submit", boxX, boxY + 190, boxW, "center")
	end
end

