return {
    "tzachar/highlight-undo.nvim",
    lazy = false,
    enabled = false,
    opts = {
        duration = 200,
        undo = {
            hlgroup = "YankyPut",
            mode = "n",
            lhs = "u",
            map = "undo",
            opts = {},
        },
        redo = {
            hlgroup = "YankyPut",
            mode = "n",
            lhs = "<C-r>",
            map = "redo",
            opts = {},
        },
        highlight_for_count = true,
    },
}
