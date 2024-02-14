return {
    "ThePrimeagen/harpoon",
    keys = {
        {
            "<space>ha",
            function()
                require("harpoon.mark").add_file()
            end,
        },
        {
            "<space>hl",
            function()
                require("harpoon.ui").toggle_quick_menu()
            end,
        },
        {
            "<space>hn",
            function()
                require("harpoon.ui").nav_next()
            end,
        },
        {
            "<space>hp",
            function()
                require("harpoon.ui").nav_prev()
            end,
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
}
