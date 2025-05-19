return {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
        cached_venv_automatic_activation = true,
    },
    ft = { "python" },
}
