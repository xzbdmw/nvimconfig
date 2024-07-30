return {
    "linux-cultist/venv-selector.nvim",
    commit = "5bbc482ca9fa24329c203ca67903802d298a1767",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
        anaconda_base_path = "/opt/homebrew/Caskroom/miniconda/base",
        anaconda_envs_path = "/opt/homebrew/Caskroom/miniconda/base/envs",
    },
    cmd = "VenvSelect",
    -- event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    -- keys = {
    --     -- Keymap to open VenvSelector to pick a venv.
    --     { "<leader>vs", "<cmd>VenvSelect<cr>" },
    --     -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    --     { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    -- },
}
