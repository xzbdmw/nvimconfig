keymap("n", "<C-f>", "<cmd>NvimTreeFocus<CR>")
keymap({ "n" }, "<leader>fn", '<cmd>lua require("nvim-tree.api").fs.create()<CR>', { desc = "create new file" })

keymap({ "s", "i", "n" }, "<C-7>", function()
    print(get_float_win_count())
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                print(vim.inspect(win))
                print(vim.inspect(win_config))
                vim.api.nvim_win_close(win, true)
            end
        end
    end
end)

-- keymap("i", "h", function()
--     _G.start_ttt = vim.uv.hrtime()
--     return "h"
-- end, { expr = true })
