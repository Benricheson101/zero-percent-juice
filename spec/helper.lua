if unpack == nil then
    _G.unpack = table.unpack
end

if bit == nil then
    _G.bit = {
        band = function(a, b)
            return a & b
        end,
        bor = function(a, b)
            return a | b
        end,
        bxor = function(a, b)
            return a ~ b
        end,
        rshift = function(a, n)
            return a >> n
        end,
        lshift = function(a, n)
            return a << n
        end,
    }
end
