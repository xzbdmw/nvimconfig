local selection_mode = false
api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:s",
    callback = function()
        if selection_mode == false then
            api.nvim_set_hl(0, "Visual", { bg = "#375D7C" })
            selection_mode = true
        end
    end,
})
api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:v",
    callback = function()
        if selection_mode then
            api.nvim_set_hl(0, "Visual", { bg = "#304E75" })
            selection_mode = false
        end
    end,
})

local keymap = vim.keymap.set
-- illuminate
keymap("n", "H", function()
    local bufnr = api.nvim_get_current_buf()
    api.nvim_set_hl(0, "illuminatedWordRead", { fg = "#ffffff", bg = "#304E75" })
    api.nvim_set_hl(0, "illuminatedWordText", { fg = "#ffffff", bg = "#304E75" })
    api.nvim_set_hl(0, "illuminatedWordwrite", { fg = "#ffffff", bg = "#304E75" })

    keymap("n", "n", function()
        require("illuminate").goto_next_reference()
    end, { buffer = bufnr })
    keymap("n", "N", function()
        require("illuminate").goto_prev_reference()
    end, { buffer = bufnr })
    keymap("n", "<esc>", function()
        -- api.nvim_buf_del_keymap(bufnr, "n", "<esc>")
        api.nvim_buf_del_keymap(bufnr, "n", "n")
        api.nvim_buf_del_keymap(bufnr, "n", "N")
        api.nvim_set_hl(0, "illuminatedWordRead", { bg = "#32354A" })
        api.nvim_set_hl(0, "illuminatedWordText", { bg = "#32354A" })
        api.nvim_set_hl(0, "illuminatedWordwrite", { bg = "#253C59" })
        require("illuminate").unfreeze_buf()
        require("illuminate.highlight").buf_clear_references(bufnr)
        require("illuminate.engine").refresh_references()
    end)
    require("illuminate").freeze_buf()
end)
