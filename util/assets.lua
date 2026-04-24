local assets = {
    fonts = {},
    images = {},
    sounds = {},
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

--- @overload fun(path: string): love.Image
function assets.loadImage(path, filter)
    local image = assets.images[path]
    if image ~= nil then
        return image
    end

    if filter ~= nil then
        love.graphics.setDefaultFilter(filter, filter)
    else
        love.graphics.setDefaultFilter('linear', 'linear')
    end
    image = love.graphics.newImage(path)
    assets.images[path] = image
    return image
end

function assets.loadSound(path)
    local sound = assets.sounds[path]
    if sound ~= nil then
        return sound
    end
    
    sound = love.audio.newSource(path, "static")
    assets.sounds[path] = sound
    return sound
end

return assets
