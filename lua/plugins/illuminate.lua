return {
    "RRethy/vim-illuminate",
    keys = {
        { "<a-p>", false },
    },
    opts = {
        providers = {
            "lsp",
            -- "treesitter",
            "regex",
        },
        filetypes_denylist = {
            "help",
            "Glance",
            "fugitive",
        },
        delay = 1,
        under_cursor = true,
        min_count_to_highlight = 1,
        -- large_file_cutoff = 2000,
        large_file_overrides = nil,
        modes_denylist = { "i", "v", "x" },
    },
    config = function(_, opts)
        require("illuminate").configure(opts)
    end,
}
