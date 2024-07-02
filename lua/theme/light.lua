local success, engin = pcall(require, "illuminate.engine")
local success, ref = pcall(require, "illuminate.reference")
local success, go = pcall(require, "illuminate.goto")
local utils = require("config.utils")
_G.minidiff = false
local ns = api.nvim_create_namespace("MiniDiffOverlay")
local keymap = vim.keymap.set

keymap("n", "n", function()
    if #require("illuminate.reference").buf_get_keeped_references(api.nvim_get_current_buf()) > 0 then
        require("illuminate.goto").goto_next_keeped_reference(true)
        return
    elseif utils.has_filetype("trouble") then
        require("trouble").next({ skip_groups = true, jump = true })
    else
        local n = vim.v.hlsearch
        if n == 0 then
            require("illuminate").goto_next_reference(true)
        else
            local mode = _G.searchmode
            if mode == "/" then
                vim.cmd("normal! n")
            else
                vim.cmd("normal! N")
            end
        end
    end
end)

keymap("n", "N", function()
    if #require("illuminate.reference").buf_get_keeped_references(api.nvim_get_current_buf()) > 0 then
        require("illuminate.goto").goto_prev_keeped_reference(true)
        return
    elseif utils.has_filetype("trouble") then
        require("trouble").prev({ skip_groups = true, jump = true })
    else
        local n = vim.v.hlsearch
        if n == 0 then
            require("illuminate").goto_prev_reference(true)
        else
            local mode = _G.searchmode
            if mode ~= "/" then
                vim.cmd("normal! n")
            else
                vim.cmd("normal! N")
            end
        end
    end
end)

keymap({ "s", "n" }, "<esc>", function()
    -- pcall(function()
    api.nvim_exec_autocmds("User", {
        pattern = "ESC",
    })
    local flag = true
    for _, win in pairs(api.nvim_list_wins()) do
        local success, win_config = pcall(api.nvim_win_get_config, win)
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
                api.nvim_win_close(win, true)
            elseif win_config.zindex == 10 then
                FeedKeys("<esc>", "n")
            end
        end
    end
    if flag then
        FeedKeys("<esc>", "n")
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
    local bufnr = api.nvim_get_current_buf()
    pcall(engin.keep_highlight, bufnr)
end)
