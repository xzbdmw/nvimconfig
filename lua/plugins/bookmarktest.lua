return {
    "xzbdmw/bookmarktest",
    enabled = false,
    dependencies = {
        "SmiteshP/nvim-navic",
    },
    config = function()
        require("bookmarktest").setup()
    end,
}
