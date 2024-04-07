return {
    -- "otavioschwanck/arrow.nvim",
    -- commit = "f3d8470580ecbd5778a68091eca8d5da304f2e2a",
    dir = "/Users/xzb/Project/lua/arrow.nvim/",
    -- enabled = fa
    -- event = "VeryLazy",
    lazy = false,
    keys = {
        {
            "H",
            function()
                require("arrow.persist").previous()
            end,
        },
        {
            "L",
            function()
                require("arrow.persist").next()
            end,
        },
    },

    opts = {
        per_buffer_config = {
            lines = 6,
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
}
