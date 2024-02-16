return {
    "echasnovski/mini.surround",
    lazy = false,
    keys = function(plugin, keys)
        -- Populate the keys based on the user's options
        local opts = require("lazy.core.plugin").values(plugin, "opts", false)
        local mappings = {
            { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
            { opts.mappings.delete, desc = "Delete surrounding" },
            { opts.mappings.find, desc = "Find right surrounding" },
            { opts.mappings.find_left, desc = "Find left surrounding" },
            { opts.mappings.replace, desc = "Replace surrounding" },
            { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
        }
        return vim.tbl_deep_extend("keep", mappings, keys)
    end,
    opts = {
        mappings = {
            add = "ma", -- Add surrounding in Normal and Visual modes
            delete = "md", -- Delete surrounding
            find = "mf", -- Find surrounding (to the right)
            find_left = "mF", -- Find surrounding (to the left)
            replace = "mr", -- Replace surrounding
            update_n_lines = "<space>mn", -- Update `n_lines`
        },
    },
    config = function(_, opts)
        -- use gz mappings instead of s to prevent conflict with leap
        require("mini.surround").setup(opts)
        local keymap = vim.keymap.set
        local keymap_ops = { noremap = true, silent = true }
        keymap("v", '"', function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('ma"', true, false, true), "t", true)
        end, keymap_ops)

        keymap("v", "[", function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ma[", true, false, true), "t", true)
        end, keymap_ops)

        keymap("v", "{", function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ma{", true, false, true), "t", true)
        end, keymap_ops)

        keymap("v", "(", function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ma(", true, false, true), "t", true)
        end, keymap_ops)
    end,
}
