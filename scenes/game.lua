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

    return o
end

function GameScene:update(dt)
    Player.update(dt)
    Camera.update(dt)
    ObstacleSpawner:update(dt)
    CoinSpawner:update(dt)

    ObstacleSpawner:updateEntityVelocityX(Camera.getVelocityX())
    CoinSpawner:updateEntityVelocityX(Camera.getVelocityX())
    GameScene:checkCollision(Player.posX, Player.posY, Player.dim)
end

function GameScene:draw()
    love.graphics.setColor(1, 1, 1)
    Background.draw(Camera)
    Player.draw()
    ObstacleSpawner:draw()
    CoinSpawner:draw()
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
    local speed = GameScene.calculateStartingSpeed(startSpeedUpgrade:getLevel()) --calculate the statring speed
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

return GameScene
