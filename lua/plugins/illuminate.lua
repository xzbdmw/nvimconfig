return {
    dir = "~/Project/lua/vim-illuminate/",
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
            "json",
            "jsonl",
            "help",
            "markdown",
            "vim",
            "txt",
            "text",
            "Glance",
            "snacks_picker_input",
            "fugitive",
            "aerial",
            "toggleterm",
            "TelescopeResults",
        },
        -- delay = 90,
        delay = 1,
        under_cursor = true,
        min_count_to_highlight = 1,
        large_file_cutoff = 20000,
        large_file_overrides = nil,
        modes_denylist = { "i", "v", "x" },
    },
    config = function(_, opts)
        require("illuminate").configure(opts)
    end,
}
