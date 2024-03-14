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
-- illuminate
keymap("n", "H", function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_hl(0, "illuminatedWordRead", { bg = "#FCF0A1" })
    vim.api.nvim_set_hl(0, "illuminatedWordText", { bg = "#FCF0A1" })
    vim.api.nvim_set_hl(0, "illuminatedWordwrite", { bg = "#CCE2E2" })
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
        vim.api.nvim_set_hl(0, "illuminatedWordRead", { bg = "#D2D0D0" })
        vim.api.nvim_set_hl(0, "illuminatedWordText", { bg = "#D2D0D0" })
        vim.api.nvim_set_hl(0, "illuminatedWordwrite", { bg = "#d0d8d8" })
        Set_esc_keymap()
        require("illuminate").unfreeze_buf()
        require("illuminate.highlight").buf_clear_references(bufnr)
        require("illuminate.engine").refresh_references()
    end)
    require("illuminate").freeze_buf()
end)
