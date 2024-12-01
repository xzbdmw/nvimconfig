local success, engin = pcall(require, "illuminate.engine")
local success, ref = pcall(require, "illuminate.reference")
local success, go = pcall(require, "illuminate.goto")
local utils = require("config.utils")
_G.minidiff = false
local ns = api.nvim_create_namespace("MiniDiffOverlay")
local keymap = vim.keymap.set

keymap("n", "n", function()
    if vim.v.hlsearch ~= 0 then
        local mode = _G.searchmode
        if mode == "/" then
            vim.cmd("normal! n")
            vim.cmd("normal zz")
        else
            vim.cmd("normal! N")
            vim.cmd("normal zz")
        end
        local event = require("hlslens.lib.event")
        event:emit("RegionChanged")
        return
    end
    if #require("illuminate.reference").buf_get_keeped_references(api.nvim_get_current_buf()) > 0 then
        require("illuminate.goto").goto_next_keeped_reference(true)
        vim.cmd("normal zz")
        return
    elseif utils.has_filetype("trouble") then
        require("trouble").main_next({ skip_groups = true, jump = true })
    elseif require("config.utils").has_namespace("gitsigns_signs_", "highlight") then
        FeedKeys("]c", "m")
    else
        require("illuminate").goto_next_reference(true)
        vim.cmd("normal zz")
    end
end)

keymap("n", "N", function()
    if vim.v.hlsearch ~= 0 then
        local mode = _G.searchmode
        if mode ~= "/" then
            vim.cmd("normal! n")
            vim.cmd("normal zz")
        else
            vim.cmd("normal! N")
            vim.cmd("normal zz")
        end
        local event = require("hlslens.lib.event")
        event:emit("RegionChanged")
        return
    end
    if #require("illuminate.reference").buf_get_keeped_references(api.nvim_get_current_buf()) > 0 then
        require("illuminate.goto").goto_prev_keeped_reference(true)
        vim.cmd("normal zz")
        return
    elseif utils.has_filetype("trouble") then
        require("trouble").main_prev({ skip_groups = true, jump = true })
    elseif require("config.utils").has_namespace("gitsigns_signs_", "highlight") then
        FeedKeys("[c", "m")
    else
        require("illuminate").goto_prev_reference(true)
        vim.cmd("normal zz")
    end
end)

keymap({ "n" }, "<esc>", function()
    api.nvim_exec_autocmds("User", {
        pattern = "ESC",
    })
    local luasnip = require("luasnip")
    if luasnip.jumpable(1) or luasnip.jumpable(-1) then
        luasnip.unlink_current()
    end
    require("substitute.exchange").cancel()
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
    if success then
        engin.clear_keeped_highlight()
        go.clear_keeped_hl()
    end
    if flag then
        FeedKeys("<esc>", "n")
        vim.cmd("noh")
        vim.b.search_winbar = ""
        require("config.utils").refresh_search_winbar()
        vim.api.nvim_exec_autocmds("User", {
            pattern = "ClearSatellite",
        })
    end
end)

-- illuminate
keymap("n", "H", function()
    local bufnr = api.nvim_get_current_buf()
    pcall(engin.keep_highlight, bufnr)
    vim.cmd("noh")
    vim.b.search_winbar = ""
    require("config.utils").refresh_search_winbar()
    vim.api.nvim_exec_autocmds("User", {
        pattern = "ClearSatellite",
    })
end)
