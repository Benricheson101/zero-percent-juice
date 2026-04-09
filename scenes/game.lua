local Scene = require('renderer.scene')
local Player = require('player')
local Camera = require('camera')
local Background = require('background')
local Upgrades = require('upgrades')
local Ui = require('util.ui')
local EntitySpawner = require('entitySpawner')
local Fonts = require('util.fonts')

local designWidth = 1280
local designHeight = 720

---@class GameScene : Scene
local GameScene = {}
setmetatable(GameScene, { __index = Scene })
GameScene.__index = GameScene

function GameScene:new()
    local o = setmetatable({}, self)

    Player.load {
        posX = Ui:getWidth() * 0.2,
        posY = Ui:getHeight() / 2,
        velocityX = 0,
        velocityY = 0,
        accelerationX = 300,
        accelerationY = 300,
        decelerationX = 50,
        decelerationY = 50,
        maxVelocityX = 300,
        maxVelocityY = 300,
    }

    Camera.load(Player)
    Background.load()

    ObstacleSpawner = EntitySpawner:new {
        baseSpawnDistance = designWidth,
        spawnDistance = designWidth,
        baseVelocityX = 50,
        image = 'images/Obstacle.png',
    }

    CoinSpawner = EntitySpawner:new {
        baseSpawnDistance = designWidth,
        spawnDistance = designWidth / 2,
        baseVelocityX = 50,
        image = 'images/Coin.png',
    }

    GameScene.baseGameOverTimer = 3
    GameScene.currentGameOverTimer = GameScene.baseGameOverTimer

    return o
end

function GameScene:update(dt)
    Player.update(dt)
    Camera.update(dt)
    ObstacleSpawner:update(dt)
    CoinSpawner:update(dt)

    ObstacleSpawner:updateEntityVelocityX(Camera.getVelocityX())
    CoinSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self:checkCollision(Player.posX, Player.posY, Player.dim)
    self:checkGameOver(dt)
end

function GameScene:draw()
    love.graphics.setColor(1, 1, 1)
    Background.draw(Camera)
    Player.draw()
    ObstacleSpawner:draw()
    CoinSpawner:draw()
    self:gameOverTimerText()
end

function GameScene:keypressed(key)
    Player.keypressed(key)
    ObstacleSpawner:keypressed(key)
    CoinSpawner:keypressed(key)
end

function GameScene:keyreleased(key)
    Player.keyreleased(key)
end

--- Calucates the inital speed of the player based on the level of the start speed upgreade
--- @param level number the level of the start speed upgrade
--- @return number the starting speed of the player
function GameScene.calculateStartingSpeed(level)
    return 100 + 125 * level
end

function GameScene:enter()
    --when the game starts
    local startSpeedUpgrade = Upgrades.getUpgrade('Tank Pressure') -- get the start speed upgrade
    assert(startSpeedUpgrade ~= nil, 'Tank Pressure upgrade not found')
    local speed = self.calculateStartingSpeed(startSpeedUpgrade:getLevel()) --calculate the statring speed
    Camera.velocityX = speed -- apply the starting speed
    Camera.xPos = 0 -- reset posotion to start
end

function GameScene:checkCollision(posX, posY, dim)
    if ObstacleSpawner:checkCollision(posX, posY, dim) then
        -- Camera now to handle x velocity
        Camera.changeVelocityX(-150)
    end

    if CoinSpawner:checkCollision(posX, posY, dim) then
        Player.money = Player.money + 10
    end
end

function GameScene:checkGameOver(dt)

    if Camera.velocityX == 0 and Player.posY >= (designHeight - (Player.dim / 2)) then
        self.currentGameOverTimer = self.currentGameOverTimer - dt
        if self.currentGameOverTimer < 0 then
            self:reset()
            self.scene_manager:transition('leaderboardsubmit')
        end
    else
        self.currentGameOverTimer = self.baseGameOverTimer
    end

end

function GameScene:gameOverTimerText()

    local x, y = Ui:scaleCoord(designWidth * 0.25, designHeight * 0.3)

    if Camera.velocityX == 0 and Player.posY >= (designHeight - (Player.dim / 2)) then

        love.graphics.setColor(1, 0, 0)
        love.graphics.setDefaultFilter('nearest', 'nearest')
        love.graphics.setFont(Fonts.impact75)

        love.graphics.printf(
            math.ceil(self.currentGameOverTimer),
            0,
            math.floor(Ui:getHeight() * 0.5)
                - math.floor(Fonts.impact75:getHeight() / 2),
            Ui:getWidth(),
            'center'
        )

        love.graphics.setColor(1, 1, 1)
        love.graphics.setDefaultFilter('linear', 'linear')
    end

end

function GameScene:reset()

    Player.posX = Ui:getWidth() * 0.2
    Player.posY = Ui:getHeight() / 2

    Player.velocityX = 0
    Player.velocityY = 0

    Camera.velocityX = Player.maxVelocityX

    ObstacleSpawner:clearEntities()
    CoinSpawner:clearEntities()

    ObstacleSpawner.spawnDistance = ObstacleSpawner.baseSpawnDistance
    CoinSpawner.spawnDistance = CoinSpawner.baseSpawnDistance / 2



end

return GameScene
