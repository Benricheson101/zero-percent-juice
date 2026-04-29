local M = {}

---Truncates text to fit in `maxWidth` with a love2d font
---@param font love.Font
---@param str string
---@param maxWidth number
function M.trunc(font, str, maxWidth)
    assert(maxWidth > 0, 'maxWidth must be positive and non-zero')

    local trunc = str
    while font:getWidth(trunc) > maxWidth do
        trunc = trunc:sub(1, -2)
    end

    return trunc
end

return M
