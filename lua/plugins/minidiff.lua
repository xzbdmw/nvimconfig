return {
    "echasnovski/mini.diff",
    version = false,
    enabled = false,
    -- No need to copy this inside `setup()`. Will be used automatically.
    opts = {
        -- Options for how hunks are visualized
        view = {
            -- Visualization style. Possible values are 'sign' and 'number'.
            -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
            -- style = vim.go.number and "number" or "sign",
            style = "sign",

            -- Signs used for hunks with 'sign' view
            signs = { add = "│", change = "│", delete = "_" },

            -- Priority of used visualization extmarks
            priority = vim.highlight.priorities.user - 1,
        },

        -- Source for how reference text is computed/updated/etc
        -- Uses content from Git index by default
        source = nil,

        -- Delays (in ms) defining asynchronous processes
        delay = {
            -- How much to wait before update following every text change
            text_change = 100,
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            -- Apply hunks inside a visual/operator region
            apply = "<leader>H",

            -- Reset hunks inside a visual/operator region
            reset = "<leader>h",

            -- Hunk range textobject to be used inside operator
            textobject = "<leader>h",

            -- Go to hunk range in corresponding direction
            goto_first = "[C",
            goto_prev = "[c",
            goto_next = "]c",
            goto_last = "]C",
        },

        -- Various options
        options = {
            -- Diff algorithm. See `:h vim.diff()`.
            algorithm = "histogram",

            -- Whether to use "indent heuristic". See `:h vim.diff()`.
            indent_heuristic = true,

            -- The amount of second-stage diff to align lines (in Neovim>=0.9)
            linematch = 60,

            -- Whether to wrap around edges during hunk navigation
            wrap_goto = true,
        },
    },
    config = function(_, opts)
        local diff = require("mini.diff")
        diff.setup(opts)
        vim.keymap.set("n", "<leader>ud", function()
            _G.minidiff = true
            diff.toggle_overlay()
        end)
        vim.keymap.set("n", "<leader>hh", "<leader>h<leader>h", { remap = true })
    end,
}
