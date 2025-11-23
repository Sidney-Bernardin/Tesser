local config = require("lua.config")
local M = {}

--- Converts project from key-value map, to formated lines.
--- @param map table<string, string>
--- @return string[] lines
function M.encode_project(map)
    local lines = {}
    for _, group in ipairs(config.keys) do
        for key in group:gmatch(".") do
            if map[key] then
                table.insert(lines, ("%s %s"):format(key, map[key]))
            else
                table.insert(lines, key)
            end
        end
        table.insert(lines, "")
    end
    table.remove(lines)
    return lines
end

--- Converts project from formated lines, to key-value map.
--- @param lines string[]
--- @return table<string, string> map
function M.decode_project(lines)
    local map = {}
    for _, line in ipairs(lines) do
        line = line:gsub("^%s*(.-)%s*$", "%1")     -- Trim surrounding whitespace.
        local key, fp = line:match("(%S*)%s*(.*)") -- Capture key and filepath.

        if key and config.is_key_configured(key) and fp and fp ~= "" and fp ~= "" then
            map[key] = fp
        end
    end
    return map
end

return M
