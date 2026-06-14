return {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig", { "xzbdmw/telescope.nvim", name = "telescope.nvim", branch = "lock-e6f1cbd66486" } },
    opts = {
        cached_venv_automatic_activation = true,
    },
    ft = { "python" },
}
