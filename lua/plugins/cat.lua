return {
    "catppuccin/nvim",
    name = "catppuccin",
    init = function()
        local selection_mode = false
        -- api.nvim_create_autocmd("ModeChanged", {
        --     pattern = "*:s",
        --     callback = function()
        --         if selection_mode == false then
        --             api.nvim_set_hl(0, "Visual", { bg = "#375D7C" })
        --             selection_mode = true
        --         end
        --     end,
        -- })
        -- api.nvim_create_autocmd("ModeChanged", {
        --     pattern = "*:v",
        --     callback = function()
        --         if selection_mode then
        --             api.nvim_set_hl(0, "Visual", { bg = "#39424A" })
        --             selection_mode = false
        --         end
        --     end,
        -- })
    end,
    -- priority = 1000,
    config = function()
        require("catppuccin").setup({
            compile_path = vim.fn.stdpath("cache") .. "/cat",
            flavour = "frappe", -- latte, frappe, macchiato, mocha
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
            no_italic = true, -- Force no italic
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
                    ["@lsp.typemod.selfKeyword"] = { fg = colors.red },
                    ["@lsp.type.selfTypeKeyword"] = { fg = colors.red },
                    ["@lsp.typemod.decorator"] = { link = "special" },
                    ["@namespace"] = { style = { "nocombine" } },
                    ["@module"] = { style = { "nocombine" } },
                    TreesitterContextLineNumber = { fg = "#494D64", bg = "#1e2030" },
                    CursorLine = { bg = "#292D3F" },
                    Comment = { link = "NvimTreeFolderIcon" },
                    WinbarFolder = { fg = "#8F98B8" },
                    WinbarFileName = { fg = "#B6BDFD" },
                    ["@function.builtin"] = { link = "Function" },
                    ["@punctuation.bracket"] = { link = "Comment" },
                    ["@punctuation.special.rust"] = { link = "Comment" },
                    String = { fg = "#92be83" },
                    FzfLuaBorder = { link = "TelescopeBorder" },
                    GlancePreviewMatch = { fg = "#ffffff", bg = "#304E75" },
                    GlanceWinbarFileName = { link = "NvimTreeRootFolder" },
                    GlanceListMatch = { fg = "#8AADF4" },
                    CmpItemAbbrMatch = { fg = "none", style = { "bold" } },
                    CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
                    GlanceWinbarFolderName = { link = "Comment" },
                    GlanceListCursorLine = { bg = "#212635" },
                    -- GlanceListNormal = { fg = "#8F98B8", bg = "#15182A" },
                    -- GlancePreviewNormal = { bg = "#1A1E30" },
                    LspInlayHint = { fg = "#8D98BB", bg = colors.none },
                    NvimTreeOpenedFile = { fg = "#cad3f5" },
                    NvimTreeRootFolder = { fg = "#B6BDFD", style = { "nocombine" } },
                    NvimTreeFolderName = { link = "Directory" },
                    NvimTreeOpenedFolderName = { link = "NvimTreeOpenedFile" },
                    NvimTreeFolderIcon = { link = "Directory" },
                    NvimTreeFileIcon = { fg = "#CAD3F5" },
                    NvimTreeCursorLine = { bg = "#24273A" },
                    NvimTreeNormal = { bg = "#1e2030", fg = "#8F98B8" },
                    Folded = { link = "CursorLine" },
                    Directory = { fg = "#8F98B8" },
                    ArrowCurrentFile = { link = "Comment" },
                    TermCursor = { fg = "#000000", bg = "#B7BDF8" },
                    Visual = { bg = "#304E75", style = { "nocombine" } },
                    NvimTreeWinSeparator = { link = "WinSeparator" },
                    CmpGhostText = { fg = "#6C7086", style = { "italic" } },
                    CmpItemMenu = { link = "Comment" },
                    TelescopeMatching = { style = { "bold" } },
                    TelescopeNormal = { bg = "#1E2031", style = { "nocombine" } },
                    TelescopeBorder = { bg = "#1E2031", style = { "nocombine" } },
                    TelescopeSelection = { style = { "nocombine" } },
                    MyNormalFloat = { bg = "#1e2030" },
                    MyCursorLine = { bg = "#283E5B" },
                    MatchParen = { fg = "#F0C6C6", style = { "nocombine" }, bg = colors.none },
                    LualineCursorLine = { bg = "#2A2B3C" },
                    Unvisited = { bg = "#34344F" },
                    MiniIndentscopeSymbol = { fg = "#6C7086" },
                    illuminatedwordwrite = { bg = "#253C59" },

                    BlinkCmpLabelMatch = { style = { "bold" } },
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
        -- vim.cmd.colorscheme("catppuccin")
    end,
}
