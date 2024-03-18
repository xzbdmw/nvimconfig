local selection_mode = false
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:s",
    callback = function()
        if selection_mode == false then
            vim.api.nvim_set_hl(0, "Visual", { bg = "#BEC4C2" })
            selection_mode = true
        end
    end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:v",
    callback = function()
        if selection_mode then
            vim.api.nvim_set_hl(0, "Visual", { bg = "#d0d8d8" })
            selection_mode = false
        end
    end,
})

local keymap = vim.keymap.set
keymap("n", "n", function()
    require("illuminate.goto").goto_next_keepd_reference(true)
end)
keymap("n", "N", function()
    require("illuminate.goto").goto_prev_keepd_reference(true)
end)
keymap({ "s", "i", "n" }, "<esc>", function()
    local flag = true
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if
                win_config.relative ~= "" and win_config.zindex == 45
                or win_config.zindex == 44
                or win_config.zindex == 46
                or win_config.zindex == 47
                or win_config.zindex == 50
                or win_config.zindex == 80
            then
                flag = false
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
    require("illuminate.engine").clear_keeped_highlight()
    require("illuminate.engine").refresh_references()
end)

-- illuminate
keymap("n", "H", function()
    local bufnr = vim.api.nvim_get_current_buf()
    require("illuminate.engine").keep_highlight(bufnr)
end)
