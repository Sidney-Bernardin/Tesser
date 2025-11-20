local M = {
    keys = "1234567890qwertyuiopasdfghjkl;zxcvbnm,./",
    projects = {},
}

--- Initialize data directory.
local data_path = ("%s/tesser"):format(vim.fn.stdpath("data"))
if vim.fn.isdirectory(data_path) == 0 then
    vim.fn.mkdir(data_path)
end

--- Returns current project's ID.
function M.get_current_project_id()
    local cwd = vim.fn.getcwd(-1)
    return ("%s/%s.json"):format(data_path, vim.fn.sha256(cwd))
end

--- Returns current project and it's ID.
--- @return string project_id
--- @return table<string, string> project
function M.load_current_project()
    local project_id = M.get_current_project_id()

    if not M.projects[project_id] then
        local _, project_json = pcall(vim.fn.readblob, project_id)
        local ok, project = pcall(vim.json.decode, project_json)
        M.projects[project_id] = ok and project or {}
    end

    return project_id, M.projects[project_id]
end

--- Saves project to disk.
function M.save_project(project_id)
    local project_file = assert(io.open(project_id, "w"))
    project_file:write(vim.json.encode(M.projects[project_id]))
    project_file:close()
end

--- Sets current file to key.
--- @param key string
function M.set(key)
    local project_id, project = M.load_current_project()
    project[key] = vim.fn.expand("%:.")
    M.save_project(project_id)
    vim.notify(("Tesser: [%s] set to %s"):format(key, project[key]))
end

--- Opens key's file.
--- @param key string
function M.open(key)
    local _, project = M.load_current_project()

    if not project[key] then
        vim.notify(("Tesser: [%s] is empty"):format(key), vim.log.levels.ERROR)
        return
    end

    vim.cmd(("e %s"):format(project[key]))
end

--- Clears key.
--- @param key string
function M.clear(key)
    local project_id, project = M.load_current_project()
    project[key] = nil
    M.save_project(project_id)
    vim.notify(("Tesser: [%s] cleared"):format(key))
end

--- Clears all keys.
function M.clear_all()
    local project_id = M.get_current_project_id()
    M.projects[project_id] = nil
    os.remove(project_id)
    vim.notify("Tesser: Cleared all")
end

--- Prints keys.
function M.print()
    local _, project = M.load_current_project()

    for key in M.keys:gmatch(".") do
        print(("%s: %s"):format(key, project[key]))
    end
end

return M
