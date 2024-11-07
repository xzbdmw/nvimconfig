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

        {
            "<leader>p",
            function()
                local keymaps = vim.api.nvim_get_keymap("n")
                for _, keymap in ipairs(keymaps) do
                    if keymap.lhs == " na" then
                        vim.keymap.del("n", " na")
                        break
                    end
                end
                return "<Plug>(YankyPreviousEntry)`[v`]="
            end,
            expr = true,
        },
        { "<leader>n", "<Plug>(YankyNextEntry)`[v`]=" },
        {
            "p",
            function()
                _G.hide_cursor(function() end)
                vim.g.type_o = true
                vim.schedule(function()
                    vim.g.type_o = false
                end)
                return "<Plug>(YankyPutAfter)`[v`]="
            end,
            expr = true,
        },
        {
            "P",
            function()
                _G.hide_cursor(function() end)
                vim.g.hlchunk_disable = true
                vim.g.type_o = true
                vim.schedule(function()
                    vim.g.type_o = false
                end)
                return "<Plug>(YankyPutBefore)`[v`]="
            end,
            expr = true,
        },
        {
            "p",
            function()
                vim.g.type_o = true
                vim.schedule(function()
                    vim.g.type_o = false
                end)
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
            timer = 130,
        },
        preserve_cursor_position = {
            enabled = true,
        },
        textobj = {
            enabled = true,
        },
    },
}
