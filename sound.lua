local Sound = {}

function Sound.load()

    -- Sound testing
    CoinSound = love.audio.newSource("sounds/retro-coin-4-236671.mp3", "stream")
    JetSound = love.audio.newSource("sounds/freesound_community-propulsion-jet-engine-67151.mp3", "stream")
    JetSound:setVolume(0)

end

function Sound.keypressed(key)

    if love.keyboard.isDown("space") then
        if not CoinSound:isPlaying() then
            love.audio.play(CoinSound)
        end
    end

end

function Sound.update(dt, speed)

    if not JetSound:isPlaying() then
        love.audio.play(JetSound)
    end

    volume = (math.abs(speed) / 1200)
    JetSound:setVolume(volume)

end

return Sound