return {
    "gbprod/substitute.nvim",
    keys = {
        {
            "s",
            function()
                require("substitute").operator({
                    modifiers = function(state)
                        if state.vmode == "line" then
                            return { "reindent" }
                        end
                    end,
                })
            end,
        },
        {
            "S",
            function()
                require("substitute").operator()
            end,
        },
        {
            "ss",
            "s_",
            remap = true,
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
