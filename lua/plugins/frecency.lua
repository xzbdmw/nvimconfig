return {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
        require("telescope").load_extension("frecency")
    end,
}
