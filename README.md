# Tesser

## Config
```lua
{
    "Sidney-Bernardin/tesser.nvim",
    -- dir = "~/projects/neovim_plugins/tesser.nvim",
    config = function()
        local tesser = require("tesser")

        tesser.setup({ -- All defaults.
            keys = { -- Order determines what the editor window will look like. 
                "1234567890",
                "qwertyuiop",
                "asdfghjkl;",
                "zxcvbnm,./",
            },
        })

        -- Open editor window.
        vim.keymap.set("n", "<leader>t", tesser.edit)

        for key in tesser.keys() do

            -- Open file from key.
            vim.keymap.set("n",
                ("<M-%s>"):format(key),
                function() tesser.open(key) end,
                { noremap = true }
            )

            -- Set file to key.
            vim.keymap.set("n",
                ("<leader><leader>%s"):format(key),
                function() tesser.set(key) end
            )
        end
    end,
}
```
