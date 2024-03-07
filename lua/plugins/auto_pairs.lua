return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        break_undo = true,
        enable_moveright = true,
        map_bs = true,
        map_cr = true,
    }, -- this is equalent to setup({}) function
    config = function(_, opts)
        require("nvim-autopairs").setup(opts)
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")

        -- 添加自动配对规则使得 <> 成为自动配对的字符
        npairs.add_rules({
            Rule("<", ">", "-vim") -- 这里假设我们不想在 Vim 脚本文件中启用这个规则
                :with_pair(function(opts)
                    -- local line = opts.line
                    -- local cur_pos = opts.col
                    -- -- 检查是否在 <> 内部有其他字符，如果有，则不添加配对
                    -- if line:sub(cur_pos - 1, cur_pos) == "<>" then
                    --     return false
                    -- end
                    return true
                end),
        })
    end,
}
