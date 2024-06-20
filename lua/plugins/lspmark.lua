return {
    "tristone13th/lspmark.nvim",
    enabled = false,
    config = function()
        require("lspmark").setup()
        require("telescope").load_extension("lspmark")
    end,
}
