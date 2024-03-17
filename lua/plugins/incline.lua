return {
    "b0o/incline.nvim",
    -- enabled = false,
    commit = "ba95a8d0fc02734967dcbe15c024a34bae7c87aa",
    --Optional: Lazy load Incline
    event = "VeryLazy",
    config = function()
        require("incline").setup({
            debounce_threshold = {
                falling = 50,
                rising = 10,
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
                    local icons = { Error = "E", Warn = "W", Info = "I", Hint = "H" }
                    local diagnosticsCount = { Error = 0, Warn = 0, Info = 0, Hint = 0 }

                    -- 收集每种严重程度的诊断计数
                    for severity, _ in pairs(icons) do
                        diagnosticsCount[severity] =
                            #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[severity] })
                    end

                    local label = {}
                    local highestSeverityLabel = nil

                    -- 确定最高的非零严重程度
                    if diagnosticsCount.Error > 0 then
                        highestSeverityLabel = "Error"
                    elseif diagnosticsCount.Warn > 0 then
                        highestSeverityLabel = "Warn"
                    elseif diagnosticsCount.Info > 0 then
                        highestSeverityLabel = "Info"
                    elseif diagnosticsCount.Hint > 0 then
                        highestSeverityLabel = "Hint"
                    end

                    -- 如果存在非零的最高严重程度，构建对应的标签
                    if highestSeverityLabel then
                        label = {
                            { "   " }, -- 前缀图标
                            {
                                diagnosticsCount[highestSeverityLabel] .. " ",
                                group = "DiagnosticSign" .. highestSeverityLabel,
                            },
                        }
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
