return {
    "norcalli/nvim-colorizer.lua",
    -- dir = "/Users/xzb/.local/share/nvim/lazy/nvim-colorizer",
    event = "VeryLazy",
    enabled = false,
    config = function()
        require("colorizer").setup()
    end,
}
