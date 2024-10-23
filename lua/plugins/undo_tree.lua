return {
    lazy = false,
    keys = {
        {
            "<leader>un",
            function()
                vim.cmd("Ut")
                FeedKeys("<c-w>l", "n")
            end,
        },
    },
    "mbbill/undotree",
    config = function()
        vim.g.undotree_WindowLayout = 3
    end,
}
