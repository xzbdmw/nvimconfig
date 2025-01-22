return {
    "gbprod/substitute.nvim",
    keys = {
        {
            "s",
            function()
                require("substitute").operator({
                    modifiers = function(state)
                        if vim.bo.filetype == "markdown" or vim.bo.filetype == "txt" then
                            return {}
                        end
                        if state.vmode == "line" then
                            return { "reindent" }
                        end
                    end,
                })
            end,
        },
        {
            "S",
            "s$",
            remap = true,
        },
        {
            "s",
            function()
                local cursor = vim.api.nvim_win_get_cursor(0)
                return "_<cmd>lua vim.api.nvim_win_set_cursor(0,{" .. cursor[1] .. "," .. cursor[2] .. "})<cr>"
            end,
            expr = true,
            mode = "o",
        },
        {
            "ge",
            function()
                require("substitute.exchange").operator()
            end,
        },
        {
            "gee",
            "ge_",
            remap = true,
        },
        {
            "ge",
            function()
                require("substitute.exchange").visual()
            end,
            mode = "x",
        },
    },
    config = function()
        require("substitute").setup({
            on_substitute = require("yanky.integration").substitute(),
            yank_substituted_text = false,
            preserve_cursor_position = false,
            modifiers = nil,
            highlight_substituted_text = {
                enabled = true,
                timer = 130,
            },
            range = {
                prefix = "s",
                prompt_current_text = false,
                confirm = false,
                complete_word = false,
                subject = nil,
                range = nil,
                suffix = "",
                auto_apply = false,
                cursor_position = "end",
            },
            exchange = {
                motion = false,
                use_esc_to_cancel = false,
                preserve_cursor_position = true,
            },
        })
    end,
}
