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
                pcall(function()
                    vim.cmd("Noice disable")
                end)
                api.nvim_create_autocmd("CmdlineLeave", {
                    once = true,
                    callback = function()
                        vim.schedule(function()
                            pcall(function()
                                vim.cmd("Noice enable")
                            end)
                        end)
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
                pcall(function()
                    vim.cmd("Noice disable")
                end)
                api.nvim_create_autocmd("CmdlineLeave", {
                    once = true,
                    callback = function()
                        vim.schedule(function()
                            pcall(function()
                                vim.cmd("Noice enable")
                            end)
                        end)
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
                pcall(function()
                    vim.cmd("Noice disable")
                end)
                api.nvim_create_autocmd("CmdlineLeave", {
                    once = true,
                    callback = function()
                        vim.schedule(function()
                            pcall(function()
                                vim.cmd("Noice enable")
                            end)
                        end)
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
            "<leader>cp",
            function()
                require("refactoring").debug.cleanup({})
            end,
        },
    },

    config = function()
        require("refactoring").setup({})
    end,
}
