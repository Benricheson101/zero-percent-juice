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
---@field ObstacleSpawner EntitySpawner
---@field CoinSpawner EntitySpawner
---@field baseGameOverTimer number
---@field PowerUpSpawner EntitySpawner
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
        maxVelocityX = 600,
        maxVelocityY = 300,
    }

    Camera.load(Player)
    Background.load()

    ---@diagnostic disable-next-line: redundant-parameter
    o.ObstacleSpawner = EntitySpawner:new {
        spawnUpgradeName = 'Rock Reducer',
        spawnDistance = designWidth,
        baseVelocityX = 50,
        image = 'images/Obstacle.png',
        spawnUpgradeEffectFunc = GameScene.obsticaleSpawFrequencyCalculation,
    }

    --TODO: find a way for coins to be able to spawn way eriler
    ---@diagnostic disable-next-line: redundant-parameter
    o.CoinSpawner = EntitySpawner:new {
        spawnUpgradeName = 'Coin Replictor',
        spawnDistance = 0,
        baseVelocityX = 50,
        image = 'images/Coin.png',
        spawnUpgradeEffectFunc = GameScene.coinSpawnFrequencyCalculation,
    }

    o.baseGameOverTimer = 3
    o.currentGameOverTimer = o.baseGameOverTimer
    ---@diagnostic disable-next-line: redundant-parameter
    o.PowerUpSpawner = EntitySpawner:new {
        spawnUpgradeName = 'Boosters',
        spawnDistance = designWidth / 2,
        baseVelocityX = 50,
        image = 'images/Powerup.png',
        spawnUpgradeEffectFunc = GameScene.powerUpSpawnerFrequencyCalculation,
    }

    return o
end

function GameScene:update(dt)
    Player.update(dt)
    Camera.update(dt)
    self.ObstacleSpawner:update(dt)
    self.CoinSpawner:update(dt)
    self.PowerUpSpawner:update(dt)

    self.ObstacleSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self.CoinSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self.PowerUpSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self:checkCollision(Player.posX, Player.posY, Player.dim)
    self:checkGameOver(dt)
end

function GameScene:draw()
    love.graphics.setColor(1, 1, 1)
    Background.draw(Camera)
    Player.draw()
    self.ObstacleSpawner:draw()
    self.CoinSpawner:draw()
    self:gameOverTimerText()
    self.PowerUpSpawner:draw()
end

function GameScene:keypressed(key)
    Player.keypressed(key)
    self.ObstacleSpawner:keypressed(key)
    self.CoinSpawner:keypressed(key)
    self.PowerUpSpawner:keypressed(key)
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
    Camera.maxVelocityX = speed
    Camera.xPos = 0 -- reset posotion to start
end

function GameScene:checkCollision(posX, posY, dim)
    local obsticalSpeedReductionUpgrade = Upgrades.getUpgrade('Rock Buster')
    local coinValueUpgrade = Upgrades.getUpgrade('Profit Boost')
    local powerUpUpgrade = Upgrades.getUpgrade('Boost Power')
    assert(
        obsticalSpeedReductionUpgrade ~= nil,
        'Rock Buster upgrade not found'
    )
    assert(coinValueUpgrade ~= nil, 'Profit Boost upgrade not found')
    --obstical collision
    if self.ObstacleSpawner:checkCollision(posX, posY, dim) then
        -- Camera now to handle x velocity
        local reduction = GameScene.calculateObsticalSpeedReduction(
            obsticalSpeedReductionUpgrade:getLevel()
        )
        Camera.changeVelocityX(reduction)
    end

    --coin collision
    if self.CoinSpawner:checkCollision(posX, posY, dim) then
        Player.money = Player.money
            + GameScene.calculateCoinValue(coinValueUpgrade:getLevel())
        print('Money: ' .. Player.money)
    end

    assert(powerUpUpgrade ~= nil, 'Boost Power upgrade not found')
    if self.PowerUpSpawner:checkCollision(posX, posY, dim) then
        local boostAmount = GameScene.calculatePowerupBoost(
            powerUpUpgrade:getLevel()
        )
        Camera.changeVelocityX(boostAmount)
    end
end

--- Calculates how often the rock obstical should spawn based on the level of the rock buster upgrade
--- @param level number the level of the rock buster upgrade
--- @return number the distance the player has to travel before the next obstical spawns
function GameScene.obsticaleSpawFrequencyCalculation(level)
    return 720 + 15 * level
end

--- Calulte how often coins should spawn based on the level of <relavant upgrade name here>
--- @param level number the level of the <relavant upgrade name here> upgrade
--- @return number the distance the player has to travel before the next coin spawns
function GameScene.coinSpawnFrequencyCalculation(level)
    return 720 / (1 + 0.1 * level)
end

--- TEMPORARY FUNCTION, CHANGE ONCE POWER UP UPGRADES ARE IMPLEMENTED
--- @param level number the level of the <relavant upgrade name here> upgrade
--- @return number the distance the player has to travel before the next power up spawns
function GameScene.powerUpSpawnerFrequencyCalculation(level)
    if level == 0 then
        return 2147483648 -- basically never
    end
    return 1000 / (0.1 * level)
end

--- Calculate how much speed to remove from the player when they hit an obstical
--- @param level number the level of the rock reducer upgrade
--- @return number the amount of speed to remove
function GameScene.calculateObsticalSpeedReduction(level)
    return -150 * math.pow(0.96, level)
end

--- Calculae how much each coin is worth
--- @param level number the level of the profit boost upgrade
--- @return number the value of each coin
function GameScene.calculateCoinValue(level)
    return 10 + math.floor(math.pow(level, 1.15))
end

function GameScene.calculatePowerupBoost(level)
    return 200 * math.pow(1.1, level)
end

function GameScene:checkGameOver(dt)
    if
        Camera.velocityX == 0
        and Player.posY >= (designHeight - (Player.dim / 2))
    then
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

    if
        Camera.velocityX == 0
        and Player.posY >= (designHeight - (Player.dim / 2))
    then
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

    self.ObstacleSpawner:clearEntities()
    self.CoinSpawner:clearEntities()

    -- FIXME: can we just make a new instance of these? or add a reset() function to them?
    self.ObstacleSpawner.spawnDistance = designWidth
    self.CoinSpawner.spawnDistance = designWidth / 2
end

return GameScene
