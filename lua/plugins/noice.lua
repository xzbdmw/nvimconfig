return {
    "folke/noice.nvim",
    config = function()
        local noice = require("noice")
        noice.setup({
            routes = {
                {
                    filter = { event = "msg_show", find = "'modifiable' is off" },
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
            presets = { inc_rename = true },
            messages = {
                -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                -- This is a current Neovim limitation.
                enabled = true, -- enables the Noice messages UI
                view = "mini", -- default view for messages
                view_error = "notify", -- view for errors
                view_warn = "notify", -- view for warnings
                view_history = "messages", -- view for :messages
                view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
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
                        }, -- global options for the cmdline. See section on views
                    },
                    search_down = {
                        kind = "search",
                        pattern = "^/",
                        icon = "?",
                        lang = "regex",
                        conceal = true,
                    },
                    filter = { pattern = "^:%s*!", icon = "$", lang = "bash", conceal = true },
                    lua = {
                        pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
                        icon = "",
                        lang = "lua",
                        conceal = true,
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
                        }, -- global options for the cmdline. See section on views
                    },
                    help = {
                        pattern = "^:%s*he?l?p?%s+",
                        icon = "?",
                        conceal = true,
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
                    },
                    input = {}, -- Used by input()
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
                    throttle = 1000 / 30, -- frequency to update lsp progress message
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
                    enabled = true,
                    opts = {
                        size = {
                            max_height = 10,
                            max_width = 50,
                        },
                        border = {
                            style = "rounded",
                            padding = { 0, 2 },
                        },
                        position = { row = 2, col = 0 },
                    },
                },
            },
            views = {
                cmdline_popup = {
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    position = {
                        row = 10,
                        col = "50%",
                    },
                    size = {
                        width = 20,
                        height = "auto",
                    },
                },
                mini = {
                    focusable = false,
                    timeout = 2000,
                },
            },
        })
    end,
}
