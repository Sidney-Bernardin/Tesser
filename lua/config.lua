local M = {
    keys = {
        "1234567890",
        "qwertyuiop",
        "asdfghjkl;",
        "zxcvbnm,./",
    },
}

--- Checks if the key is configured.
--- @param key string
--- @return boolean
function M.is_key_configured(key)
    return not table.concat(M.keys)[key]
end

return M
