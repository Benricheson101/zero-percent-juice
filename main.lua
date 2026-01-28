function love.load()
	love.graphics.setBackgroundColor(1, 1, 1)

	GlobalWidth = love.graphics.getWidth()
	GlobalHeight = love.graphics.getHeight()

	xPos = GlobalWidth / 2
	yPos = GlobalHeight / 2

	shapes = { "square", "circle" }
	shapeIndex = 1
	currentShape = shapes[shapeIndex]

	createdShapes = {}

	r = love.math.random()
	g = love.math.random()
	b = love.math.random()
end

function love.keypressed(key)
	if key == "space" then
		shapeIndex = shapeIndex + 1
		if shapeIndex > #shapes then
			shapeIndex = 1
		end
	end
	currentShape = shapes[shapeIndex]
end

function love.mousepressed(x, y, button)
	if button == 1 then
		local newR = love.math.random()
		local newG = love.math.random()
		local newB = love.math.random()
		table.insert(createdShapes, { x, y, { newR, newG, newB } })
	elseif button == 2 then
		createdShapes = {}
	end
end

function love.update(dt)
	r = r + 0.3 * dt
	g = g + 0.5 * dt
	b = b + 0.9 * dt

	if r > 1 then
		r = 0
	end
	if g > 1 then
		g = 0
	end
	if b > 1 then
		b = 0
	end

	local speed = 400

	if love.keyboard.isDown("w") then
		yPos = yPos - speed * dt
		if yPos < 0 then
			yPos = GlobalHeight
		end
	end

	if love.keyboard.isDown("a") then
		xPos = xPos - speed * dt
		if xPos < 0 then
			xPos = GlobalWidth
		end
	end

	if love.keyboard.isDown("s") then
		yPos = yPos + speed * dt
		if yPos > GlobalHeight then
			yPos = 0
		end
	end

	if love.keyboard.isDown("d") then
		xPos = xPos + speed * dt
		if xPos > GlobalWidth then
			xPos = 0
		end
	end
end

function love.draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(table.concat({
		"Mode: " .. currentShape .. "\n",
		"CreatedShapes: " .. #createdShapes,
	}))

	-- Rendering the createdShapes
	for i = 1, #createdShapes do
		local shape = createdShapes[i]
		local x = shape[1]
		local y = shape[2]

		local color = shape[3]

		love.graphics.setColor(color[1], color[2], color[3])
		love.graphics.setLineWidth(5)
		love.graphics.circle("line", x, y, 25)
	end

	-- Rendering the player
	love.graphics.setColor(r, g, b)
	if currentShape == "square" then
		love.graphics.rectangle("fill", xPos, yPos, 88, 88)
	elseif currentShape == "circle" then
		love.graphics.circle("fill", xPos, yPos, 50)
	end
end
