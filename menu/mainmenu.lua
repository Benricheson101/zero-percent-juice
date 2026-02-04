local constants = require('constants')
local MenuButton = require('menu.button')

local MainMenu = {}

---@type MenuButton[]
local components = {
    MenuButton:new({
        text = 'Start Game',
        width = 196,
        height = 61,
        on_click = function()
            print('Clicked "Start Game"')
        end,
    }),

    MenuButton:new({
        text = 'Leaderboard',
        width = 196,
        height = 61,
        on_click = function()
            print('Clicked "Leaderboard"')
        end,
    }),

    MenuButton:new({
        text = 'Exit',
        width = 196,
        height = 61,
        on_click = function()
            print('Clicked "Exit"')
            love.event.quit(0)
        end,
    }),
}

local window_width, _ = love.graphics.getDimensions()

function MainMenu.draw()
    local mouse_x, mouse_y = love.mouse.getPosition()

    love.graphics.clear(constants.colors.skyblue)

    love.graphics.setFont(constants.fonts.title)
    love.graphics.setColor(constants.colors.ui.button_background)
    love.graphics.printf('Zero Percent Juice', 0, 72, window_width, 'center')

    local start = 243
    local gap = 30
    for _, c in ipairs(components) do
        local tl_x = math.floor((window_width / 2) - (c.width / 2))
        local tl_y = start
        local br_x = tl_x + c.width
        local br_y = tl_y + c.height

        local hover = mouse_x >= tl_x
            and mouse_x <= br_x
            and mouse_y >= tl_y
            and mouse_y <= br_y

        c.state = hover and 'hover' or 'default'
        c.world_bounds = {
            { x = tl_x, y = tl_y },
            { x = br_x, y = br_y },
        }

        love.graphics.draw(c:draw(), tl_x, tl_y)
        start = start + gap + c.height
    end
end

function MainMenu.mousepressed(x, y)
    for _, c in ipairs(components) do
        local wb = c.world_bounds

        local inside_component = x >= wb[1].x
            and x <= wb[2].x
            and y >= wb[1].y
            and y <= wb[2].y

        if inside_component then
            c:on_click()
        end
    end
end

return MainMenu
