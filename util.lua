local M = {}

function M.color(r, g, b, a)
    a = a or 256

    return {
        r / 256,
        g / 256,
        b / 256,
        a / 256,
    }
end

return M
