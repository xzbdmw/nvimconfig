return {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
        local ai = require("mini.ai")
        return {
            n_lines = 2000,
            custom_textobjects = {
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                -- c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                -- d = { "%f[%d]%d+" }, -- digits
                e = { -- Word with case
                    {
                        "%u[%l%d]+%f[^%l%d]",
                        "%f[%S][%l%d]+%f[^%l%d]",
                        "%f[%P][%l%d]+%f[^%l%d]",
                        "^[%l%d]+%f[^%l%d]",
                    },
                    "^().*()$",
                },
                d = function(args)
                    -- List of delimiter characters
                    -- stylua: ignore
                    local chars =
                        { "=", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "%", "`", "?", "(", ")", "{", "}", "-", "/" }

                    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

                    -- Get the current line's content
                    local line = vim.api.nvim_get_current_line()
                    local line_length = #line

                    -- Initialize from and to positions
                    local from = nil
                    local to = nil
                    local space_count = 0
                    -- Search backwards for the previous delimiter
                    for i = col, 1, -1 do
                        local c = line:sub(i, i)
                        if c == " " or c == "\t" then
                            space_count = space_count + 1
                            if space_count == 2 then
                                from = i
                                break
                            end
                        end
                        if vim.tbl_contains(chars, c) then
                            from = i
                            break
                        end
                    end
                    if not from then
                        from = 1 -- Start of line if no delimiter is found
                    end
                    space_count = 0
                    -- Search forwards for the next delimiter
                    for i = col + 1, line_length do
                        local c = line:sub(i, i)
                        if c == " " or c == "\t" then
                            space_count = space_count + 1
                            if space_count == 2 then
                                to = i
                                break
                            end
                        end
                        if vim.tbl_contains(chars, c) then
                            to = i
                            break
                        end
                    end
                    if not to then
                        to = line_length -- End of line if no delimiter is found
                    end
                    local res = line:sub(from, to)
                    if args == "a" then
                        local range = line:sub(from, to)
                        local front_space_count = 0
                        for i = 1, #range do
                            local c = line:sub(i, i)
                            if c == " " or c == "\t" then
                                front_space_count = front_space_count + 1
                            else
                                break
                            end
                        end
                        local end_space_count = 0
                        for i = #range, -1 do
                            local c = line:sub(i, i)
                            if c == " " or c == "\t" then
                                end_space_count = end_space_count + 1
                            else
                                break
                            end
                        end
                        if front_space_count == 1 and end_space_count == 1 then
                            from = from + 1
                        end
                        if front_space_count == 1 and end_space_count == 0 then
                            from = from + 1
                        end
                        if end_space_count == 1 and front_space_count == 0 then
                            to = to - 1
                        end
                        return { from = { line = row, col = from }, to = { line = row, col = to } }
                    else
                        local range = line:sub(from + 1, to - 1)
                        local front_space_count = 0
                        for i = 1, #range do
                            local c = range:sub(i, i)
                            if c == " " or c == "\t" then
                                front_space_count = front_space_count + 1
                            else
                                break
                            end
                        end
                        local end_space_count = 0
                        for i = #range, 1, -1 do
                            local c = range:sub(i, i)
                            if c == " " or c == "\t" then
                                end_space_count = end_space_count + 1
                            else
                                break
                            end
                        end
                        if front_space_count == 1 and end_space_count == 1 then
                            from = from + 1
                        end
                        if front_space_count == 1 and end_space_count == 0 then
                            from = from + 1
                        end
                        if end_space_count == 1 and front_space_count == 0 then
                            to = to - 1
                        end
                        return { from = { line = row, col = from + 1 }, to = { line = row, col = to - 1 } }
                    end
                    -- Return the positions as a table
                end,
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
