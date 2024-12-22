return {
    "gbprod/yanky.nvim",
    -- commit = "0dc8e0f262246ce4a891f0adf61336b3afe7c579",
    lazy = false,
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
                vim.o.eventignore = "CursorMoved"
                vim.defer_fn(function()
                    vim.o.eventignore = ""
                end, 100)
                return "<Plug>(YankyPreviousEntry)"
            end,
            expr = true,
        },
        {
            "<leader>n",
            function()
                local cursor = vim.api.nvim_win_get_cursor(0)[1]
                vim.o.eventignore = "CursorMoved"
                vim.defer_fn(function()
                    vim.o.eventignore = ""
                end, 100)
                return "<Plug>(YankyNextEntry)"
            end,
            expr = true,
        },
        {
            "gp",
            function()
                _G.hide_cursor(function() end)
                vim.g.type_o = true
                vim.schedule(function()
                    vim.g.type_o = false
                    require("mini.indentscope").h.auto_draw()
                end)
                local cursor = vim.api.nvim_win_get_cursor(0)[1]
                vim.schedule(function()
                    local new_cursor = vim.api.nvim_win_get_cursor(0)[1]
                    if new_cursor ~= cursor then
                        FeedKeys("0", "m")
                    end
                end)
                vim.o.eventignore = "CursorMoved"
                vim.defer_fn(function()
                    vim.o.eventignore = ""
                end, 100)
                return "<Plug>(YankyPutAfter)"
            end,
            expr = true,
        },
        {
            "p",
            function()
                _G.hide_cursor(function() end)
                vim.g.type_o = true
                vim.schedule(function()
                    vim.g.type_o = false
                    require("mini.indentscope").h.auto_draw()
                end)
                local cursor = vim.api.nvim_win_get_cursor(0)[1]
                vim.schedule(function()
                    local new_cursor = vim.api.nvim_win_get_cursor(0)[1]
                    if new_cursor ~= cursor then
                        FeedKeys("0", "m")
                    end
                end)
                vim.o.eventignore = "CursorMoved"
                vim.defer_fn(function()
                    vim.o.eventignore = ""
                end, 100)
                return "<Plug>(YankyPutAfter)mt`[v`]=`t"
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
                    require("mini.indentscope").h.auto_draw()
                end)
                local cursor = vim.api.nvim_win_get_cursor(0)[1]
                vim.schedule(function()
                    local new_cursor = vim.api.nvim_win_get_cursor(0)[1]
                    if new_cursor ~= cursor then
                        FeedKeys("0", "m")
                    end
                end)
                vim.o.eventignore = "CursorMoved"
                vim.defer_fn(function()
                    vim.o.eventignore = ""
                end, 100)
                return "<Plug>(YankyPutBefore)"
            end,
            expr = true,
        },
        {
            "<c-p>",
            function()
                require("yanky.textobj").last_put()
            end,
            mode = { "x", "o" },
        },
        {
            "p",
            function()
                vim.g.type_o = true
                vim.schedule(function()
                    vim.g.type_o = false
                    require("mini.indentscope").h.auto_draw()
                end)
                require("yanky").put("p", true, function() end)
                local mode = vim.api.nvim_get_mode().mode
                if mode == "V" then
                    FeedKeys("c<d-v><cmd>stopinsert<CR>==0", "m")
                else
                    FeedKeys("c<d-v><cmd>stopinsert<cr>", "m")
                end
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
