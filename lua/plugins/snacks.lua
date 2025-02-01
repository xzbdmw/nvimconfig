return {
    "folke/snacks.nvim",
    enabled = false,
    keys = {
        {
            "<leader>sG",
            function()
                Snacks.picker.grep({})
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
                    layout = {
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
                    },
                })
            end,
        },
    },
    version = false,
    -- enabled = false,
    -- priority = 1000,
    lazy = false,
    ---@type snacks.Config
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
                        ["<c-p>"] = { "inspect", mode = { "i", "n" } },
                        -- ["<Space>"] = {
                        --     function(data)
                        --         FeedKeys(".*", "n")
                        --     end,
                        --     mode = { "i", "n" },
                        -- },
                        ["`"] = {
                            function()
                                FeedKeys("file:$<left>", "n")
                            end,
                            mode = { "i", "n" },
                        },
                    },
                },
                list = {
                    wo = {
                        scrolloff = 2,
                    },
                },
                preview = {
                    keys = {
                        ["<Tab>"] = "focus_input",
                    },
                    wo = {
                        signcolumn = "no",
                    },
                    on_buf = function(w)
                        require("config.utils").update_preview_state(w.buf, vim.fn.win_findbuf(w.buf)[1])
                    end,
                },
            },
        },
    },
}
