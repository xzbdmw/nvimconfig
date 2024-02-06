return {
    "RRethy/vim-illuminate",
    keys = {
        { "<A-p>", false },
    },
    opts = {
        providers = {
            "lsp",
            "treesitter",
            "regex",
        },
        delay = 1,
        large_file_cutoff = 2000,
        large_file_overrides = {
            providers = { "lsp", "treesitter", "regex" },
        },
        modes_denylist = { "i", "v" },
    },
}
