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

function M.auto_add_forl()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*forl$") == nil) then
        return
    end
    if require("cmp").visible() then
        require("cmp").close()
    end
    MiniSnippets.expand()
end

function M.auto_add_forj()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if (#vim.api.nvim_get_current_line() ~= col) or (string.match(line, "^%s*forj$") == nil) then
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

function M.lua_abbr()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    for s, n in pairs({ lcoal = "<BS><BS><BS><BS>ocal", funciton = "<BS><BS><BS><BS>tion", functino = "<BS><BS>on" }) do
        if string.match(line, "^%s*" .. s) ~= nil then
            FeedKeys(n, "m")
            if require("cmp").visible() then
                require("cmp").close()
            end
        end
    end
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

function M.lua_auto_pai()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local _, idx = string.find(line, "vim%.pai")
    if idx == nil or col ~= idx then
        return
    end
    FeedKeys("<BS><BS><BS>api", "n")
end

function M.lua_auto_pia()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local _, idx = string.find(line, "vim%.pia")
    if idx == nil or col ~= idx then
        return
    end
    FeedKeys("<BS><BS><BS>api", "n")
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
    local idx
    _, idx = string.find(line, "%s+ren")
    if idx == nil or col ~= idx then
        idx = string.find(line, "^ren$")
        if idx == nil then
            return
        end
    end
    FeedKeys("<c-g>u<BS>turn", "n")
    if require("cmp").visible() then
        require("cmp").close()
    end
end

function M.autotrue()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local _, idx = string.find(line, ".*%sture")
    if idx == nil or col ~= idx then
        return
    end
    FeedKeys("<BS><BS><BS>rue", "n")
end

function M.autofalse()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local _, idx = string.find(line, "flase")
    if idx == nil or col ~= idx then
        return
    end
    FeedKeys("<BS><BS><BS><BS>alse", "n")
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
