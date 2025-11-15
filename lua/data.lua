local M = {}

local data_path = ("%s/tesser"):format(vim.fn.stdpath("data"))
if vim.fn.isdirectory(data_path) == 0 then
    vim.fn.mkdir(data_path)
end

local function project_filepath(name)
    return ("%s/%s.json"):format(data_path, vim.fn.sha256(name))
end

M.projects = {}

function M.load_project(name)
    if not M.projects[name] then
        local _, project_json = pcall(vim.fn.readblob, project_filepath(name))
        local ok, project = pcall(vim.json.decode, project_json)
        M.projects[name] = ok and project or {}
    end

    return M.projects[name]
end

function M.save_project(name)
    local data_file = assert(io.open(project_filepath(name), "w"))
    data_file:write(vim.json.encode(M.projects[name]))
    data_file:close()
end

function M.delete_project(name)
    local suc, e = os.remove(project_filepath(name))
    print(suc, e)
    M.projects[name] = nil
end

return M
