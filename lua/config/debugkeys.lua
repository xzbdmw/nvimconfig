vim.keymap.set("n", "<d-y>", function()
    vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "<right>", {})
end)
local dd = vim.api.nvim_del_keymap
vim.api.nvim_del_keymap = function(mode, lhs)
    if lhs == "<Tab>" and (mode == "x" or mode == "v") then
        print(debug.traceback())
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function lhs:]==], vim.inspect(lhs)) -- __AUTO_GENERATED_PRINT_VAR_END__
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function mode:]==], vim.inspect(mode)) -- __AUTO_GENERATED_PRINT_VAR_END__
    end
    dd(mode, lhs)
end
local bid = vim.api.nvim_buf_del_keymap
vim.api.nvim_buf_del_keymap = function(buffer, mode, lhs)
    if lhs == "<Tab>" and (mode == "x" or mode == "v") then
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function buffer:]==], vim.inspect(buffer)) -- __AUTO_GENERATED_PRINT_VAR_END__
        print(debug.traceback())
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function lhs:]==], vim.inspect(lhs)) -- __AUTO_GENERATED_PRINT_VAR_END__
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function mode:]==], vim.inspect(mode)) -- __AUTO_GENERATED_PRINT_VAR_END__
    end
    bid(buffer, mode, lhs)
end
local origin = vim.api.nvim_buf_set_keymap
vim.api.nvim_buf_set_keymap = function(buffer, mode, lhs, rhs, opts)
    if lhs == "<Tab>" and (mode == "x" or mode == "v") then
        local trace = debug.traceback()
        if trace:find("telescope") == nil and trace:find("rust%.lua") == nil then
            print(debug.traceback())
            -- __AUTO_GENERATED_PRINT_VAR_START__
            print([==[function opts:]==], vim.inspect(opts)) -- __AUTO_GENERATED_PRINT_VAR_END__
            -- __AUTO_GENERATED_PRINT_VAR_START__
            print([==[function rhs:]==], vim.inspect(rhs)) -- __AUTO_GENERATED_PRINT_VAR_END__
            -- __AUTO_GENERATED_PRINT_VAR_START__
            print([==[function lhs:]==], vim.inspect(lhs)) -- __AUTO_GENERATED_PRINT_VAR_END__
            -- __AUTO_GENERATED_PRINT_VAR_START__
            print([==[function mode:]==], vim.inspect(mode)) -- __AUTO_GENERATED_PRINT_VAR_END__
            -- __AUTO_GENERATED_PRINT_VAR_START__
            print([==[function buffer:]==], vim.inspect(buffer)) -- __AUTO_GENERATED_PRINT_VAR_END__
        end
    end
    origin(buffer, mode, lhs, rhs, opts)
end
local originf = vim.api.nvim_set_keymap
vim.api.nvim_set_keymap = function(mode, lhs, rhs, opts)
    if lhs == "<Tab>" and (mode == "x" or mode == "v") then
        print(debug.traceback())
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function opts:]==], vim.inspect(opts)) -- __AUTO_GENERATED_PRINT_VAR_END__
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function rhs:]==], vim.inspect(rhs)) -- __AUTO_GENERATED_PRINT_VAR_END__
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function lhs:]==], vim.inspect(lhs)) -- __AUTO_GENERATED_PRINT_VAR_END__
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function mode:]==], vim.inspect(mode)) -- __AUTO_GENERATED_PRINT_VAR_END__
    end
    originf(mode, lhs, rhs, opts)
end
