return {
    "folke/noice.nvim",
    config = function()
        local noice = require("noice")
        noice.setup({
            cmdline = {
                enabled = true, -- enables the Noice cmdline UI
                view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                format = {
                    cmdline = {
                        pattern = "^:",
                        icon = "> ",
                        lang = "vim",
                        conceal = false,
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
                        conceal = false,
                    },
                    filter = { pattern = "^:%s*!", icon = "$", lang = "bash", conceal = false },
                    lua = {
                        pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
                        icon = "",
                        lang = "lua",
                        conceal = false,
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
                        icon = "",
                        conceal = false,
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
                signature = {
                    enabled = false,
                    opts = {
                        size = {
                            max_height = 10,
                        },
                    },
                },
                hover = {
                    opts = {
                        size = {
                            max_height = 15,
                            max_width = 50,
                        },
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
            },
        })
    end,
}
