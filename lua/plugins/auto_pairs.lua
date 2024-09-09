return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        break_undo = true,
        fast_wrap = {
            map = "<c-e>",
            chars = { "{", "[", "(", '"', "'", "<" },
            mirror_chars = { "}", "]", ")", '"', "'", ">" },
            pattern = [=[[%'%"%>%]%)}%,]]=],
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
        map_bs = true,
        map_cr = true,
    }, -- this is equalent to setup({}) function
    config = function(_, lazy_opts)
        require("nvim-autopairs").setup(lazy_opts)
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")

        npairs.add_rules({
            Rule("<", ">", "rust"):with_pair(function(opts)
                local line = opts.line
                local cur_pos = opts.col
                if line:sub(cur_pos - 1, cur_pos) == "<>" then
                    return false
                end
                return true
            end),
        })
    end,
}
