local serial = require("tesser.serial")

local M = {}

local data_path = ("%s/tesser"):format(vim.fn.stdpath("data"))
local projects = {}

--- Initialize data directory.
if vim.fn.isdirectory(data_path) == 0 then
    vim.fn.mkdir(data_path)
end

--- Returns current project's ID.
local function get_current_project_id()
    local cwd = vim.fn.getcwd(-1)
    return ("%s/%s.txt"):format(data_path, vim.fn.sha256(cwd))
end

--- Returns current project and it's ID.
--- @return string project_id
--- @return table<string, string> project
function M.get_current_project()
    local project_id = get_current_project_id()

    if not projects[project_id] then
        local ok, project_lines = pcall(vim.fn.readfile, project_id, "b")
        if ok then
            projects[project_id] = serial.decode_project(project_lines)
        else
            projects[project_id] = {}
        end
    end

    return project_id, projects[project_id]
end

--- Saves project.
function M.save_project(project_id, project)
    projects[project_id] = project
    local project_lines = serial.encode_project(project)
    vim.fn.writefile(project_lines, project_id, "b")
end

--- Deletes project.
function M.delete_current_project()
    local project_id = get_current_project_id()
    projects[project_id] = nil
    os.remove(project_id)
    vim.notify("Tesser: Cleared all")
end

return M
