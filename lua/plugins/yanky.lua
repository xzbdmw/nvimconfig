return {
    "gbprod/yanky.nvim",
    -- commit = "0dc8e0f262246ce4a891f0adf61336b3afe7c579",
    keys = function()
        local function put(position)
            vim.g.type_o = true
            vim.schedule(function()
                vim.g.type_o = false
                require("mini.indentscope").h.auto_draw()
            end)
            return "<Plug>(YankyPut" .. position .. ")"
        end
        return {
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
                    return "<Plug>(YankyPreviousEntry)"
                end,
                expr = true,
            },
            {
                "<leader>n",
                function()
                    return "<Plug>(YankyNextEntry)"
                end,
                expr = true,
            },
            {
                "p",
                function()
                    SS = vim.uv.hrtime()
                    return put("After")
                end,
                expr = true,
            },
            {
                "P",
                function()
                    return put("Before")
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
                    require("substitute").visual()
                end,
                { desc = "Paste without copying replaced text" },
                mode = { "x" },
            },

            -- force paste the same line
            {
                "<leader>P",
                function()
                    return "<Plug>(YankyPutAfterCharwiseJoined)"
                end,
                mode = { "n", "x" },
                expr = true,
            },
        }
    end,
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
            timer = 180,
        },
        preserve_cursor_position = {
            enabled = true,
        },
        textobj = {
            enabled = true,
        },
    },
}
