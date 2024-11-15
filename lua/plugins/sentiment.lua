return {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    enabled = false,
    opts = {
        -- config
    },
    init = function()
        -- `matchparen.vim` needs to be disabled manually in case of lazy loading
    end,
    config = function()
        require("sentiment").setup({
            ---Dictionary to check whether a buftype should be included.
            ---
            ---@type table<string, boolean>
            included_buftypes = {
                [""] = true,
            },

            ---Dictionary to check whether a filetype should be excluded.
            ---
            ---@type table<string, boolean>
            excluded_filetypes = {},

            ---Dictionary to check whether a mode should be included.
            ---
            ---@type table<string, boolean>
            included_modes = {
                n = true,
                v = true,
                i = true,
            },

            ---How much (in milliseconds) should the cursor stay still to calculate and
            ---render a pair.
            ---
            ---NOTE: It's recommended to set this somewhere above and close to your key
            ---repeat speed in order to keep the calculations at minimum.
            ---
            ---@type integer
            delay = 1,

            ---How many lines to look backwards/forwards to find a pair.
            ---
            ---@type integer
            limit = 100,

            ---List of `(left, right)` pairs.
            ---
            ---NOTE: Both sides of a pair can't have the same character.
            ---
            pairs = {
                { "(", ")" },
                -- { "<", ">" },
                { "{", "}" },
                -- { "[", "]" },
            },
        })
    end,
}
