function love.load()

end

function love.draw()
  love.graphics.print('Hello World', 400, 300)
end

function love.update(dt)

end

function love.keypressed(key, keyCode, isRepeat)
  print('key pressed ' .. key .. ' key code ' .. keyCode .. ' is repeat ' .. (isRepeat and 'true' or 'false'))

  print(
    'is shift + 4 ($) down: ',
      key == '4' and love.keyboard.isDown('lshift')
  )
end

function love.keyreleased(key, keyCode)


end