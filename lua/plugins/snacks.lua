return {
    "folke/snacks.nvim",
    keys = {
        {
            "<d-o>",
            function()
                local l2 = {
                    layout = {
                        backdrop = false,
                        box = "vertical",
                        width = 0.4,
                        height = 0.7,
                        {
                            box = "vertical",
                            border = "solid",
                            title = "",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                            -- { win = "preview", title = "ss", border = "top" },
                        },
                    },
                    preview = false,
                }
                -- local layouts = require("snacks.picker.config.layouts")
                local layout = {
                    layout = {
                        backdrop = false,
                        box = "horizontal",
                        width = 0.9,
                        height = 0.9,
                        {
                            box = "vertical",
                            border = "rounded",
                            title = "{source} {live}",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                        },
                        { win = "preview", border = "rounded", width = 0.5 },
                    },
                    preview = true,
                }

                Snacks.picker.smart({
                    filter = {
                        cwd = true,
                    },
                    formatters = {
                        file = {
                            filename_first = true, -- display filename before the file path
                        },
                    },
                    layout = l2,
                })
            end,
        },
    },
    version = false,
    -- enabled = false,
    -- priority = 1000,
    -- lazy = false,
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
                            title = "",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", height = 12, border = "none" },
                            { win = "preview", title = "ss", border = "top" },
                        },
                    },
                },
            },
            win = {
                input = {
                    keys = {
                        ["<Tab>"] = { "cycle_win", mode = { "i", "n" } },
                        -- ["<Space>"] = {
                        --     function(data)
                        --         -- __AUTO_GENERATED_PRINT_VAR_START__
                        --         print([==[function data:]==], vim.inspect(data)) -- __AUTO_GENERATED_PRINT_VAR_END__
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
