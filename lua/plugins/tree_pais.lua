return {
    "yorickpeterse/nvim-tree-pairs",
    lazy = false,
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
