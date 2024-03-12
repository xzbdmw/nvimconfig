return {
    "mrjones2014/legendary.nvim",
    -- since legendary.nvim handles all your keymaps/commands,
    --   -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    -- enabled = false,
    lazy = false,
    -- sqlite is only needed if you want to use frecency sorting
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
        {
            "<C-p>",
            function()
                vim.cmd("Legendary functions")
            end,
        },
        {
            "<C-CR>",
            function()
                vim.cmd("LegendaryRepeat")
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
                        vim.cmd("Gitsigns preview_hunk_inline")
                    end,
                    description = "hunk inline",
                },
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
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("jjj", true, false, true), "n", true)
                        end)
                    end,
                    description = "variable",
                },
                {
                    function()
                        local gs = package.loaded.gitsigns
                        gs.next_hunk()
                    end,
                    description = "next chunk",
                },
                {
                    function()
                        local gs = package.loaded.gitsigns
                        gs.prev_hunk()
                    end,
                    description = "prev chunk",
                },
                {
                    function()
                        vim.cmd("messages")
                        vim.defer_fn(function()
                            local win_height = vim.api.nvim_win_get_height(0)
                            local screen_height = vim.api.nvim_get_option("lines")
                            if win_height + 1 < screen_height then
                                FeedKeys("<C-w>L", "t")
                            end
                        end, 30)
                    end,
                    description = "show messages",
                },
                {
                    function()
                        vim.cmd("messages clear")
                    end,
                    description = "messages clear",
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
