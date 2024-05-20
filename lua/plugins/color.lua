return {
    -- "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    dir = "/Users/xzb/.local/share/nvim/lazy/nvim-colorizer",
    enabled = false,
    config = function()
        require("colorizer").setup()
    end,
}
