local constants = require('constants')

local SplashMenu = {}

-- function SplashMenu:new()
--   local o = {}
--   setmetatable(o, self)
--   self.__index = self
--   return o
-- end

local progress = 0

local function drawLoadingScreen(progress, text)
  local window_width, window_height = love.graphics.getDimensions()
  -- local font = love.graphics.setNewFont(30)
  -- local fontHeight = font:getHeight()

  local rectangle_width = window_width * (2/3)
  local rectangle_height = rectangle_width / 10

  local padding = 10

  local horiz_center = window_width / 2
  local vert_center = window_height / 2

  local topleftx = horiz_center - (rectangle_width / 2)
  local toplefty = vert_center - (rectangle_height / 2)

  local prodreddDisps = math.floor(100-progress*100)

  love.graphics.printf('Loading...', constants.fonts.ui, 0, vert_center - 100, window_width, "center")
  love.graphics.printf(prodreddDisps .. '% Juice', constants.fonts.ui, 0, vert_center - 70, window_width, "center")

  love.graphics.setColor(constants.colors.red)
  love.graphics.rectangle('fill', topleftx, toplefty, rectangle_width, rectangle_height)

  love.graphics.setColor(constants.colors.black)

  local innertopleftx = topleftx + (padding / 2)
  local innertoplefty = toplefty + (padding / 2)

  local progressWidthFull = rectangle_width - padding
  local progressWidthProgress = progressWidthFull * progress

  love.graphics.rectangle('fill', innertopleftx, innertoplefty, progressWidthProgress, rectangle_height - padding)

  love.graphics.setColor(constants.colors.white)
end


function SplashMenu.draw()
  drawLoadingScreen(progress/16, "Loading sprites...")
end


function SplashMenu.update(dt)
  progress = progress +dt
  if progress >= 1600 then
    
  end
end

function SplashMenu.load()
--   for i = 10, 1, -1 do
--     love.graphics.clear()
--     drawLoadingScreen(i/10, "Loading sprites...")
--     love.graphics.present()
--     love.timer.sleep(0.25)
--   end

  -- love.timer.sleep(1)
  --
  -- love.graphics.clear()
  -- drawLoadingScreen(1/3, "Loading sounds...")
  -- love.graphics.present()
  --
  -- love.timer.sleep(1)
  --
  -- love.graphics.clear()
  -- drawLoadingScreen(2/3, "Loading levels...")
  -- love.graphics.present()
end

return SplashMenu
