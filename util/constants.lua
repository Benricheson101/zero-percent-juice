local c = require('util.color')

return {
    colors = {
        menu = {
            bg = c.hex(0x699BD7),
            button_bg = c.hex(0x212121),
            button_stroke_normal = c.hex(0xF36464),
            button_stroke_hover = c.hex(0xF39B64),
            button_fill = c.hex(0xFFFFFF),
        },

        textbox = {
            bg = c.hex(0xFFFFFF),
            caret = c.hex(0x212121),
            placeholder = c.hex(0x8c8c8c),
        },

        leaderboard = {
            c.hex(0xF6C861),
            c.hex(0xC6C6C6),
            c.hex(0xCC9E5F),
            c.hex(0x000000),
        },

        title = c.hex(0xFFFFFF),
        error = c.hex(0xF53D3D),
    },
}
