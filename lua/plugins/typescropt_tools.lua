return {
    enabled = false,
    "pmizio/typescript-tools.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
        tsserver_plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/Users/xzb/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server",
                languages = { "javascript", "typescript", "vue" },
            },
        },
        filetypes = {
            "javascript",
            "typescript",
            "typescriptreact",
            "vue",
        },
        settings = {
            complete_function_calls = true,
        },
    },
}
