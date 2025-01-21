return {
    "wurli/contextindent.nvim",
    -- This is the only config option; you can use it to restrict the files
    -- which this plugin will affect (see :help autocommand-pattern).
    ft = "markdown",
    opts = { pattern = "*.markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
}
