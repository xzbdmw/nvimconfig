return {
    "ojroques/nvim-bufdel",
    config = function()
        require("bufdel").setup({
            next = "cycle",
            quit = false, -- quit Neovim when last buffer is closed
        })
        vim.keymap.set("n", "<space>D", "<cmd>BufDelOthers<CR>")
    end,
}
