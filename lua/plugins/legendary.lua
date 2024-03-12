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
            "<C-;>",
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
            keymaps = {
                --[[ map keys to a command
                { "<leader>ff", ":Telescope find_files", description = "Find files" },
                -- map keys to a function
                {
                    "<leader>vp",
                    function()
                        require("refactoring").debug.print_var()
                        -- vim.schedule(function()
                        --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("jjj", true, false, true), "n", true)
                        -- end)
                    end,
                    description = "print_var",
                },
                -- Set options used during keymap creation
                { "<leader>s", ":SomeCommand<CR>", description = "Non-silent keymap", opts = { silent = true } },
                -- create keymaps with different implementations per-mode
                {
                    "<leader>c",
                    { n = ":LinewiseCommentToggle<CR>", x = ":'<,'>BlockwiseCommentToggle<CR>" },
                    description = "Toggle comment",
                },
                -- create item groups to create sub-menus in the finder
                -- note that only keymaps, commands, and functions
                -- can be added to item groups
                {
                    -- groups with same itemgroup will be merged
                    itemgroup = "short ID",
                    description = "A submenu of items...",
                    icon = "",
                    keymaps = {
                        -- more keymaps here
                    },
                },
                -- in-place filters, see :h legendary-tables or ./doc/table_structures/README.md
                { "<leader>m", description = "Preview markdown", filters = { ft = "markdown" } }, ]]
            },
            commands = {
                -- easily create user commands
                -- {
                --     ":SayHello",
                --     function()
                --         print("hello world!")
                --     end,
                --     description = "Say hello as a command",
                -- },
                -- {
                --     -- groups with same itemgroup will be merged
                --     itemgroup = "short ID",
                --     -- don't need to copy the other group data because
                --     -- it will be merged with the one from the keymaps table
                --     commands = {
                --         -- more commands here
                --     },
                -- },
                -- -- in-place filters, see :h legendary-tables or ./doc/table_structures/README.md
                -- { ":Glow", description = "Preview markdown", filters = { ft = "markdown" } },
            },
            funcs = {
                {
                    function()
                        vim.cmd("Gitsigns preview_hunk_inline")
                    end,
                    description = "hunk_inline",
                },
                {
                    function()
                        vim.g.neovide_underline_stroke_scale = 0
                        vim.cmd("DiffviewOpen")
                    end,
                    description = "DiffviewOpen",
                },
                {
                    function()
                        vim.g.neovide_underline_stroke_scale = 2
                        vim.cmd("DiffviewClose")
                    end,
                    description = "DiffviewClose",
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
                -- Make arbitrary Lua functions that can be executed via the item finder
                -- {
                --     function()
                --         doSomeStuff()
                --     end,
                --     description = "Do some stuff with a Lua function!",
                -- },
                -- {
                --     -- groups with same itemgroup will be merged
                --     itemgroup = "short ID",
                --     -- don't need to copy the other group data because
                --     -- it will be merged with the one from the keymaps table
                --     funcs = {
                --         -- more funcs here
                --     },
                -- },
            },
            autocmds = {
                -- Create autocmds and augroups
                -- { "BufWritePre", vim.lsp.buf.format, description = "Format on save" },
                -- {
                --     name = "MyAugroup",
                --     clear = true,
                --     -- autocmds here
                -- },
            },
            -- load extensions
            extensions = {
                -- load keymaps and commands from nvim-tree.lua
                nvim_tree = true,
                -- load commands from smart-splits.nvim
                -- and create keymaps, see :h legendary-extensions-smart-splits.nvim
                smart_splits = {
                    directions = { "h", "j", "k", "l" },
                    mods = {
                        move = "<C>",
                        resize = "<M>",
                    },
                },
                -- load commands from op.nvim
                op_nvim = true,
                -- load keymaps from diffview.nvim
                diffview = true,
            },
        })
    end,
    --
}
