local util = require('util')
local color = util.color
local hex = util.hex

return {
    fonts = {
        ui = love.graphics.newFont('assets/consola.ttf', 32),
    },
    colors = {
        red = { 1, 0, 0, 1 },
        green = { 0, 1, 0, 1 },
        blue = { 0, 0, 1, 1 },
        white = { 1, 1, 1, 1 },
        black = { 0, 0, 0, 1 },

        --- background of main menu
        skyblue = hex(0x699BD7),
    },
}
