return {
    "gbprod/yanky.nvim",
    -- commit = "0dc8e0f262246ce4a891f0adf61336b3afe7c579",
    -- enabled = false,
    keys = {
        {
            "y",
            "<Plug>(YankyYank)",
            mode = { "n", "x" },
        },

        { "<leader>p", "<Plug>(YankyPreviousEntry)" },
        { "<leader>n", "<Plug>(YankyNextEntry)" },
        {
            "p",
            function()
                YANK = vim.uv.hrtime()
                return "<Plug>(YankyPutAfter)"
            end,
            expr = true,
        },
        { "P", "<Plug>(YankyPutBefore)" },

        -- { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
        -- { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },

        -- visual mode paste
        {
            "p",
            function()
                require("yanky").put("p", true, function() end)
                FeedKeys("c<d-v><esc>", "m")
            end,
            { desc = "Paste without copying replaced text" },
            mode = { "x" },
        },
        { "<D-c>", "<Plug>(YankyYank)", mode = { "n", "v", "i" } },

        -- force paste the same line
        {
            "<leader>P",
            function()
                YANK = vim.uv.hrtime()
                return "<Plug>(YankyPutAfterCharwiseJoined)"
            end,
            mode = { "n", "x" },
            expr = true,
        },
    },
    lazy = false,
    opts = {
        ring = {
            history_length = 10,
            storage = "shada",
            storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
            sync_with_numbered_registers = true,
            cancel_event = "move",
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
