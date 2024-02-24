return {
    "norcalli/nvim-colorizer.lua",
    enabled = false,
    event = "VeryLazy",
    config = function()
        require("colorizer").setup()
    end,
}
