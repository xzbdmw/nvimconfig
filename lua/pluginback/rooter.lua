return {
    "notjedi/nvim-rooter.lua",
    enabled = false,
    config = function()
        require("nvim-rooter").setup({
            rooter_patterns = { ".git", ".hg", ".svn", "Cargo.toml", "=karabiner" },
            trigger_patterns = { "*" },
            manual = false,
            fallback_to_parent = false,
        })
        -- vim.keymap.set("n", "<leader><leader>r", "<cmd>Rooter<CR>")
    end,
}
