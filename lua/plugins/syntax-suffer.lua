return {
    "ziontee113/syntax-tree-surfer",
    enabled = false,
    config = function()
        -- Swapping Nodes in Visual Mode
        require("syntax-tree-surfer").setup()
        vim.keymap.set("x", "gnh", "<cmd>STSSwapOrHoldVisual<cr>")
    end,
}
