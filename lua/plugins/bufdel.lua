return {
    "ojroques/nvim-bufdel",
    config = function()
        require("bufdel").setup({
            quit = false, -- quit Neovim when last buffer is closed
            next = "alternate",
        })
        vim.keymap.set("n", "<leader>D", function()
            local num = 0
            for _, buf in pairs(vim.api.nvim_list_bufs()) do
                if
                    vim.fn.buflisted(buf) == 1
                    and vim.api.nvim_buf_get_name(buf) ~= ""
                    and vim.api.nvim_buf_is_loaded(buf)
                then
                    num = num + 1
                end
            end
            print(string.format("Delete %s buffers", num - 1))
            return "<cmd>BufDelOthers<CR>"
        end, { expr = true })
    end,
}
