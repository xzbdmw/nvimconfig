return {
    "b0o/incline.nvim",
    -- enabled = false,
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
                local function get_git_diff()
                    local icons = { removed = "", changed = "", added = "" }
                    local signs = vim.b[props.buf].gitsigns_status_dict
                    local labels = {}
                    if signs == nil then
                        return labels
                    end
                    for name, icon in pairs(icons) do
                        if tonumber(signs[name]) and signs[name] > 0 then
                            table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
                        end
                    end
                    if #labels > 0 then
                        table.insert(labels, 1, { "   " })
                    end
                    return labels
                end

                local function get_diagnostic_label()
                    local icons = {
                        Error = "",
                        Warn = "",
                        Info = "",
                        Hint = "",
                    }

                    local label = {}
                    for severity, _ in pairs(icons) do
                        local n = #vim.diagnostic.get(
                            props.buf,
                            { severity = vim.diagnostic.severity[string.upper(severity)] }
                        )
                        if n > 0 then
                            label = {
                                { "   " }, -- 前缀图标
                                {
                                    n,
                                    group = "DiagnosticSign" .. severity,
                                },
                            }
                            break
                        end
                    end
                    return label
                end

                return {
                    { get_diagnostic_label() },
                    { get_git_diff() },
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
