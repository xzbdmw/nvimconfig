local utils = require("config.utils")
local keymap = vim.keymap.set

keymap("n", "n", function()
    if vim.v.hlsearch ~= 0 then
        local mode = _G.searchmode
        if mode == "/" then
            vim.cmd("normal! n")
            vim.cmd("normal z")
        else
            vim.cmd("normal! N")
            vim.cmd("normal z")
        end
        local event = require("hlslens.lib.event")
        event:emit("RegionChanged")
        return
    end
    if #require("illuminate.reference").buf_get_keeped_references(api.nvim_get_current_buf()) > 0 then
        require("illuminate.goto").goto_next_keeped_reference(true)
        return
    elseif utils.has_filetype("trouble") then
        require("trouble").main_next({ skip_groups = true, jump = true })
    elseif utils.has_filetype("qf") then
        FeedKeys("]q", "m")
    elseif require("config.utils").has_namespace("gitsigns_signs_", "highlight") then
        FeedKeys("]c", "m")
    else
        require("illuminate").goto_next_reference(true)
    end
end)

keymap("n", "N", function()
    if vim.v.hlsearch ~= 0 then
        local mode = _G.searchmode
        if mode ~= "/" then
            vim.cmd("normal! n")
            vim.cmd("normal z")
        else
            vim.cmd("normal! N")
            vim.cmd("normal z")
        end
        local event = require("hlslens.lib.event")
        event:emit("RegionChanged")
        return
    end
    if #require("illuminate.reference").buf_get_keeped_references(api.nvim_get_current_buf()) > 0 then
        require("illuminate.goto").goto_prev_keeped_reference(true)
        return
    elseif utils.has_filetype("trouble") then
        require("trouble").main_prev({ skip_groups = true, jump = true })
    elseif utils.has_filetype("qf") then
        FeedKeys("[q", "m")
    elseif require("config.utils").has_namespace("gitsigns_signs_", "highlight") then
        FeedKeys("[c", "m")
    else
        require("illuminate").goto_prev_reference(true)
    end
end)

keymap("n", "]h", function()
    if #require("illuminate.reference").buf_get_keeped_references(api.nvim_get_current_buf()) > 0 then
        require("illuminate.goto").goto_next_keeped_reference(true)
        vim.cmd("normal z")
    end
end)

keymap("n", "[h", function()
    if #require("illuminate.reference").buf_get_keeped_references(api.nvim_get_current_buf()) > 0 then
        require("illuminate.goto").goto_prev_keeped_reference(true)
        vim.cmd("normal z")
    end
end)

keymap("n", "]q", function()
    if utils.has_filetype("trouble") then
        require("trouble").main_next({ skip_groups = true, jump = true })
    else
        vim.cmd("cnext")
    end
end)

keymap("n", "[q", function()
    if utils.has_filetype("trouble") then
        require("trouble").main_prev({ skip_groups = true, jump = true })
    else
        vim.cmd("cprev")
    end
end)

keymap("n", "]s", function()
    vim.cmd("normal! n")
    vim.cmd("normal z")
end)

keymap("n", "[s", function()
    vim.cmd("normal! N")
    vim.cmd("normal z")
end)
keymap({ "n" }, "<esc>", function()
    if not require("multicursor-nvim").cursorsEnabled() then
        require("multicursor-nvim").enableCursors()
        return
    end
    if vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "" then
        FeedKeys("q", "n")
        return
    end
    if vim.bo.filetype == "toggleterm" then
        vim.cmd("noh")
        vim.b.term_search_title = ""
        utils.refresh_term_title()
        return
    end
    -- lspsaga close diagnose window, gitsigns close inline preview/window
    api.nvim_exec_autocmds("User", {
        pattern = "ESC",
    })
    pcall(function()
        while MiniSnippets.session.get() do
            MiniSnippets.session.stop()
        end
    end)
    pcall(function()
        require("substitute.exchange").cancel()
        require("illuminate.engine").clear_keeped_highlight()
        require("illuminate.goto").clear_keeped_hl()
        require("clever-wrap").clean()
        pcall(_G.indent_update)
    end)

    for _, win in pairs(api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) then
            local win_config = api.nvim_win_get_config(win)
            if win_config.relative ~= "" and vim.list_contains({ 44, 46, 47, 50, 80, 35, 45 }, win_config.zindex) then
                api.nvim_win_close(win, true)
            end
        end
    end

    vim.cmd("noh")
    vim.b.search_winbar = ""
    require("config.utils").refresh_search_winbar()
    vim.api.nvim_exec_autocmds("User", {
        pattern = "ClearSatellite",
    })
end)

-- illuminate
keymap("n", "<left>", function()
    local bufnr = api.nvim_get_current_buf()
    pcall(function()
        require("illuminate.engine").keep_highlight(bufnr)
    end)
    require("config.utils").refresh_search_winbar()
    vim.cmd("redraw!")
    vim.cmd("noh")
    vim.b.term_search_title = ""
    vim.b.search_winbar = ""
    vim.api.nvim_exec_autocmds("User", {
        pattern = "ClearSatellite",
    })
end)
