return {
    {
        "echasnovski/mini.clue",
        enabled = false,
        config = function()
            local miniclue = require("mini.clue")
            miniclue.setup({
                triggers = {
                    -- Leader triggers
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },

                    -- Built-in completion
                    { mode = "i", keys = "<C-x>" },

                    -- `g` key
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },

                    -- Marks
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },

                    -- Registers
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },

                    -- Window commands
                    { mode = "n", keys = "<C-w>" },

                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                },

                window = {
                    -- Floating window config
                    config = {},

                    -- Delay before showing clue window
                    delay = 0,

                    -- Keys to scroll inside the clue window
                    scroll_down = "<C-d>",
                    scroll_up = "<C-u>",
                },
            })
        end,
    },
    {
        "echasnovski/mini.surround",
        lazy = false,
        -- enabled = false,
        keys = function(plugin, keys)
            -- Populate the keys based on the user's options
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            local mappings = {
                { opts.mappings.add, desc = "Add surrounding", mode = { "n", "x" } },
                { opts.mappings.delete, desc = "Delete surrounding" },
                { opts.mappings.find, desc = "Find right surrounding" },
                { opts.mappings.find_left, desc = "Find left surrounding" },
                { opts.mappings.replace, desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            return vim.tbl_deep_extend("keep", mappings, keys)
        end,
        opts = {
            custom_surroundings = {
                ["("] = { input = { "%b()", "^.().*().$" }, output = { left = "(", right = ")" } },
                ["["] = { input = { "%b[]", "^.().*().$" }, output = { left = "[", right = "]" } },
                ["{"] = { input = { "%b{}", "^.().*().$" }, output = { left = "{", right = "}" } },
                ["<"] = { input = { "%b<>", "^.().*().$" }, output = { left = "<", right = ">" } },
                ["s"] = { input = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" }, output = { left = "(", right = ")" } },
            },
            mappings = {
                add = "ma",
                delete = "md",
                find = "mf",
                find_left = "mF",
                highlight = "mh",
                replace = "mr",
                update_n_lines = "mN",
            },
        },
        config = function(_, opts)
            require("mini.surround").setup(opts)
            local keymap = vim.keymap.set
            local keymap_ops = { remap = true, silent = true }
            keymap("x", '"', 'ma"', keymap_ops)
            keymap("x", "'", "ma'", keymap_ops)
            keymap("x", "[[", "ma[", keymap_ops)
            keymap("x", "{", "ma{", keymap_ops)
            keymap("x", "(", "ma(", keymap_ops)
            keymap("x", "`", "ma`", keymap_ops)
        end,
    },
}
