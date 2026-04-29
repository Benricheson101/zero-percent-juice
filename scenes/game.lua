local Scene = require('renderer.scene')
local Player = require('player')
local Camera = require('camera')
local Background = require('background')
local Upgrades = require('upgrades')
local Ui = require('util.ui')
local EntitySpawner = require('entitySpawner')
local Fonts = require('util.fonts')
local Assets = require('util.assets')

local designWidth = 1280
local designHeight = 720

---@class GameScene : Scene
---@field ObstacleSpawner EntitySpawner
---@field CoinSpawner EntitySpawner
---@field baseGameOverTimer number
---@field gameOver boolean
---@field gameOverAnimationTimer number
---@field gameOverSound boolean
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
        accelerationY = 350,
        decelerationX = 50,
        decelerationY = 50,
        maxVelocityX = 600,
        maxVelocityY = 300,
        soundPath = 'assets/sounds/bounceSound.mp3',
    }

    Camera.load(Player)
    Background.load()

    ---@diagnostic disable-next-line: redundant-parameter
    o.ObstacleSpawner = EntitySpawner:new {
        spawnUpgradeName = 'Rock Reducer',
        spawnDistance = designWidth,
        baseVelocityX = 50,
        image = 'images/Obstacle.png',
        soundPath = 'assets/sounds/obstacleSound.mp3',
        spawnUpgradeEffectFunc = GameScene.obstacleSpawnFrequencyCalculation,
    }

    --TODO: find a way for coins to be able to spawn way earlier
    ---@diagnostic disable-next-line: redundant-parameter
    o.CoinSpawner = EntitySpawner:new {
        spawnUpgradeName = 'Coin Replictor',
        spawnDistance = 0,
        baseVelocityX = 50,
        image = 'images/Coin.png',
        soundPath = 'assets/sounds/coinSound.mp3',
        spawnUpgradeEffectFunc = GameScene.coinSpawnFrequencyCalculation,
    }

    o.baseGameOverTimer = 3
    o.currentGameOverTimer = o.baseGameOverTimer
    o.gameOver = false
    o.gameOverAnimationTimer = 6
    o.gameOverSound = false

    ---@diagnostic disable-next-line: redundant-parameter
    o.PowerUpSpawner = EntitySpawner:new {
        spawnUpgradeName = 'Boosters',
        spawnDistance = designWidth / 2,
        baseVelocityX = 50,
        image = 'images/Powerup.png',
        soundPath = 'assets/sounds/powerUpSound.mp3',
        spawnUpgradeEffectFunc = GameScene.powerUpSpawnerFrequencyCalculation,
    }

    return o
end

function GameScene:update(dt)
    Player.changeScore(Camera.getVelocityX() * dt)
    Player.update(dt)
    Camera.update(dt)
    self.ObstacleSpawner:update(dt)
    self.CoinSpawner:update(dt)
    self.PowerUpSpawner:update(dt)

    self.ObstacleSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self.CoinSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self.PowerUpSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self:checkCollision(Player.posX, Player.posY, Player.dim)

    if self.gameOver then
        self.gameOverAnimationTimer = self.gameOverAnimationTimer - dt
        if self.gameOverAnimationTimer < 0 then
            self.scene_manager:transition('leaderboardsubmit')
        end
    else
        self:checkGameOver(dt)
    end
end

function GameScene:draw()
    love.graphics.setColor(1, 1, 1)
    Background.draw(Camera)
    Player.draw()
    self.ObstacleSpawner:draw()
    self.CoinSpawner:draw()
    self:gameOverTimerText()
    self.PowerUpSpawner:draw()
    self:displayScore()
    if self.gameOver then
        self:drawGameOverAnimation()
    end
    if self.gameOverSound then
        self:playGameOverSound()
    end
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

--- Calculates the inital speed of the player based on the level of the start speed upgrade
--- @param level number the level of the start speed upgrade
--- @return number the starting speed of the player
function GameScene.calculateStartingSpeed(level)
    return 225 + 125 * level
end

function GameScene:enter()
    --when the game starts
    local startSpeedUpgrade = Upgrades.getUpgrade('Tank Pressure') -- get the start speed upgrade
    assert(startSpeedUpgrade ~= nil, 'Tank Pressure upgrade not found')
    local speed = self.calculateStartingSpeed(startSpeedUpgrade:getLevel()) --calculate the starting speed
    Camera.velocityX = speed -- apply the starting speed
    Camera.maxVelocityX = speed
    Camera.xPos = 0 -- reset posotion to start
    Player.score = 0
    self:reset()
    --spawn some coins at the start of the level so players just staring out can actually get some coins for upgreads
    self.CoinSpawner:spawn(
        math.random(designHeight * 0.05, designHeight * 0.95)
    )
    self.CoinSpawner:spawn(
        math.random(designHeight * 0.05, designHeight * 0.95)
    )
    self.CoinSpawner:spawn(
        math.random(designHeight * 0.05, designHeight * 0.95)
    )
    self.CoinSpawner:spawn(
        math.random(designHeight * 0.05, designHeight * 0.95)
    )
    self.CoinSpawner.entities[1].posX = 1280 * 0.33
    self.CoinSpawner.entities[2].posX = 1280 * 0.66
    self.CoinSpawner.entities[3].posX = 1280 * 0.99
    self.CoinSpawner.entities[4].posX = 1280 * 1.33
end

