return {
    "linux-cultist/venv-selector.nvim",
    commit = "d946b1e86212f38ff9c42e3b622a8178bbc93461",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
        anaconda_base_path = "/opt/homebrew/Caskroom/miniconda/base",
        anaconda_envs_path = "/opt/homebrew/Caskroom/miniconda/base/envs",
    },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    -- keys = {
    --     -- Keymap to open VenvSelector to pick a venv.
    --     { "<leader>vs", "<cmd>VenvSelect<cr>" },
    --     -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    --     { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    -- },
}
