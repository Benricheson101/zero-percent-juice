local json = require('JSON')

---@class GameConfig
---@field leaderboard_api string
local config = {}

---@param path string
function config:loadConfig(path)
    local ok, file = pcall(love.filesystem.read, 'string', path)
    if not ok or not file or #file == 0 then
        print('failed to load config file. using defaults')
        -- defaults if the config file can't be loaded
        file = [[
            {
                "leaderboard_api": "http://localhost:8000"
            }
        ]]
    end

    local conf = json:decode(file)
    self.leaderboard_api = conf.leaderboard_api
end

return config
