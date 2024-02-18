return {
    "otavioschwanck/arrow.nvim",
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
        show_icons = true,
        leader_key = ";", -- Recommended to be a single key
        hide_handbook = true,
        window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
            width = "auto",
            height = "auto",
            row = 10,
            col = "auto",
            border = "rounded",
        },
    },
}