function GameScene:checkCollision(posX, posY, dim)
    local obstacleSpeedReductionUpgrade = Upgrades.getUpgrade('Rock Buster')
    local coinValueUpgrade = Upgrades.getUpgrade('Profit Boost')
    local powerUpUpgrade = Upgrades.getUpgrade('Boost Power')
    assert(
        obstacleSpeedReductionUpgrade ~= nil,
        'Rock Buster upgrade not found'
    )
    assert(coinValueUpgrade ~= nil, 'Profit Boost upgrade not found')
    --obstacle collision
    if self.ObstacleSpawner:checkCollision(posX, posY, dim) then
        -- Camera now to handle x velocity
        local reduction = GameScene.calculateObstacleSpeedReduction(
            obstacleSpeedReductionUpgrade:getLevel()
        )
        Camera.changeVelocityX(reduction)

        Player.changeScore(-800)
    end

    --coin collision
    if self.CoinSpawner:checkCollision(posX, posY, dim) then
        Player.money = Player.money
            + GameScene.calculateCoinValue(coinValueUpgrade:getLevel())
        print('Money: ' .. Player.money)
        Player.changeScore(250)
    end

    assert(powerUpUpgrade ~= nil, 'Boost Power upgrade not found')
    if self.PowerUpSpawner:checkCollision(posX, posY, dim) then
        local boostAmount =
            GameScene.calculatePowerupBoost(powerUpUpgrade:getLevel())
        Camera.changeVelocityX(boostAmount)
        Player.changeScore(1000)
    end
end

--- Calculates how often the rock obstacle should spawn based on the level of the rock buster upgrade
--- @param level number the level of the rock buster upgrade
--- @return number the distance the player has to travel before the next obstacle spawns
function GameScene.obstacleSpawnFrequencyCalculation(level)
    return 720 + 15 * level
end

--- Calculate how often coins should spawn based on the level of <relavant upgrade name here>
--- @param level number the level of the <relevant upgrade name here> upgrade
--- @return number the distance the player has to travel before the next coin spawns
function GameScene.coinSpawnFrequencyCalculation(level)
    return 720 / (1 + 0.1 * level)
end

--- TEMPORARY FUNCTION, CHANGE ONCE POWER UP UPGRADES ARE IMPLEMENTED
--- @param level number the level of the <relevant upgrade name here> upgrade
--- @return number the distance the player has to travel before the next power up spawns
function GameScene.powerUpSpawnerFrequencyCalculation(level)
    if level == 0 then
        return 2147483648 -- basically never
    end
    return 1000 / (0.1 * level) + Player.score / 10 -- decreazse how often they apppear the farteher the player gets to try and prevent infinte runs
end

--- Calculate how much speed to remove from the player when they hit an obstacle
--- @param level number the level of the rock reducer upgrade
--- @return number the amount of speed to remove
function GameScene.calculateObstacleSpeedReduction(level)
    return -150 * math.pow(0.96, level)
end

--- Calculae how much each coin is worth
--- @param level number the level of the profit boost upgrade
--- @return number the value of each coin
function GameScene.calculateCoinValue(level)
    return 10 + math.floor(math.pow(level, 1.35))
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
            self.currentGameOverTimer = 0
            Player:roundGameOver()
            --- self.scene_manager:transition('leaderboardsubmit')
            self.gameOver = true
            self.gameOverSound = true
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

function GameScene:displayScore()
    local posX, posY = Ui:scaleCoord(0, 0)
    local scale = Ui:getScale()

    love.graphics.setColor(1, 0, 0)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(Fonts.impact50)

    love.graphics.printf(
        'Score: ' .. math.ceil(Player.score),
        posX,
        posY,
        Ui:getWidth(),
        'left',
        0,
        scale,
        scale
    )

    love.graphics.setColor(1, 1, 1)
end

function GameScene:reset()
    Player.posX = Ui:getWidth() * 0.2
    Player.posY = Ui:getHeight() / 2

    Player.velocityX = 0
    Player.velocityY = 0

    self.ObstacleSpawner:clearEntities()
    self.CoinSpawner:clearEntities()
    self.PowerUpSpawner:clearEntities()

    -- FIXME: can we just make a new instance of these? or add a reset() function to them?
    self.ObstacleSpawner.spawnDistance = designWidth
    self.CoinSpawner.spawnDistance = 0
    self.PowerUpSpawner.spawnDistance = designWidth / 2

    self.currentGameOverTimer = self.baseGameOverTimer
    self.gameOver = false
    self.gameOverAnimationTimer = 6
    self.gameOverSound = false
end

function GameScene:drawGameOverAnimation()
    local tsunami = Assets.loadImage('images/Tsunami.png', 'nearest')
    -- 1.5625
    local posX, posY = Ui:scaleCoord(
        designWidth * ((5 - self.gameOverAnimationTimer) * 2.25 / 5),
        0
    )
    local scale = Ui:getScale()
    love.graphics.draw(
        tsunami,
        posX,
        posY,
        0,
        scale,
        scale,
        tsunami:getWidth(),
        0
    )

    love.graphics.setColor(1, 0.655, 0)

    love.graphics.polygon(
        'fill',
        posX - (scale * designHeight * 2),
        posY,
        posX - (scale * designHeight * 0.5),
        posY + (scale * designHeight),
        posX - (scale * designHeight * 2),
        posY + (scale * designHeight)
    )

    love.graphics.rectangle(
        'fill',
        posX - ((scale * designHeight * 2) + (scale * designWidth * 1.5)),
        posY,
        scale * designWidth * 1.5,
        scale * designHeight
    )

    love.graphics.setColor(1, 1, 1)
end

function GameScene:playGameOverSound()
    local sound = Assets.loadSound('assets/sounds/patheticScreamingSound.mp3')
    sound:play()
    self.gameOverSound = false
end

return GameScene
