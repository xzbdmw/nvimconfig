local selection_mode = false
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:s",
    callback = function()
        if selection_mode == false then
            vim.api.nvim_set_hl(0, "Visual", { bg = "#375D7C" })
            selection_mode = true
        end
    end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:v",
    callback = function()
        if selection_mode then
            vim.api.nvim_set_hl(0, "Visual", { bg = "#304E75" })
            selection_mode = false
        end
    end,
})

local keymap = vim.keymap.set
-- illuminate
keymap("n", "H", function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_hl(0, "illuminatedWordRead", { fg = "#ffffff", bg = "#304E75" })
    vim.api.nvim_set_hl(0, "illuminatedWordText", { fg = "#ffffff", bg = "#304E75" })
    vim.api.nvim_set_hl(0, "illuminatedWordwrite", { fg = "#ffffff", bg = "#304E75" })

    keymap("n", "n", function()
        require("illuminate").goto_next_reference()
    end, { buffer = bufnr })
    keymap("n", "N", function()
        require("illuminate").goto_prev_reference()
    end, { buffer = bufnr })
    keymap("n", "<esc>", function()
        -- vim.api.nvim_buf_del_keymap(bufnr, "n", "<esc>")
        vim.api.nvim_buf_del_keymap(bufnr, "n", "n")
        vim.api.nvim_buf_del_keymap(bufnr, "n", "N")
        vim.api.nvim_set_hl(0, "illuminatedWordRead", { bg = "#32354A" })
        vim.api.nvim_set_hl(0, "illuminatedWordText", { bg = "#32354A" })
        vim.api.nvim_set_hl(0, "illuminatedWordwrite", { bg = "#253C59" })
        Set_esc_keymap()
        require("illuminate").unfreeze_buf()
        require("illuminate.highlight").buf_clear_references(bufnr)
        require("illuminate.engine").refresh_references()
    end)
    require("illuminate").freeze_buf()
end)
