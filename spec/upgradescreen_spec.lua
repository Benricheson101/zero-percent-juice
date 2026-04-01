local player = require('player')
local UpgradeScreen = require('scenes.upgradeScreen')
local upgrades = require('upgrades')
local SceneManager = require('renderer.scenemanager')
local Ui = require('util.ui')
local GameScene = require('scenes.game')

describe('UpgradeScreen', function()
    UpgradeScreen.scene_manager = SceneManager:new {
        upgrade = UpgradeScreen,
        game = GameScene,
    }

    before_each(function()
        UpgradeScreen.scene_manager:transition('upgrade')
        player.money = 1000

        for _, upgrade in ipairs(upgrades) do
            upgrade.level = 0
        end
    end)

    it('decreases player money when buying an upgrade', function()
        local startMoney = player.money
        local x, y, _ = UpgradeScreen.calculateUpgradePosition(1)
        local upgrade = upgrades[1]

        assert.is.equal(startMoney, player.money)

        local upgradeCost = upgrade:getPrice()
        UpgradeScreen:mousepressed(x + 1, y + 1, 1)
        assert.is.equal(startMoney - upgradeCost, player.money)
        startMoney = startMoney - upgradeCost

        upgradeCost = upgrade:getPrice()
        UpgradeScreen:mousepressed(x + 1, y + 1, 1)
        assert.is.equal(startMoney - upgradeCost, player.money)
        startMoney = startMoney - upgradeCost
    end)

    it('increases upgrade level when purchasing', function()
        local x, y, _ = UpgradeScreen.calculateUpgradePosition(1)
        local upgrade = upgrades[1]

        assert.is.equal(0, upgrade:getLevel())

        UpgradeScreen:mousepressed(x + 1, y + 1, 1)
        assert.is.equal(1, upgrade:getLevel())

        UpgradeScreen:mousepressed(x + 1, y + 1, 1)
        assert.is.equal(2, upgrade:getLevel())
    end)

    it("doesn't allow buying upgrades that cost more than balance", function()
        local x, y, _ = UpgradeScreen.calculateUpgradePosition(1)
        local upgrade = upgrades[1]

        while player.money > upgrade:getPrice() do
            UpgradeScreen:mousepressed(x + 1, y + 1, 1)
        end

        local level = upgrade:getLevel()
        UpgradeScreen:mousepressed(x + 1, y + 1, 1)
        assert.is.equal(level, upgrade:getLevel())
    end)

    it('switches to game scene when gauge is clicked', function()
        assert.is.equal(
            UpgradeScreen.scene_manager.active,
            UpgradeScreen.scene_manager.scenes.upgrade
        )

        local x, y = Ui:scaleCoord(640, 500)
        UpgradeScreen:mousepressed(x, y, 1)
        assert.is.equal(
            UpgradeScreen.scene_manager.active,
            UpgradeScreen.scene_manager.scenes.game
        )
    end)
end)
