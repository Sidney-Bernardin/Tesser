vim.api.nvim_create_user_command("TesserSet", function(args)
    require("tesser").set(args.fargs[1])
end, { nargs = 1 })

vim.api.nvim_create_user_command("TesserOpen", function(args)
    require("tesser").open(args.fargs[1])
end, { nargs = 1 })

vim.api.nvim_create_user_command("TesserClear", function(args)
    require("tesser").clear(args.fargs[1])
end, { nargs = 1 })

vim.api.nvim_create_user_command("TesserClearAll", function()
    require("tesser").clear_all()
end, {})

vim.api.nvim_create_user_command("TesserEdit", function()
    require("tesser").edit()
end, {})
