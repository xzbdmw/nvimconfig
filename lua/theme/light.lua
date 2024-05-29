local success, engin = pcall(require, "illuminate.engine")
local success, ref = pcall(require, "illuminate.reference")
local success, go = pcall(require, "illuminate.goto")
_G.minidiff = false
local ns = vim.api.nvim_create_namespace("MiniDiffOverlay")
local keymap = vim.keymap.set

keymap("n", "n", function()
    if
        require("trouble").is_open("mydiags")
        or require("trouble").is_open("qflist")
        or require("trouble").is_open("before_qflist")
    then
        require("trouble").next({ skip_groups = true, jump = true })
    elseif #require("illuminate.reference").buf_get_keeped_references(vim.api.nvim_get_current_buf()) > 0 then
        _G.Cursor(require("illuminate.goto").goto_next_keeped_reference, 0.03)(true)
        return
    else
        local n = vim.v.hlsearch
        if n == 0 then
            _G.Cursor(require("illuminate").goto_next_reference, 0.03)(true)
        else
            vim.cmd("normal! n")
        end
    end
end)

keymap("n", "N", function()
    if
        require("trouble").is_open("mydiags")
        or require("trouble").is_open("qflist")
        or require("trouble").is_open("before_qflist")
    then
        require("trouble").prev({ skip_groups = true, jump = true })
    elseif #require("illuminate.reference").buf_get_keeped_references(vim.api.nvim_get_current_buf()) > 0 then
        _G.Cursor(require("illuminate.goto").goto_prev_keeped_reference, 0.03)(true)
        return
    else
        local n = vim.v.hlsearch
        if n == 0 then
            _G.Cursor(require("illuminate").goto_prev_reference, 0.03)(true)
        else
            vim.cmd("normal! N")
        end
    end
end)

keymap({ "s", "n" }, "<esc>", function()
    -- pcall(function()
    vim.api.nvim_exec_autocmds("User", {
        pattern = "ESC",
    })
    local flag = true
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if
                win_config.relative ~= "" and win_config.zindex == 45
                or win_config.zindex == 44
                or win_config.zindex == 44
                or win_config.zindex == 46
                or win_config.zindex == 47
                or win_config.zindex == 50
                or win_config.zindex == 80
                or win_config.zindex == 35 --lpsaga
            then
                flag = false
                _G.no_animation()
                vim.api.nvim_win_close(win, true)
            elseif win_config.zindex == 10 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
        end
    end
    if flag then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        vim.cmd("noh")
    end
    if success then
        engin.clear_keeped_highlight()
        go.clear_keeped_hl()
    end
    -- end)
end)
-- illuminate
keymap("n", "H", function()
    local bufnr = vim.api.nvim_get_current_buf()
    pcall(engin.keep_highlight, bufnr)
end)
