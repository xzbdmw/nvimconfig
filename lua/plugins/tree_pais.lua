return {
    "yorickpeterse/nvim-tree-pairs",
    lazy = false,
    enabled = false,
    keys = {
        {
            "mm",
            "%",
            remap = true,
        },
    },
    config = function()
        require("tree-pairs").setup()
    end,
}
