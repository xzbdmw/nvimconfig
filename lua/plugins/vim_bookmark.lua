return {
    {
        "MattesGroeger/vim-bookmarks",
        event = "VeryLazy",
        config = function()
            vim.g.bookmark_sign = ""
            vim.g.bookmark_save_per_working_dir = 1
            vim.g.bookmark_center = 1
        end,
    },
    {
        "kdnk/bookmarks-cycle-through.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = {
            "MattesGroeger/vim-bookmarks",
        },
        lazy = false,
        config = function()
            vim.keymap.set("n", "mm", function()
                require("bookmarks-cycle-through").bookmark_toggle()
            end)
            vim.keymap.set("n", "mn", function()
                require("bookmarks-cycle-through").cycle_through({ reverse = false })
            end)
            vim.keymap.set("n", "mp", function()
                require("bookmarks-cycle-through").cycle_through({ reverse = true })
            end)
        end,
    },
    {
        "xzbdmw/telescope-vim-bookmarks.nvim",
        event = "VeryLazy",
        -- enabled = false,
        config = function()
            require("telescope").load_extension("vim_bookmarks")
        end,
    },
}
