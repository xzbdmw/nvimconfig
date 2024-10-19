return {
    "lewis6991/satellite.nvim",
    config = function()
        require("satellite").setup({
            current_only = true,
            winblend = 0,
            zindex = 800,
            excluded_filetypes = { "minifiles", "NvimTree" },
            width = 1,
            handlers = {
                cursor = {
                    enable = true,
                    -- Supports any number of symbols
                    -- symbols = { " " },
                    symbols = { "⎻" },
                    -- Highlights:
                    -- - SatelliteCursor (default links to NonText
                },
                search = {
                    enable = true,
                    signs = { "=" },
                    overlap = true,
                    -- Highlights:
                    -- - SatelliteSearch (default links to Search)
                    -- - SatelliteSearchCurrent (default links to SearchCurrent)
                },
                diagnostic = {
                    enable = false,
                    signs = { "-", "=", "≡" },
                    min_severity = vim.diagnostic.severity.WARN,
                    -- Highlights:
                    -- - SatelliteDiagnosticError (default links to DiagnosticError)
                    -- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
                    -- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
                    -- - SatelliteDiagnosticHint (default links to DiagnosticHint)
                },
                gitsigns = {
                    enable = true,
                    signs = { -- can only be a single character (multibyte is okay)
                        add = "│",
                        change = "│",
                        delete = "-",
                    },
                    overlap = false,
                    -- Highlights:
                    -- SatelliteGitSignsAdd (default links to GitSignsAdd)
                    -- SatelliteGitSignsChange (default links to GitSignsChange)
                    -- SatelliteGitSignsDelete (default links to GitSignsDelete)
                },
                marks = {
                    enable = false,
                },
                quickfix = {
                    enable = false,
                    signs = { "≡" },
                    -- Highlights:
                    -- SatelliteQuickfix (default links to WarningMsg)
                },
            },
        })
    end,
}
