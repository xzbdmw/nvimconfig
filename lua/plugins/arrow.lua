return {
    -- "otavioschwanck/arrow.nvim",
    -- commit = "f3d8470580ecbd5778a68091eca8d5da304f2e2a",
    dir = "/Users/xzb/Project/lua/arrow.nvim/",
    -- enabled = fa
    -- event = "VeryLazy",
    lazy = false,
    opts = {
        per_buffer_config = {
            sort_automatically = true,
            treesitter_context = {
                line_shift_down = 1,
            },
            lines = 7,
        },
        buffer_leader_key = "'",
        show_icons = true,
        leader_key = ";", -- Recommended to be a single key
        -- index_keys = "123jklafghAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
        hide_handbook = true,
        window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
            width = "auto",
            height = "auto",
            row = 10,
            col = 65,
            border = "none",
        },
    },
    config = function(_, opts)
        require("arrow").setup(opts)
        vim.keymap.set("n", "mn", "<cmd>Arrow next_buffer_bookmark<CR>")
        vim.keymap.set("n", "mp", "<cmd>Arrow prev_buffer_bookmark<CR>")
    end,
}
