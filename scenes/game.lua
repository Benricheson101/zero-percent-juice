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

    EntitySpawner = EntitySpawner:new {
        spawnUpgradeName = "Rock Buster",
        spawnDistance = designWidth,
        baseVelocityX = 50,
        image = 'images/Obstacle.png',
        spawnUpgradeEffectFunc = GameScene.obsticaleSpawFrequencyCalculation
    }

    CoinSpawner = EntitySpawner:new {
        spawnUpgradeName = "Coin Magnet",
        spawnDistance = designWidth / 2,
        baseVelocityX = 50,
        image = 'images/Coin.png',
        spawnUpgradeEffectFunc = GameScene.coinSpawnFrequencyCalculation
    }

    return o
end

function GameScene:update(dt)
    Player.update(dt)
    Camera.update(dt)
    EntitySpawner:update(dt)
    CoinSpawner:update(dt)

    EntitySpawner:updateEntityVelocityX(Camera.getVelocityX())
    CoinSpawner:updateEntityVelocityX(Camera.getVelocityX())
    GameScene:checkCollision(Player.posX, Player.posY, Player.dim)
end

function GameScene:draw()
    love.graphics.setColor(1, 1, 1)
    Background.draw(Camera)
    Player.draw()
    EntitySpawner:draw()
    CoinSpawner:draw()
end

function GameScene:keypressed(key)
    Player.keypressed(key)
    EntitySpawner:keypressed(key)
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
    local speed = GameScene.calculateStartingSpeed(startSpeedUpgrade:getLevel()) --calculate the statring speed
    Camera.velocityX = speed -- apply the starting speed
    Camera.xPos = 0 -- reset posotion to start
end

function GameScene:checkCollision(posX, posY, dim)
    if EntitySpawner:checkCollision(posX, posY, dim) then
        -- Camera now to handle x velocity
        Camera.changeVelocityX(-150)
    end

    if CoinSpawner:checkCollision(posX, posY, dim) then
        Player.money = Player.money + 10
    end
end

function GameScene.obsticaleSpawFrequencyCalculation(level)
    return 720 + 15*level
end

function GameScene.coinSpawnFrequencyCalculation(level)
    return 720 /(1+ 0.1*level)
end

return GameScene
