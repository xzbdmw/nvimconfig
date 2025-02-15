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
                "<leader>-",
                function()
                    Snacks.picker.zoxide({
                        layout = layout_no_prewview,
                        actions = {
                            oil = function(picker, item)
                                picker:close()
                                vim.cmd("Oil " .. item.file)
                            end,
                        },
                        win = {
                            input = {
                                keys = {
                                    ["<CR>"] = {
                                        "oil",
                                        mode = { "i", "n" },
                                    },
                                },
                            },
                        },
                    })
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
