return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "macchiato", -- latte, frappe, macchiato, mocha
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = false, -- disables setting the background color.
            show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
            term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
            dim_inactive = {
                enabled = false, -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.15, -- percentage of the shade to apply to the inactive window
            },
            no_italic = false, -- Force no italic
            no_bold = false, -- Force no bold
            no_underline = false, -- Force no underline
            styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                comments = {}, -- Change the style of comments
                conditionals = {},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {},
            custom_highlights = function(colors)
                return {
                    ["@lsp.typemod.selfKeyword"] = { fg = colors.red, italic = true },
                    ["@namespace"] = { style = { "nocombine" } },
                    ["@module"] = { style = { "nocombine" } },
                    CursorLine = { bg = "#1E2030" },
                    LspInlayHint = { fg = "#6C7086", bg = colors.none },
                    TreesitterContext = { bg = "#1e1e2e", style = { "bold", "italic" } },
                    NvimTreeCursorLine = { bg = "#1E2030", style = { "bold" }, fg = "#C6A0F6" },
                    NvimTreeWinSeparator = { bg = "#1E2030", fg = "#1E2030" },
                    Folded = { bg = "#303347" },
                    CursorLineNr = { bg = "#1E2030" },
                    Visual = { bg = "#304E75", style = { "nocombine" } },
                    CmpGhostText = { fg = "#6C7086", style = { "italic" } },
                    TelescopeMatching = { style = { "bold" } },
                    TelescopeNormal = { style = { "nocombine" } },
                    TelescopeSelection = { style = { "nocombine" } },
                    MatchParen = { fg = "#CDD6F4", bg = colors.none },
                    LualineCursorLine = { bg = "#2A2B3C" },
                    Unvisited = { bg = "#34344F" },
                    MiniIndentscopeSymbol = { fg = "#6C7086" },
                    illuminatedwordwrite = { bg = "#253C59" },
                    illuminatedwordread = { bg = "#32354A" },
                    illuminatedWordText = { bg = "#32354A" },
                    TreesitterContext = { bg = "#24273A", style = { "bold" } },
                    --[[ Comment = { fg = colors.flamingo },
                    TabLineSel = { bg = colors.pink },
                    CmpBorder = { fg = colors.surface2 },
                    Pmenu = { bg = colors.none }, ]]
                }
            end,
            integrations = {
                cmp = true,
                illuminate = false,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = false,
                flash = false,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })

        -- setup must be called before loading
        vim.cmd.colorscheme("catppuccin")
    end,
}
