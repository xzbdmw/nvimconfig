return {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
        local ai = require("mini.ai")
        return {
            n_lines = 2000,
            custom_textobjects = {
                o = ai.gen_spec.treesitter({
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }, {}),
                -- f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                -- c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                d = { "%f[%d]%d+" }, -- digits
                e = { -- Word with case
                    {
                        "%u[%l%d]+%f[^%l%d]",
                        "%f[%S][%l%d]+%f[^%l%d]",
                        "%f[%P][%l%d]+%f[^%l%d]",
                        "^[%l%d]+%f[^%l%d]",
                    },
                    "^().*()$",
                },
                g = function() -- Whole buffer, similar to `gg` and 'G' motion
                    local from = { line = 1, col = 1 }
                    local to = {
                        line = vim.fn.line("$"),
                        col = math.max(vim.fn.getline("$"):len(), 1),
                    }
                    return { from = from, to = to }
                end,
            },
        }
    end,
}
