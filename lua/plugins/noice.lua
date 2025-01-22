return {
    "folke/noice.nvim",
    dependencies = { { "MunifTanjim/nui.nvim" } },
    cond = function()
        return not vim.g.scrollback
    end,
    keys = {
        {
            "<leader>na",
            function()
                vim.cmd("NoiceAll")
                vim.cmd("wincmd L")
            end,
        },
    },
    config = function()
        local noice = require("noice")
        noice.setup({
            routes = {
                {
                    filter = { event = "msg_show", find = "'modifiable' is off" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "InlayHint" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "generated file" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "indented" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "yanked" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "lines" },
                    opts = { skip = true },
                },
                {
                    filter = { find = "Invalid offset LineCol" },
                    opts = { skip = true },
                },
                {
                    filter = { find = "refused to load this directory" },
                    opts = { skip = true },
                },
                {
                    filter = { find = "Finding references" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "notify.warn", find = "is_enabled" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "notify", find = "Plugin" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "Pattern not found" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "sentiment" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "notify", find = "swapfile" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "_watch" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "room" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "deprecated" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "BufLeave" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "notify", find = "VenvSelect" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "jdtls" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "notify", find = "client" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "winminwidth" },
                    opts = { skip = true },
                },
                -- {
                --     filter = { event = "msg_show", find = "%--" },
                --     opts = { skip = true },
                -- },
            },
            presets = {
                inc_rename = true,
                -- bottom_search = true, -- use a classic bottom cmdline for search
            },
            messages = {
                -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                -- This is a current Neovim limitation.
                enabled = true, -- enables the Noice messages UI
                view = "mini", -- default view for messages
                view_error = "notify", -- view for errors
                view_warn = "notify", -- view for warnings
                view_history = "messages", -- view for :messages
                view_search = false, -- view for search count messages. Set to `false` to disable
            },
            cmdline = {
                enabled = true, -- enables the Noice cmdline UI
                view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                format = {
                    cmdline = {
                        pattern = "^:",
                        icon = "> ",
                        lang = "vim",
                        conceal = true,
                        opts = {
                            zindex = 250,
                            border = {
                                style = "none",
                                padding = { 0, 1 },
                            },
                            position = {
                                row = "100%",
                                col = "0%",
                            },
                            size = {
                                width = "100%",
                                height = "auto",
                            },
                        }, -- global options for the cmdline. See section on views
                    },
                    search_down = {
                        view = "cmdline",
                        icon = " ?",
                    },
                    search_up = {
                        view = "cmdline",
                        icon = " ?",
                    },
                    filter = { pattern = "ffffffff", icon = "$", lang = "bash", conceal = true },
                    lua = {
                        pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
                        icon = " ",
                        lang = "lua",
                        conceal = true,
                        opts = {
                            zindex = 250,
                            border = {
                                style = "none",
                                padding = { 0, 1 },
                            },
                            position = {
                                row = "100%",
                                col = "0%",
                            },
                            size = {
                                width = "100%",
                                height = "auto",
                            },
                        }, -- global options for the cmdline. See section on views, -- global options for the cmdline. See section on views
                    },
                    help = {
                        pattern = "^:%s*he?l?p?%s+",
                        icon = "? ",
                        conceal = true,
                        opts = {
                            zindex = 250,
                            border = {
                                style = "none",
                                padding = { 0, 1 },
                            },
                            position = {
                                row = "100%",
                                col = "0%",
                            },
                            size = {
                                width = "100%",
                                height = "auto",
                            },
                        }, -- global options for the cmdline. See section on views
                    },
                    input = {
                        opts = {
                            border = {
                                style = "rounded",
                                padding = { 0, 1 },
                            },
                            position = {
                                row = "30%",
                                col = "50%",
                            },
                            size = {
                                width = 40,
                                height = "auto",
                            },
                        },
                    }, -- Used by input()
                },
            },
            lsp = {
                message = {
                    -- Messages shown by lsp servers
                    enabled = true,
                    view = "mini",
                    opts = {},
                },
                progress = {
                    enabled = true,
                    -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
                    -- See the section on formatting for more details on how to customize.
                    format = "lsp_progress",
                    format_done = "lsp_progress_done",
                    throttle = 100, -- frequency to update lsp progress message
                    view = "mini",
                },
                signature = {
                    enabled = false,
                    opts = {
                        size = {
                            max_height = 10,
                        },
                    },
                },
                hover = {
                    view = nil,
                    enabled = true,
                    win_options = {
                        wrap = true,
                        linebreak = false,
                        winblend = 10,
                    },
                    opts = {
                        size = {
                            max_height = 15,
                            max_width = 80,
                        },
                        border = {
                            style = "none",
                            padding = { 0, 1 },
                        },
                        -- position = { row = 2, col = 0 },
                    },
                },
            },

            throttle = 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
            views = {
                confirm = {
                    zindex = 1003,
                    position = {
                        row = "45%",
                        col = "50%",
                    },
                },
                cmdline_popup = {
                    zindex = 20,
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    position = {
                        row = 20,
                        col = "50%",
                    },
                    size = {
                        width = 20,
                        height = "auto",
                    },
                },
                vsplit = {
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "NoiceSplitBorder" },
                        wrap = true,
                    },
                    view = "split",
                    enter = true,
                    position = "right",
                    size = {
                        width = 65,
                    },
                },
                mini = {
                    win_options = {
                        winbar = "",
                        foldenable = false,
                        winblend = 1,
                        winhighlight = {
                            Normal = "Normal",
                            IncSearch = "",
                            CurSearch = "",
                            Search = "",
                        },
                    },
                    zindex = 1003,
                    focusable = false,
                    timeout = 2000,
                },
            },
        })
    end,
}
