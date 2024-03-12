return {
    enabled = false,
    "chrisgrieser/nvim-origami",
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = true, -- needed even when using default config
    config = function()
        require("origami").setup({
            keepFoldsAcrossSessions = true,
            pauseFoldsOnSearch = true,
            setupFoldKeymaps = false,
        })
    end,
}
