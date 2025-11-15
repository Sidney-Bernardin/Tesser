vim.api.nvim_create_user_command("TesserClear", function()
    require("tesser").clear()
end, { nargs = "*" })
