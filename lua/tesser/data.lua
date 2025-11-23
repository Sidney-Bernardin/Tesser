local serial = require("tesser.serial")

local M = {
    data_path = ("%s/tesser"):format(vim.fn.stdpath("data")),
    projects = {},
}

--- Initialize data directory.
if vim.fn.isdirectory(M.data_path) == 0 then
    vim.fn.mkdir(M.data_path)
end

--- Returns current project's ID.
function M.get_current_project_id()
    local cwd = vim.fn.getcwd(-1)
    return ("%s/%s.txt"):format(M.data_path, vim.fn.sha256(cwd))
end

--- Returns current project and it's ID.
--- @return string project_id
--- @return table<string, string> project
function M.load_current_project()
    local project_id = M.get_current_project_id()

    if not M.projects[project_id] then
        local ok, lines = pcall(vim.fn.readfile, project_id, "b")
        if ok then
            M.projects[project_id] = serial.decode_project(lines)
        else
            M.projects[project_id] = {}
        end
    end

    return project_id, M.projects[project_id]
end

--- Saves project to disk.
function M.save_project(project_id)
    local lines = serial.encode_project(M.projects[project_id])
    vim.fn.writefile(lines, project_id, "b")
end

return M
