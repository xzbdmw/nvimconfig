return {
    "ThePrimeagen/refactoring.nvim",
    -- enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        {
            "<leader>rf",
            function()
                vim.cmd("Noice disable")
                vim.api.nvim_create_autocmd("CmdlineLeave", {
                    once = true,
                    callback = function()
                        vim.cmd("Noice enable")
                    end,
                })
                return ":Refactor extract "
            end,
            mode = { "x", "n" },
            expr = true,
        },
        {
            "<leader>ri",
            function()
                vim.cmd("Noice disable")
                vim.api.nvim_create_autocmd("CmdlineLeave", {
                    once = true,
                    callback = function()
                        vim.cmd("Noice enable")
                    end,
                })
                return ":Refactor inline_var"
            end,
            mode = { "x", "n" },
            expr = true,
        },
        {
            "<leader>re",
            function()
                vim.cmd("Noice disable")
                vim.api.nvim_create_autocmd("CmdlineLeave", {
                    once = true,
                    callback = function()
                        vim.cmd("Noice enable")
                    end,
                })
                return ":Refactor extract_var "
            end,
            expr = true,
            mode = { "x", "n" },
        },
        {
            "<leader>rp",
            function()
                require("refactoring").debug.printf({ below = false })
            end,
        },
        {
            "<leader>vp",
            function()
                require("refactoring").debug.print_var()
            end,
            mode = { "x", "n" },
        },
        {
            "<leader>cc",
            function()
                require("refactoring").debug.cleanup({})
            end,
        },
    },

    config = function()
        require("refactoring").setup({ -- prompt for return type
        })
        -- vim.keymap.set("x", "<leader>rf", ":Refactor extract ")
        -- -- vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
        --
        -- vim.keymap.set("x", "<leader>re", ":Refactor extract_var ")
        --
        -- vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
        --
        -- vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
        --
        -- vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
        -- vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
        -- -- You can also use below = true here to to change the position of the printf
        -- -- statement (or set two remaps for either one). This remap must be made in normal mode.
        -- vim.keymap.set("n", "<leader>rp", function()
        --     require("refactoring").debug.printf({ below = false })
        -- end)
        --
        -- -- Print var
        --
        -- vim.keymap.set({ "x", "n" }, "<leader>vp", function()
        --     require("refactoring").debug.print_var()
        --     -- vim.schedule(function()
        --     --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("jjj", true, false, true), "n", true)
        --     -- end)
        -- end)
        -- -- Supports both visual and normal mode
        --
        -- vim.keymap.set("n", "<leader>cc", function()
        --     require("refactoring").debug.cleanup({})
        -- end)
        -- Supports only normal mode
    end,
}
