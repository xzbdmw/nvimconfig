return {
    "b0o/incline.nvim",
    enabled = false,
    commit = "ba95a8d0fc02734967dcbe15c024a34bae7c87aa",
    --Optional: Lazy load Incline
    event = "VeryLazy",
    config = function()
        require("incline").setup({
            debounce_threshold = {
                falling = 200,
                rising = 200,
            },
            hide = {
                cursorline = false,
                focused_win = false,
                only_win = false,
            },
            highlight = {
                groups = {
                    InclineNormal = {
                        default = true,
                        group = "NormalFloat",
                    },
                    InclineNormalNC = {
                        default = true,
                        group = "NormalFloat",
                    },
                },
            },
            ignore = {
                buftypes = "special",
                filetypes = {},
                floating_wins = true,
                unlisted_buffers = true,
                wintypes = "special",
            },
            render = function(props)
                local function get_diagnostic_label()
                    local icons = { error = "", warn = "", info = "", hint = "" }
                    local label = {}
                    for severity, icon in pairs(icons) do
                        local n = #vim.diagnostic.get(
                            props.buf,
                            { severity = vim.diagnostic.severity[string.upper(severity)] }
                        )
                        if n > 0 then
                            table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
                        end
                    end
                    return label
                end
                return {
                    -- { { "winid: " .. tostring(vim.api.nvim_get_current_win()) } },
                    -- { { "bufid: " .. tostring(vim.api.nvim_get_current_buf()) } },
                    { get_diagnostic_label() },
                    -- { get_git_diff() },
                }
            end,
            window = {
                overlap = {
                    winbar = true,
                },
                margin = {
                    horizontal = 0,
                    vertical = 0,
                },
                options = {
                    signcolumn = "no",
                    wrap = false,
                },
                padding = 1,
                padding_char = " ",
                placement = {
                    horizontal = "right",
                    vertical = "top",
                },
                width = "fit",
                winhighlight = {
                    active = {
                        EndOfBuffer = "None",
                        Normal = "InclineNormal",
                        Search = "None",
                    },
                    inactive = {
                        EndOfBuffer = "None",
                        Normal = "InclineNormalNC",
                        Search = "None",
                    },
                },
                zindex = 20,
            },
        })
    end,
}
