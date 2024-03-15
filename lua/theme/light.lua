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
    require("illuminate.engine").keep_highlight()
    local bufnr = vim.api.nvim_get_current_buf()
    keymap("n", "n", function()
        require("illuminate.goto").goto_next_keepd_reference(true)
    end, { buffer = bufnr })
    keymap("n", "N", function()
        require("illuminate.goto").goto_prev_keepd_reference(true)
    end, { buffer = bufnr })
    keymap("n", "<esc>", function()
        vim.api.nvim_buf_del_keymap(bufnr, "n", "n")
        vim.api.nvim_buf_del_keymap(bufnr, "n", "N")
        Set_esc_keymap()
        require("illuminate.engine").clear_keeped_highlight()
        require("illuminate.engine").refresh_references()
    end)
end)
