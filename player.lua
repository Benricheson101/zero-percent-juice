local Player = {}

function Player.load(posX, posY, velocityY, accelerationY, decelerationY, maxVelocityY)

    Player.posX = posX
    Player.posY = posY
    Player.velocityY = velocityY
    Player.accelerationY = accelerationY
    Player.decelerationY = decelerationY
    Player.maxVelocityY = maxVelocityY

    love.graphics.setDefaultFilter('nearest', 'nearest')
    Player.image = love.graphics.newImage("images/TempPlayer.png")
    love.graphics.setDefaultFilter('linear', 'linear')

    Player.dim = Player.image:getHeight() * 3
    Player.rotation = 0


end

function Player.update(dt)

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		Player.velocityY = Player.velocityY - Player.accelerationY * dt
	end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
		Player.velocityY = Player.velocityY + Player.accelerationY * dt
	end

    Player.posY = Player.posY + Player.velocityY * dt

    if Player.posY < (Player.dim / 2) then
        Player.posY = (Player.dim / 2)
        Player.velocityY = 0
    end
    
    if Player.posY > (love.graphics.getHeight() - (Player.dim / 2)) then
        Player.posY = (love.graphics.getHeight() - (Player.dim / 2))
        Player.velocityY = 0
    end

    if Player.velocityY > 0 then
        Player.velocityY = Player.velocityY - Player.decelerationY * dt
        if Player.velocityY < 0 then
            Player.velocityY = 0
        end
    end

    if Player.velocityY < 0 then
        Player.velocityY = Player.velocityY + Player.decelerationY * dt
        if Player.velocityY > 0 then
            Player.velocityY = 0
        end
    end

    if Player.velocityY > Player.maxVelocityY then
            Player.velocityY = Player.maxVelocityY
    end

    if Player.velocityY < (Player.maxVelocityY * -1) then
            Player.velocityY = (Player.maxVelocityY * -1)
    end

    Player.rotation = (Player.rotation + (dt * 3)) % (2 * math.pi)

end


function Player.draw()
    love.graphics.draw(Player.image, Player.posX, Player.posY, Player.rotation, 3, 3, Player.dim / 6, Player.dim / 6)
end

Player.money = 1000

return Player