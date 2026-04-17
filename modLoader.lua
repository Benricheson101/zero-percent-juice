--- The object responacbel for loading and managing mods 
local modloader = {}

modloader.mods = {}

--- Look for and load mods from the mods folder
function modloader.loadMods()
    --list all the files in the mods folder
    local files = love.filesystem.getDirectoryItems('mods')
    for i = 1, #files, 1 do
        --go through each file
        local file = files[i]
        --if the file starts with mod_ and ends with .lua then its a mod teempet to load it
        if file:sub(-4) == '.lua' and file:sub(1, 4) == 'mod_' then
            --load the mod
            print("laodimg mod "..file)
            local mod = require('mods.' .. file:sub(1, -5)) --remove the .lua from the end
            if mod ~= nil and mod ~= true then -- if the mod returned an object
                table.insert(modloader.mods, mod) -- add that to the list of mods
            end
        end
    end
end

--- Run the mods game laoded function if they have one
--- @param sceneManager SceneManager the games scene manager
function modloader.gameLoaded(sceneManager)
    for i = 1, #modloader.mods, 1 do --for each mod
        local mod = modloader.mods[i]
        if mod.gameLoaded ~= nil then --check if the mod has decleained a game laoded function
            mod.gameLoaded(sceneManager) --- run that function
        end
    end
end

--- Pass any keypressed events to the mods
--- @param key string the key that was pressed
--- @param ... any other arguments that love.keypressed passes
function modloader.keypressed(key, ...)
    for i = 1, #modloader.mods, 1 do --for each mod
        local mod = modloader.mods[i]
        if mod.keypressed ~= nil then --check if the mod has decleained a keypressed function
            mod.keypressed(key, ...) --- run that function
        end
    end
end

--- Pass any keyreleased events to the mods
--- @param key string the key that was released
--- @param ... any other arguments that love.keyreleased passes
function modloader.keyreleased(key, ... )
    for i = 1, #modloader.mods, 1 do --for each mod
        local mod = modloader.mods[i]
        if mod.keyreleased ~= nil then --check if the mod has decleained a keyreleased function
            mod.keyreleased(key, ...) --- run that function
        end
    end
end

--- Pass any mousepressed events to the mods
--- @param ... any arguments that love.mousepressed passes
function modloader.mousepressed(...)
    for i = 1, #modloader.mods, 1 do --for each mod
        local mod = modloader.mods[i]
        if mod.mousepressed ~= nil then --check if the mod has decleained a mousepressed function
            mod.mousepressed(...) --- run that function
        end
    end
end

--- Pass any mousereleased events to the mods
--- @param ... any arguments that love.mousereleased passes
function modloader.mousereleased(...)
    for i = 1, #modloader.mods, 1 do --for each mod
        local mod = modloader.mods[i]
        if mod.mousereleased ~= nil then --check if the mod has decleained a mousereleased function
            mod.mousereleased(...) --- run that function
        end
    end
end

return modloader