return {
    "fedepujol/move.nvim",
    event = "VeryLazy",
    keys = {
        { "<down>", "<cmd>MoveLine(1)<CR>", desc = "move line down" },
        { "<up>", "<cmd>MoveLine(-1)<CR>", desc = "move line up" },
        { "<left>", "<cmd>MoveHChar(-1)<CR>", desc = "move char left" },
        { "<right>", "<cmd>MoveHChar(1)<CR>", desc = "move char right" },
    },
    opts = {
        line = {
            enable = true, -- Enables line movement
            indent = true, -- Toggles indentation
        },
        block = {
            enable = true, -- Enables block movement
            indent = true, -- Toggles indentation
        },
        word = {
            enable = true, -- Enables word movement
        },
        char = {
            enable = true, -- Enables char movement
        },
    },
}
