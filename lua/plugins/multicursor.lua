return {
    "smoka7/multicursors.nvim",
    dependencies = {
        "smoka7/hydra.nvim",
    },
    enabled = false,
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    config = function()
        local extend = require("multicursors.extend_mode")
        local insert = require("multicursors.insert_mode")
        local normal = require("multicursors.normal_mode")
        require("multicursors").setup({
            updatetime = 0, -- selections get updated if this many milliseconds nothing is typed in the insert mode see :help updatetime
            normal_keys = {
                -- use extend motions in normal mode
                ["w"] = { method = extend.w_method, opts = { desc = "next word start" } },
                ["d"] = { method = normal.delete, opts = { nowait = true, desc = "next word start" } },
                ["p"] = { method = normal.replace, opts = { nowait = true, desc = "next word start" } },
                ["P"] = { method = normal.paste_after, opts = { nowait = true, desc = "next word start" } },
                ["b"] = { method = extend.b_method, opts = { desc = "backward word" } },
                ["l"] = { method = extend.l_method, opts = { desc = "right" } },
                ["h"] = { method = extend.h_method, opts = { desc = "left" } },
                ["o"] = { method = extend.o_method, opts = { desc = "change direction" } },
                ["u"] = { method = extend.undo_history, opts = { desc = "undo history" } },
                ["gu"] = { method = normal.lower_case, opts = { desc = "undo history" } },
                ["gU"] = { method = normal.upper_case, opts = { desc = "undo history" } },
                ["0"] = { method = extend.caret_method, opts = { desc = "line start" } },
                ["L"] = { method = extend.dollar_method, opts = { desc = "line end" } },
                ["A"] = { method = extend.A_method, opts = { desc = "line start" } },
                ["I"] = { method = extend.I_method, opts = { desc = "line end" } },
                ["<CR>"] = { method = extend.node_parent, opts = { desc = "parent node" } },
                ["<C-d>"] = { method = extend.node_first_child, opts = { desc = "parent node" } },
            },
            insert_keys = {
                ["<C-d>"] = { method = insert.C_w_method, opts = { desc = "parent node" } },
            },
            generate_hints = {
                normal = false,
                insert = false,
                extend = false,
                config = {
                    -- determines how many columns are used to display the hints. If you leave this option nil, the number of columns will depend on the size of your window.
                    column_count = nil,
                    -- maximum width of a column.
                    max_hint_length = 25,
                },
            },
        })
    end,
}
