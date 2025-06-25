return {
    "folke/snacks.nvim",
    -- enabled = false,
    keys = function()
        local layout_no_prewview = {
            layout = {
                backdrop = false,
                box = "vertical",
                width = 0.4,
                height = 0.7,
                {
                    box = "vertical",
                    border = "solid",
                    title_pos = "center",
                    { win = "input", height = 1, border = "bottom" },
                    { win = "list", border = "none" },
                    -- { win = "preview", title = "ss", border = "top" },
                },
            },
            preview = false,
        }
        return {
            {
                "<leader>cs",
                function()
                    Snacks.picker.spelling({
                        layout = {
                            layout = {
                                backdrop = false,
                                box = "vertical",
                                width = 0.2,
                                row = 1,
                                -- col = -1,
                                height = 0.3,
                                {
                                    box = "vertical",
                                    border = "solid",
                                    title_pos = "center",
                                    { win = "input", height = 1, border = "bottom" },
                                    { win = "list", border = "none" },
                                    -- { win = "preview", title = "ss", border = "top" },
                                },
                            },
                            preview = false,
                        },
                    })
                end,
            },
            {
                "<leader>ch",
                function()
                    Snacks.picker.command_history({
                        layout = layout_no_prewview,
                    })
                end,
            },
            {
                "<leader>y",
                function()
                    Snacks.terminal.toggle({ cmd = { "yazi", vim.uv.cwd() } })
                end,
            },
            {
                "<d-o>",
                function()
                    TT = vim.uv.hrtime()
                    Snacks.picker.smart({
                        filter = {
                            cwd = true,
                        },
                        formatters = {
                            file = {
                                filename_first = true, -- display filename before the file path
                            },
                        },
                        layout = layout_no_prewview,
                    })
                end,
            },
        }
    end,
    version = false,
    opts = {
        terminal = {
            win = {
                style = {
                    backdrop = false,
                    keys = {
                        q = {
                            function()
                                return "<cmd>close<CR>"
                            end,
                            mode = { "t", "n" },
                            expr = true,
                        },
                        ["<c-[>"] = {
                            function()
                                vim.cmd("stopinsert")
                            end,
                            mode = "t",
                        },
                    },
                    wo = {
                        winblend = 3,
                    },
                },
                width = math.floor(vim.o.columns * 0.75),
                height = math.floor(vim.o.lines * 0.88),
            },
        },
        -- statuscolumn = {
        --     enabled = true,
        --     left = { "sign" }, -- priority of signs on the left (high to low)
        --     right = { "git" }, -- priority of signs on the right (high to low)
        --     folds = {
        --         open = false, -- show open fold icons
        --         git_hl = false, -- use Git Signs hl for fold icons
        --     },
        --     git = {
        --         -- patterns to match Git signs
        --         patterns = { "GitSign", "MiniDiffSign" },
        --     },
        --     refresh = 1, -- refresh at most every 50ms
        -- },
        picker = {
            enabled = true,
            prompt = " ",
            ui_select = true,
            layouts = {
                default = {
                    layout = {
                        backdrop = false,
                        box = "vertical",
                        width = 0.9,
                        min_width = 120,
                        height = 0.95,
                        {
                            box = "vertical",
                            border = "solid",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", height = 12, border = "none" },
                            { win = "preview", title = "{preview}", border = "top" },
                        },
                    },
                },
            },
            win = {
                input = {
                    keys = {
                        ["<c-u>"] = {
                            function()
                                FeedKeys("<c-u>", "n")
                            end,
                            mode = { "i" },
                        },
                    },
                },
                list = {
                    wo = {
                        scrolloff = 2,
                    },
                },
            },
        },
    },
}
