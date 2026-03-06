local assets = {
    fonts = {},
    images = {},
}

function assets.loadFont(path, size)
    local loadedFontFamily = assets.fonts[path]
    if loadedFontFamily ~= nil then
        local loadedFont = loadedFontFamily[size]
        if loadedFont ~= nil then
            return loadedFont
        end
    end

    local font = love.graphics.newFont(path, size)
    assets.fonts[path] = {
        [size] = font,
    }
    return font
end

function assets.loadImage(path)
    local image = assets.images[path]
    if image ~= nil then
        return image
    end

    image = love.graphics.newImage(path)
    assets.images[path] = image
    return image
end

return assets
