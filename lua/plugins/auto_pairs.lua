return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    -- enabled = false,
    opts = {
        disable_filetype = { "snacks_picker_input", "TelescopePrompt" },
        break_undo = false,
        fast_wrap = {
            map = "<c-9>",
            chars = { "{", "[", "(", '"', "'", "<" },
            mirror_chars = { "}", "]", ")", '"', "'", ">" },
            pattern = [=[[%'%"%>%]%)%;%s%}%,]]=],
            end_key = "e",
            before_key = "h",
            after_key = "l",
            cursor_pos_before = true,
            keys = "qwrtyuiopzxcvbnmasdfghjkl",
            manual_position = true,
            highlight = "Search",
            highlight_grey = "Comment",
        },
        enable_moveright = true,
        map_bs = false,
        map_cr = true,
    }, -- this is equalent to setup({}) function
    config = function(_, lazy_opts)
        require("nvim-autopairs").setup(lazy_opts)
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")

        npairs.add_rules({
            Rule("<", ">", "rust"):with_pair(function(opts)
                return false
            end),
        })
    end,
}
