return {
    "otavioschwanck/arrow.nvim",
    commit = "ffad9340a82646d538b99070e2b5ffeb2b20bba7",
    event = "VeryLazy",
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
        show_icons = true,
        leader_key = ";", -- Recommended to be a single key
        -- index_keys = "jklafghAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
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
