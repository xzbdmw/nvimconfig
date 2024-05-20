return {
    "ojroques/nvim-bufdel",
    config = function()
        local function isBufferInCwd(bufinfo)
            local filePath = vim.fn.expand("#" .. bufinfo.bufnr .. ":p")
            return vim.startswith(filePath, cwd)
        end
        require("bufdel").setup({
            quit = false, -- quit Neovim when last buffer is closed
            next = "alternate",
        })
        vim.keymap.set("n", "<leader>D", "<cmd>BufDelOthers<CR>")
    end,
}
