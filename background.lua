local Ui = require("util.ui")

local Background = {}

function Background.load()
	Background.image = love.graphics.newImage("images/Background.png")
	Background.imageHeight = Background.image:getHeight()
	Background.imageWidth = Background.image:getWidth()

	love.graphics.setDefaultFilter("linear", "linear")
end

function Background.draw(Camera)
	local scaledImageWidth = Background.imageWidth * Ui.scale
	local background_cam_offset = Camera.xPos % scaledImageWidth

	local x, y = Ui:scaleCoord(0, 0)

	-- Horizontal Scrolling
	love.graphics.setColor(1, 1, 1, 1)
	for i = -1, 2 do
		local image_offsetx = (i * scaledImageWidth) - background_cam_offset + x
		love.graphics.draw(Background.image, image_offsetx, y, 0, Ui.scale, Ui.scale)
	end

	-- love.graphics.draw(Background.image, Background.offsetX, Background.offsetY, 0, Background.scale, Background.scale)

	-- love.graphics.draw(Background.image, x, y, 0, Ui.scale, Ui.scale)

	-- love.graphics.setColor(0, 0, 1)
	-- love.graphics.rectangle("fill", 0, 0, Ui:scaleDimension(designWidth), Ui.top)
	-- love.graphics.setColor(0, 1, 0)
	-- love.graphics.rectangle("fill", 0, Ui:scaleDimension(designHeight) + Ui.top, Ui:scaleDimension(designWidth), Ui.top)
	-- love.graphics.setColor(1, 1, 0)
	-- love.graphics.rectangle("fill", 0, 0, Ui.left, Ui:scaleDimension(designWidth))
	-- love.graphics.setColor(1, 0, 0)
	-- love.graphics.rectangle("fill", Ui:scaleDimension(designWidth) + Ui.left, 0, Ui.left, Ui:scaleDimension(designWidth))

	-- This draws the extra colors just in case

	-- love.graphics.setColor(0, 0, 1)
	-- love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), Background.offsetY)
	-- love.graphics.setColor(0, 1, 0)
	-- love.graphics.rectangle(
	-- 	"fill",
	-- 	0,
	-- 	love.graphics.getHeight() - Background.offsetY,
	-- 	love.graphics.getWidth(),
	-- 	Background.offsetY
	-- )
	-- love.graphics.setColor(1, 1, 0)
	-- love.graphics.rectangle("fill", 0, 0, Background.offsetX, love.graphics.getHeight())
	-- love.graphics.setColor(1, 0, 0)
	-- love.graphics.rectangle(
	-- 	"fill",
	-- 	love.graphics.getWidth() - Background.offsetX,
	-- 	0,
	-- 	Background.offsetX,
	-- 	love.graphics.getHeight()
	-- )

	love.graphics.setColor(1, 1, 1)
end

return Background
