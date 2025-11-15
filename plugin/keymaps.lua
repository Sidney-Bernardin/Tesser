local tesser = require("tesser")

local lowercase = "abcdefghijkclmnopqrstuvwxyz1234567890,.;/"
local uppercase = "ABCDEFGHIJKCLMNOPQRSTUVWXYZ!@#$%^&*()<>:?"
for i = 1, #lowercase do
    local lower = lowercase:sub(i, i)
    local upper = uppercase:sub(i, i)

    -- Open file.
    vim.keymap.set("n", ("<M-%s>"):format(lower), function()
        tesser.open(lower)
    end, { noremap = true })

    -- Set file.
    vim.keymap.set("n", ("<M-%s>"):format(upper), function()
        tesser.set(lower)
    end, { noremap = true })
end
