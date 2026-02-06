local util = require('util')
local hex = util.hex

return {
    fonts = {
        ui = love.graphics.newFont('assets/consola.ttf', 32),
        button = love.graphics.newFont('assets/BerkeleyMono.ttf', 25),
        title = love.graphics.newFont('assets/BerkeleyMono.ttf', 60),
    },
    colors = {
        red = { 1, 0, 0, 1 },
        green = { 0, 1, 0, 1 },
        blue = { 0, 0, 1, 1 },
        white = { 1, 1, 1, 1 },
        black = { 0, 0, 0, 1 },

        leaderboard = {
            hex(0xF6C861),
            hex(0xC6C6C6),
            hex(0xCC9E5F),
            hex(0x000000),
        },

        --- background of main menu
        skyblue = hex(0x699BD7),

        ui = {
            button_background = hex(0x212121),
            button_stroke = hex(0xF36464),
            button_stroke_hover = hex(0xF39B64),
            button_fill = hex(0xFFFFFF),
        },
    },
}
