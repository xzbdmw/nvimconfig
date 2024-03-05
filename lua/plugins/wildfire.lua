return {
    "sustech-data/wildfire.nvim",
    enabled = false,
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("wildfire").setup()
    end,
}
