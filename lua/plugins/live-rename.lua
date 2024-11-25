return {
    "saecki/live-rename.nvim",
    keys = {
        {
            "<c-cr>",
            function()
                vim.g.neovide_floating_z_height = 0
                require("live-rename").rename({ insert = true })
            end,
        },
        {
            "r",
            function()
                vim.g.neovide_floating_z_height = 0
                FeedKeys("o<esc><cmd>lua require('live-rename').rename({ insert = true })<CR>", "n")
            end,
            mode = { "x" },
        },
    },
    opts = {
        prepare_rename = false,
    },
}
