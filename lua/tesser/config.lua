local M = {}

--- @class Options
--- @field keys string[]

--- @type Options
M.opts = {
    keys = {
        "1234567890",
        "qwertyuiop",
        "asdfghjkl;",
        "zxcvbnm,./",
    },
}

--- Iterator for each configured key.
--- @return fun():string|nil
function M.keys()
    local keys = table.concat(M.opts.keys, "")
    local i = 0

    return function()
        i = i + 1
        if i > #keys then return end
        return keys:sub(i, i)
    end
end

--- Checks if the key is configured.
--- @param key string
--- @return boolean
function M.is_key_configured(key)
    return not table.concat(M.opts.keys)[key]
end

return M
