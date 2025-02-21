return {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
        local ai = require("mini.ai")
        return {
            n_lines = 2000,
            custom_textobjects = {
                [","] = ai.gen_spec.treesitter({ i = "@parameter.inner", a = "@parameter.outer" }, {}),
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                c = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
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
