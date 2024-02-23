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
            term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
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
                    ["@lsp.type.selfTypeKeyword"] = { fg = colors.red, style = { "italic" } },
                    ["@namespace"] = { style = { "nocombine" } },
                    ["@module"] = { style = { "nocombine" } },
                    TreesitterContextLineNumber = { link = "NvimTreeNormal" },
                    CursorLine = { bg = "#292D3F" },
                    WinbarFolder = { fg = "#8F98B8" },
                    WinbarFileName = { fg = "#cad3f5" },
                    FzfLuaBorder = { link = "TelescopeBorder" },
                    GlancePreviewMatch = { fg = "#ffffff", bg = "#304E75" },
                    GlanceListMatch = { fg = "#8AADF4" },
                    GlanceListCursorLine = { bg = "#212635" },
                    GlanceListNormal = { fg = "#8F98B8", bg = "#15182A" },
                    LspInlayHint = { fg = "#6C7086", bg = colors.none },
                    NvimTreeOpenedFile = { fg = "#cad3f5" },
                    NvimTreeFileIcon = { fg = "#CAD3F5" },
                    NvimTreeCursorLine = { bg = "#24273A" },
                    NvimTreeNormal = { bg = "#1e2030", fg = "#8F98B8" },
                    Folded = { link = "CursorLine" },
                    ArrowCurrentFile = { link = "Comment" },
                    TermCursor = { fg = "#000000", bg = "#B7BDF8" },
                    Visual = { bg = "#304E75", style = { "nocombine" } },
                    NvimTreeWinSeparator = { link = "WinSeparator" },
                    CmpGhostText = { fg = "#6C7086", style = { "italic" } },
                    TelescopeMatching = { style = { "bold" } },
                    TelescopeNormal = { style = { "nocombine" } },
                    TelescopeSelection = { style = { "nocombine" } },
                    MyNormalFloat = { bg = "#1e2030" },
                    MyCursorLine = { bg = "#2E4A6F" },
                    MatchParen = { fg = "#F0C6C6", style = { "italic" } },
                    LualineCursorLine = { bg = "#2A2B3C" },
                    Unvisited = { bg = "#34344F" },
                    MiniIndentscopeSymbol = { fg = "#6C7086" },
                    illuminatedwordwrite = { bg = "#253C59" },
                    illuminatedwordread = { bg = "#32354A" },
                    illuminatedWordText = { bg = "#32354A" },
                }
            end,
            integrations = {
                cmp = true,
                illuminate = false,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = false,
                flash = true,
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
