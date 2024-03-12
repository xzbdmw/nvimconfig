return {
    enabled = false,
    "pmizio/typescript-tools.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
        tsserver_plugins = {
            "@vue/typescript-plugin",
        },
        filetypes = {
            "javascript",
            "typescript",
            "vue",
        },
        settings = {
            complete_function_calls = true,
        },
    },
}
