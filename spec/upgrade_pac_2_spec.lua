local upgrades = require('upgrades')
local gameScene = require('scenes.game')

describe('Rock Reducer Upgrade', function()
    local game = gameScene:new()
    it('spawn frequency calculation', function()
        --test that the spawn frequency goes up
        local initalSpawnFrequency = game.obsticaleSpawFrequencyCalculation(0)
        local spawnFrequency1 = game.obsticaleSpawFrequencyCalculation(1)
        local spawnFrequency2 = game.obsticaleSpawFrequencyCalculation(2)
        assert.is_true(spawnFrequency1 > initalSpawnFrequency)
        assert.is_true(spawnFrequency2 > spawnFrequency1)
    end)
    it('upgrade exists', function()
        local rockReducerUpgrade = upgrades.getUpgrade('Rock Reducer')
        assert.is_not_nil(rockReducerUpgrade)
    end)
    it('spawn frequency function applied', function()
        local expectedSpawnFrequency = game.obsticaleSpawFrequencyCalculation(2)
        assert.is_true(
            expectedSpawnFrequency
                == game.obsticaleSpawner.spawnUpgradeEffectFunc(2)
        )
        local expectedSpawnFrequency = game.obsticaleSpawFrequencyCalculation(3)
        assert.is_true(
            expectedSpawnFrequency
                == game.obsticaleSpawner.spawnUpgradeEffectFunc(3)
        )
        local expectedSpawnFrequency = game.obsticaleSpawFrequencyCalculation(4)
        assert.is_true(
            expectedSpawnFrequency
                == game.obsticaleSpawner.spawnUpgradeEffectFunc(4)
        )
    end)
    it('spawner gets upgrade', function()
        local rockReducerUpgrade = upgrades.getUpgrade('Rock Reducer')
        assert.is_not_nil(rockReducerUpgrade)
        assert.is_true(game.obsticaleSpawner.spawnUpgrade == rockReducerUpgrade)
    end)
    --the funcility of the varible spawn disrance should be tested with the entity spawner class tests
end)

describe('Rock Buster Upgrade', function()
    local game = gameScene:new()
    it('damage reduction calculation', function()
        --test that the spawn frequency goes up
        local initaldamage = game.calculateObsticalSpeedReduction(0)
        local damage1 = game.calculateObsticalSpeedReduction(1)
        local damage2 = game.calculateObsticalSpeedReduction(2)
        assert.is_true(damage1 < initaldamage)
        assert.is_true(damage2 < damage1)
    end)
    it('upgrade exists', function()
        local rockBusterUpgrade = upgrades.getUpgrade('Rock Buster')
        assert.is_not_nil(rockBusterUpgrade)
    end)

    --prbly should have a behavior test to check that when the player hits an obstical they take damege, not currently sure how to implment this
    -- this would also check that the upgrade is being used
end)

describe('Coin Spawn Frequency Upgrade', function()
    local game = gameScene:new()
    it('spawn frequency calculation', function()
        --test that the spawn frequency goes up
        local initalSpawnFrequency = game.coinSpawnFrequencyCalculation(0)
        local spawnFrequency1 = game.coinSpawnFrequencyCalculation(1)
        local spawnFrequency2 = game.coinSpawnFrequencyCalculation(2)
        assert.is_true(spawnFrequency1 < initalSpawnFrequency)
        assert.is_true(spawnFrequency2 < spawnFrequency1)
    end)
    it('upgrade exists', function()
        local coinSpawnUpgrade = upgrades.getUpgrade('Coin Replictor')
        assert.is_not_nil(coinSpawnUpgrade)
    end)
    it('spawn frequency function applied', function()
        local expectedSpawnFrequency = game.coinSpawnFrequencyCalculation(2)
        assert.is_true(
            expectedSpawnFrequency == game.CoinSpawner.spawnUpgradeEffectFunc(2)
        )
        local expectedSpawnFrequency = game.coinSpawnFrequencyCalculation(3)
        assert.is_true(
            expectedSpawnFrequency == game.CoinSpawner.spawnUpgradeEffectFunc(3)
        )
        local expectedSpawnFrequency = game.coinSpawnFrequencyCalculation(4)
        assert.is_true(
            expectedSpawnFrequency == game.CoinSpawner.spawnUpgradeEffectFunc(4)
        )
    end)
    it('spawner gets upgrade', function()
        local coinSpawnUpgrade = upgrades.getUpgrade('Coin Replictor')
        assert.is_not_nil(coinSpawnUpgrade)
        assert.is_true(game.CoinSpawner.spawnUpgrade == coinSpawnUpgrade)
    end)
    --the funcility of the variable spawn distance should be tested with the entity spawner class tests
end)

describe('Coin Value Upgrade', function()
    local game = gameScene:new()
    it('value calculation', function()
        --test that the value goes up
        local initalValue = game.calculateCoinValue(0)
        local value1 = game.calculateCoinValue(1)
        local value2 = game.calculateCoinValue(2)
        assert.is_true(value1 > initalValue)
        assert.is_true(value2 > value1)
    end)
    it('upgrade exists', function()
        local coinValueUpgrade = upgrades.getUpgrade('Profit Boost')
        assert.is_not_nil(coinValueUpgrade)
    end)
    --prbly should have a behavior test to check that when the player collects a coin they get points, not currently sure how to implment this
    -- this would also check that the upgrade is being used
end)
