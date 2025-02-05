local M = {}

function M.auto_add_forr()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*forr$") == nil) then
        return
    end
    if require("cmp").visible() then
        require("cmp").close()
    end
    MiniSnippets.expand()
end

function M.auto_add_fori()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*fori$") == nil) then
        return
    end
    if require("cmp").visible() then
        require("cmp").close()
    end
    MiniSnippets.expand()
end

function M.auto_add_if()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*iff$") == nil) then
        return
    end
    FeedKeys("<BS>", "m")
    if require("cmp").visible() then
        require("cmp").close()
    end
    vim.schedule(function()
        MiniSnippets.expand()
    end)
end

function M.lua_auto_add_while()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*whil$") == nil) then
        return
    end
    if require("cmp").visible() then
        require("cmp").close()
    end
    MiniSnippets.expand()
end

function M.lua_auto_add_local()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*ll$") == nil) then
        return
    end
    FeedKeys("<BS>ocal ", "n")
    if require("cmp").visible() then
        require("cmp").close()
    end
end

function M.auto_add_ret()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if string.match(line, "^%s*ren") == nil then
        return
    end
    FeedKeys("<BS>turn ", "n")
    if require("cmp").visible() then
        require("cmp").close()
    end
end

function M.go_auto_add_equal()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*%w+%s+:$") == nil) then
        return
    end
    FeedKeys("= ", "n")
end

function M.go_auto_add_method()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*met$") == nil) then
        return
    end
    if require("cmp").visible() then
        require("cmp").close()
    end
    MiniSnippets.expand()
end

function M.go_auto_add_func()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*func$") == nil) then
        return
    end
    if require("cmp").visible() then
        require("cmp").close()
    end
    MiniSnippets.expand()
end

function M.go_auto_add_pair()
    local line = vim.api.nvim_get_current_line()
    if (string.match(line, "^func %w+%b()") or string.match(line, "%=%s*func%b()")) == nil then
        return
    end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    if line:sub(col, col) == "," then
        for i = col - 1, 1, -1 do
            local char = line:sub(i, i)
            if char == "(" then
                return
            end
            if (char == " " and line:sub(i - 1, i - 1) == ")") or char == ")" then
                vim.api.nvim_buf_set_text(0, row - 1, i, row - 1, i, { "(" })
                FeedKeys(" ", "n")
                vim.api.nvim_buf_set_text(0, row - 1, col + 1, row - 1, col + 1, { ")" })
                return
            end
        end
    end
end

return M
