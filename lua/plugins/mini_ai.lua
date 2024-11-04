return {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
        local ai = require("mini.ai")
        return {
            n_lines = 2000,
            custom_textobjects = {
                [","] = function()
                    local line = vim.api.nvim_get_current_line()
                    local cursor_pos = vim.fn.col(".")
                    local left_comma, right_comma = nil, nil
                    local left_first_space, right_first_space = nil, nil

                    for i = cursor_pos, 1, -1 do
                        if i ~= cursor_pos and line:sub(i, i) ~= "," and line:sub(i, i):match("%W") then
                            if left_first_space == nil then
                                left_first_space = i
                            end
                        end
                        if line:sub(i, i) == "," then
                            left_comma = i
                            break
                        end
                    end
                    for i = cursor_pos, #line do
                        if i ~= cursor_pos and line:sub(i, i) ~= "," and line:sub(i, i):match("%W") then
                            right_first_space = i
                            break
                        end
                        if line:sub(i, i) == "," then
                            right_comma = i
                            break
                        end
                    end
                    if left_comma and right_comma then
                        return {
                            from = { line = vim.fn.line("."), col = left_comma },
                            to = { line = vim.fn.line("."), col = right_comma - 1 },
                        }
                    elseif right_comma and not left_comma then
                        if right_comma <= #line and line:sub(right_comma + 1, right_comma + 1) == " " then
                            right_comma = right_comma + 1
                        end
                        return {
                            from = { line = vim.fn.line("."), col = left_first_space and left_first_space + 1 or 0 },
                            to = { line = vim.fn.line("."), col = right_comma },
                        }
                    elseif left_comma and not right_comma then
                        return {
                            from = { line = vim.fn.line("."), col = left_comma },
                            to = { line = vim.fn.line("."), col = right_first_space and right_first_space - 1 or #line },
                        }
                    else
                        return nil
                    end
                end,
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
