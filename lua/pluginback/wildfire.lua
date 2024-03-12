return {
    "sustech-data/wildfire.nvim",
    enabled = false,
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("wildfire").setup({
            -- surrounds = {},
            keymaps = {
                init_selection = "<M-9>",
                node_incremental = "<M-8>",
                node_decremental = "<C-d>",
            },
            filetype_exclude = { "qf" }, --keymaps will be unset in excluding filetypes
        })
    end,
}
