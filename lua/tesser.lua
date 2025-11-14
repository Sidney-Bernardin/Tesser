local M = {}

--

---@type table<string, string>
local project = {}

-- Initialize tesser directory.
local data_path = ("%s/tesser"):format(vim.fn.stdpath("data"))
if vim.fn.isdirectory(data_path) == 0 then
    vim.fn.mkdir(data_path)
end

-- Set keymaps for each key.
local lowercase = "abcdefghijkclmnopqrstuvwxyz,.;/"
local uppercase = "ABCDEFGHIJKCLMNOPQRSTUVWXYZ<>:?"
for i = 1, #lowercase do
    local lower = lowercase:sub(i, i)
    local upper = uppercase:sub(i, i)

    -- Open file.
    vim.keymap.set("n", ("<M-%s>"):format(lower), function()
        M.open(upper)
    end, { noremap = true })

    -- Set file.
    vim.keymap.set("n", ("<M-%s>"):format(upper), function()
        M.set(upper)
    end, { noremap = true })
end

---Returns the current project's filepath.
---@return string
local function project_filepath()
    return ("%s/%s.json"):format(data_path, vim.fn.sha256(vim.fn.getcwd()))
end

local function load_project()
    local ok, project_blob = pcall(vim.fn.readblob, project_filepath())
    if not ok then return end
    project = vim.json.decode(project_blob) or {}
end

function M.setup()
end

---Open the key's file.
---@param key string
function M.open(key)
    load_project()

    if not project[key] then
        vim.notify(("Tesser: %s hasn't been set"):format(key), vim.log.levels.ERROR)
        return
    end

    vim.cmd(("e %s"):format(project[key]))
end

---Set the key to the current file.
---@param key string
function M.set(key)
    load_project()

    project = project or {}
    project[key] = vim.fn.expand("%:.")

    local project_file = assert(io.open(project_filepath(), "w"))
    project_file:write(vim.json.encode(project))
    project_file:close()

    vim.notify(("Tesser: [%s] = %s"):format(key, project[key]), vim.log.levels.INFO)
end

--

return M
