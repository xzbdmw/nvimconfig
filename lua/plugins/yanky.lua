return {
    "gbprod/yanky.nvim",
    keys = {
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },

        { "<space>p", "<Plug>(YankyPreviousEntry)" },
        { "<space>n", "<Plug>(YankyNextEntry)" },

        { "p", "<Plug>(YankyPutAfter)" },
        { "P", "<Plug>(YankyPutBefore)" },

        { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
        { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },

        -- visual mode paste
        { "p", "<Plug>(YankyPutBefore)", { desc = "Paste without copying replaced text" }, mode = { "x" } },
        { "<D-c>", "<Plug>(YankyYank)", mode = { "n", "v", "i" } },

        -- force paste the same line
        { "<leader>P", "<Plug>(YankyPutAfterCharwiseJoined)", mode = { "n", "x" } },

        -- text object
        {
            "[p",
            function()
                require("yanky.textobj").last_put()
            end,
            mode = { "x", "o" },
        },
    },
    lazy = false,
    opts = {
        ring = {
            history_length = 10,
            storage = "shada",
            storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
            sync_with_numbered_registers = true,
            cancel_event = "update",
            ignore_registers = { "_" },
            update_register_on_cycle = false,
        },
        picker = {
            select = {
                action = nil, -- nil to use default put action
            },
            telescope = {
                use_default_mappings = true, -- if default mappings should be used
                mappings = nil, -- nil to use default mappings or no mappings (see `use_default_mappings`)
            },
        },
        system_clipboard = {
            sync_with_ring = true,
        },
        highlight = {
            on_put = true,
            on_yank = true,
            timer = 400,
        },
        preserve_cursor_position = {
            enabled = true,
        },
        textobj = {
            enabled = true,
        },
    },
}
