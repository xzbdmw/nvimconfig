return {
    "projekt0n/github-nvim-theme",
    enabled = false,
    config = function()
        -- Default options
        require("github-theme").setup({
            options = {
                -- Compiled file's destination location
                compile_path = vim.fn.stdpath("cache") .. "/github-theme",
                compile_file_suffix = "_compiled", -- Compiled file suffix
                hide_end_of_buffer = true, -- Hide the '~' character at the end of the buffer for a cleaner look
                hide_nc_statusline = true, -- Override the underline style for non-active statuslines
                transparent = false, -- Disable setting background
                terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
                dim_inactive = false, -- Non focused panes set to alternative background
                module_default = false, -- Default enable value for modules
                styles = { -- Style to be applied to different syntax groups
                    comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
                    functions = "NONE",
                    keywords = "NONE",
                    variables = "NONE",
                    conditionals = "NONE",
                    constants = "NONE",
                    numbers = "NONE",
                    operators = "NONE",
                    strings = "NONE",
                    types = "NONE",
                },
                inverse = { -- Inverse highlight for different types
                    match_paren = false,
                    visual = false,
                    search = false,
                },
                darken = { -- Darken floating windows and sidebar-like windows
                    floats = false,
                    sidebars = {
                        enabled = true,
                        list = {}, -- Apply dark background to specific windows
                    },
                },
                modules = { -- List of various plugins and additional options
                    -- ...
                },
            },
            palettes = {},
            specs = {},
            groups = {
                github_light = {
                    MiniIndentscopeSymbol = { fg = "#CECECD" },
                    illuminatedWordText = { bg = "#D8D7D7" },
                    illuminatedWordRead = { bg = "#D8D7D7" },
                    illuminatedWordWrite = { bg = "#E9EDF8" },
                    illuminatedWordKeepText = { bg = "#FCF0A1" },
                    illuminatedWordKeepRead = { bg = "#FCF0A1" },

                    illuminatedWordKeepWrite = { bg = "#CCE2E2" },
                },
            },
        })
        -- setup must be called before loading
        vim.cmd("colorscheme github_dark")
    end,
}
