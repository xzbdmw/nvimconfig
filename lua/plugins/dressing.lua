return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    -- enabled = false,
    opts = {
        input = {
            -- Set to false to disable the vim.ui.input implementation
            enabled = true,

            -- Default prompt string
            default_prompt = "Input",

            -- Trim trailing `:` from prompt
            trim_prompt = true,

            -- Can be 'left', 'right', or 'center'
            title_pos = "left",

            -- When true, <Esc> will close the modal
            insert_only = false,

            -- When true, input will start in insert mode.
            start_in_insert = true,

            -- These are passed to nvim_open_win
            border = "rounded",
            -- 'editor' and 'win' will default to being centered
            relative = "cursor",

            -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            prefer_width = 60,
            width = nil,
            -- min_width and max_width can be a list of mixed types.
            -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
            max_width = { 140, 0.9 },
            min_width = { 30, 0.2 },
            zindex = 21,
            buf_options = {},
            win_options = {
                -- Disable line wrapping
                wrap = true,
                -- Indicator for when text exceeds window
                list = true,
                listchars = "precedes:…,extends:…",
                -- Increase this for more context when text scrolls off the window
                sidescrolloff = 0,
            },

            -- Set to `false` to disable
            mappings = {
                n = {
                    ["<Esc>"] = "Close",
                    ["<CR>"] = "Confirm",
                },
                i = {
                    ["<C-c>"] = "Close",
                    ["<CR>"] = "Confirm",
                    ["<Up>"] = "HistoryPrev",
                    ["<Down>"] = "HistoryNext",
                },
            },

            override = function(conf)
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                return conf
            end,

            -- see :help dressing_get_config
            get_config = nil,
        },
        select = {
            -- Set to false to disable the vim.ui.select implementation
            enabled = true,

            -- Priority list of preferred vim.select implementations
            backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

            -- Trim trailing `:` from prompt
            trim_prompt = true,

            -- Options for telescope selector
            -- These are passed into the telescope picker directly. Can be used like:
            -- telescope = require('telescope.themes').get_ivy({...})
            telescope = {
                borderchars = { " ", " ", "", " ", " ", " ", " ", " " },
                initial_mode = "insert",
                layout_config = {
                    width = 0.35,
                    height = 0.7,
                    prompt_position = "top",
                },
            },
        },
    },
}
