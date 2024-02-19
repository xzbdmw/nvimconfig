return {
    "notjedi/nvim-rooter.lua",
    config = function()
        require("nvim-rooter").setup({
            rooter_patterns = { ".git", ".hg", ".svn", "Cargo.toml" },
            trigger_patterns = { "*" },
            manual = true,
            fallback_to_parent = false,
        })
    end,
}
