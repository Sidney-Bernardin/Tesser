local config = require("lua.config")
local serial = require("lua.serial")
local data = require("lua.data")

local M = {
    keys = config.keys,
}

local tesserAutoGroup = vim.api.nvim_create_augroup("Tesser", { clear = true })

function M.setup(opts)
    config.opts = vim.tbl_deep_extend("force", config, opts)
end

--- Sets current file to key.
--- @param key string
function M.set(key)
    local project_id, project = data.load_current_project()
    project[key] = vim.fn.expand("%:.")
    data.save_project(project_id)
    vim.notify(("Tesser: [%s] set to %s"):format(key, project[key]))
end

--- Opens key's file.
--- @param key string
function M.open(key)
    local _, project = data.load_current_project()

    if not project[key] then
        vim.notify(("Tesser: [%s] is empty"):format(key), vim.log.levels.ERROR)
        return
    end

    vim.cmd(("e %s"):format(project[key]))
end

--- Clears key.
--- @param key string
function M.clear(key)
    local project_id, project = data.load_current_project()
    project[key] = nil
    data.save_project(project_id)
    vim.notify(("Tesser: [%s] cleared"):format(key))
end

--- Clears all keys.
function M.clear_all()
    local project_id = data.get_current_project_id()
    data.projects[project_id] = nil
    os.remove(project_id)
    vim.notify("Tesser: Cleared all")
end

--- Opens edit window.
function M.edit()
    local project_id, project = data.load_current_project()

    -- Create buffer.
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "tesser")
    vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, serial.encode_project(project))

    -- Create window.
    local width = math.floor(vim.o.columns * 0.5)
    local height = math.floor(vim.o.lines * 0.75)
    local win = vim.api.nvim_open_win(buf, true, {
        title = "Tesser",
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        border = "rounded",
    })
    vim.api.nvim_set_option_value("cc", nil, { win = win })
    vim.api.nvim_set_option_value("signcolumn", "no", { win = win })

    vim.api.nvim_create_autocmd({ "BufWriteCmd", "BufLeave" }, {
        group = tesserAutoGroup,
        buffer = buf,
        callback = function()
            project = serial.decode_project(vim.api.nvim_buf_get_lines(buf, 0, -1, true))
            data.projects[project_id] = project
            data.save_project(project_id)
            vim.api.nvim_buf_delete(buf, { force = true })
        end,
    })

    local close_win = function() vim.api.nvim_win_close(win, true) end
    vim.keymap.set("n", "q", close_win, { buffer = buf })
    vim.keymap.set("n", "<esc>", close_win, { buffer = buf })
end

return M
