return {
    -- "xzbdmw/nvim-treesitter-context",
    dir = "~/Project/lua/nvim-treesitter-context/",
    lazy = false,
    -- enabled = false,
    -- commit = "a5d16fd7639da37009e7c43eea4a932ccece2162",
    keys = {
        {
            "gs",
            function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end,
            desc = "go to sticky scroll",
        },
        {
            "<leader>uc",
            "<cmd>TSContextToggle<CR>",
        },
    },
    opts = {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = -1, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 100, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
}
