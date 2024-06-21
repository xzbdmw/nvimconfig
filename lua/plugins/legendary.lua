return {
    "mrjones2014/legendary.nvim",
    enabled = false,
    -- since legendary.nvim handles all your keymaps/commands,
    --   -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    -- enabled = false,
    lazy = false,
    -- sqlite is only needed if you want to use frecency sorting
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
        {
            "<C-;>",
            function()
                vim.cmd("Legendary functions")
            end,
        },
    },
    config = function()
        require("legendary").setup({
            keymaps = {},
            commands = {},
            funcs = {
                {
                    function()
                        vim.g.neovide_underline_stroke_scale = 0
                        vim.cmd("DiffviewOpen")
                    end,
                    description = "diffview open",
                },
                {
                    function()
                        vim.g.neovide_underline_stroke_scale = 2
                        vim.cmd("DiffviewClose")
                    end,
                    description = "diffview close",
                },
                {
                    function()
                        vim.g.neovide_underline_stroke_scale = 0
                        vim.cmd("DiffviewFileHistory %")
                    end,
                    description = "diffview file",
                },
                {
                    function()
                        require("refactoring").debug.print_var()
                        vim.schedule(function()
                            FeedKeys("jjj", "n")
                        end)
                    end,
                    description = "variable",
                },
                {
                    function()
                        vim.cmd.RustLsp("runnables")
                    end,
                    description = "runnables",
                },
                {
                    function()
                        vim.cmd.RustLsp("testables")
                    end,
                    description = "testables",
                },
                {
                    function()
                        vim.cmd.RustLsp({ "runnables", bang = true })
                    end,
                    description = "resume rust runnables",
                },
                {
                    function()
                        vim.cmd.RustLsp({ "testables", bang = true })
                    end,
                    description = "resume rust testables",
                },
            },
            -- load extensions
            extensions = {
                -- load keymaps and commands from nvim-tree.lua
                nvim_tree = false,
                -- load commands from smart-splits.nvim
                -- and create keymaps, see :h legendary-extensions-smart-splits.nvim
                smart_splits = false,
                -- load commands from op.nvim
                op_nvim = false,
                -- load keymaps from diffview.nvim
                diffview = false,
            },
        })
    end,
    --
}
