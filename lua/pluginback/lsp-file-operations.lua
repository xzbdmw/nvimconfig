return {
    "antosha417/nvim-lsp-file-operations",
    enabled = false,
    event = "veryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-tree.lua",
    },
    config = function()
        require("lsp-file-operations").setup()
    end,
}
