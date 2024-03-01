return {
    "tzachar/highlight-undo.nvim",
    lazy = false,
    opts = {
        duration = 500,
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
