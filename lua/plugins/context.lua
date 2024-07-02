return {
    -- "nvim-treesitter/nvim-treesitter-context",
    dir = "~/Project/lua/nvim-treesitter-context/",
    -- dir = "~/Project/lua/nvim-treesitter-context/",
    lazy = false,
    -- enabled = false,
    event = "VeryLazy",
    -- commit = "a5d16fd7639da37009e7c43eea4a932ccece2162",
    -- commit = "b8b7e52c1517d401d7c519787d5dc4528c41291a",
    keys = {
        -- {
        --     "gsa",
        --     function()
        --         require("treesitter-context").go_to_context(0)
        --     end,
        --     desc = "go to sticky scroll",
        -- },
        {
            "gs",
            function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end,
            desc = "go to sticky scroll",
        },
        -- {
        --     "gsd",
        --     function()
        --         require("treesitter-context").go_to_context(1)
        --     end,
        --     desc = "go to sticky scroll",
        -- },
    },
    opts = {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 2, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 100, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 31, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
}
