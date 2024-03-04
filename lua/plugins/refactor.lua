return {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup({ -- prompt for return type
            -- prompt_func_return_type = {
            --     go = true,
            --     cpp = true,
            --     c = true,
            --     java = true,
            -- },
            -- -- prompt for function parameters
            -- prompt_func_param_type = {
            --     go = true,
            --     cpp = true,
            --     c = true,
            --     java = true,
            -- },
        })
        vim.keymap.set("x", "<leader>rf", ":Refactor extract ")
        -- vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")

        vim.keymap.set("x", "<leader>re", ":Refactor extract_var ")

        vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

        vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

        vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
        vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
        -- You can also use below = true here to to change the position of the printf
        -- statement (or set two remaps for either one). This remap must be made in normal mode.
        vim.keymap.set("n", "<leader>rp", function()
            require("refactoring").debug.printf({ below = false })
        end)

        -- Print var

        vim.keymap.set({ "x", "n" }, "<leader>rv", function()
            require("refactoring").debug.print_var()
        end)
        -- Supports both visual and normal mode

        vim.keymap.set("n", "<leader>rc", function()
            require("refactoring").debug.cleanup({})
        end)
        -- Supports only normal mode
    end,
}
