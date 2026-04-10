local Scene = require('renderer.scene')
local Player = require('player')
local Camera = require('camera')
local Background = require('background')
local Upgrades = require('upgrades')
local Ui = require('util.ui')
local EntitySpawner = require('entitySpawner')

local designWidth = 1280
-- local designHeight = 720

---@class GameScene : Scene
---@field obsticaleSpawner EntitySpawner
---@field CoinSpawner EntitySpawner
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

    ---@diagnostic disable-next-line: redundant-parameter
    o.obsticaleSpawner = EntitySpawner:new {
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

    return o
end

function GameScene:update(dt)
    Player.update(dt)
    Camera.update(dt)
    self.obsticaleSpawner:update(dt)
    self.CoinSpawner:update(dt)

    self.obsticaleSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self.CoinSpawner:updateEntityVelocityX(Camera.getVelocityX())
    self:checkCollision(Player.posX, Player.posY, Player.dim)
end

function GameScene:draw()
    love.graphics.setColor(1, 1, 1)
    Background.draw(Camera)
    Player.draw()
    self.obsticaleSpawner:draw()
    self.CoinSpawner:draw()
end

function GameScene:keypressed(key)
    Player.keypressed(key)
    self.obsticaleSpawner:keypressed(key)
    self.CoinSpawner:keypressed(key)
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
    local speed = GameScene.calculateStartingSpeed(startSpeedUpgrade:getLevel()) --calculate the statring speed
    Camera.velocityX = speed -- apply the starting speed
    Camera.xPos = 0 -- reset posotion to start
end

function GameScene:checkCollision(posX, posY, dim)
    local obsticalSpeedReductionUpgrade = Upgrades.getUpgrade('Rock Buster')
    local coinValueUpgrade = Upgrades.getUpgrade('Profit Boost')
    assert(
        obsticalSpeedReductionUpgrade ~= nil,
        'Rock Buster upgrade not found'
    )
    assert(coinValueUpgrade ~= nil, 'Profit Boost upgrade not found')
    --obstical collision
    if self.obsticaleSpawner:checkCollision(posX, posY, dim) then
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

return GameScene
