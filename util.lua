local M = {}

---Converts rgb color codes from [0, 256) to [0, 1)
---@param r integer red
---@param g integer green
---@param b integer blue
---@param a? integer alpha
function M.rgb(r, g, b, a)
    a = a or 256

    return {
        r / 256,
        g / 256,
        b / 256,
        a / 256,
    }
end

function M.hex(hex)
    return M.rgb(
        bit.band(bit.rshift(hex, 16), 255),
        bit.band(bit.rshift(hex, 8), 255),
        bit.band(hex, 255),
        256
    )
end

return M
