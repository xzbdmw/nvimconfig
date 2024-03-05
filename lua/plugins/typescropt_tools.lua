return {
    enabled = false,
    "pmizio/typescript-tools.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
        settings = {
            complete_function_calls = true,
        },
    },
}
