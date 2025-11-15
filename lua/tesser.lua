local M = {}
local data = require(".data")

function M.setup() end

function M.open(char)
    local cwd = vim.fn.getcwd(-1)
    local project = data.load_project(cwd)

    if not project[char] then
        vim.notify(("Tesser: [%s] = %s"):format(char, project[char]), vim.log.levels.ERROR)
        return
    end

    vim.cmd(("e %s"):format(project[char]))
end

function M.set(char)
    local cwd = vim.fn.getcwd(-1)
    local project = data.load_project(cwd)

    project[char] = char and vim.fn.expand("%:.") or nil
    data.save_project(cwd)

    vim.notify(("Tesser: [%s] = %s"):format(char, project[char]))
end

function M.clear()
    local cwd = vim.fn.getcwd(-1)
    data.delete_project(cwd)
    vim.notify(("Tesser: Cleared all from %s"):format("cwd"))
end

return M
