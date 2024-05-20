return {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    config = function()
        require("spider").setup({
            skipInsignificantPunctuation = false,
            subwordMovement = true,
            customPatterns = {}, -- check Custom Movement Patterns for details
        })
        vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
        vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
        vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
    end,
}
