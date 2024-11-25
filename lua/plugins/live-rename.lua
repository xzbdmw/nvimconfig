return {
    "saecki/live-rename.nvim",
    keys = {
        {
            "r",
            function()
                vim.g.neovide_floating_z_height = 0
                FeedKeys("o<esc><cmd>lua require('live-rename').rename({ insert = false })<CR>", "n")
            end,
            mode = { "x" },
        },
    },
    opts = {
        prepare_rename = false,
    },
}
