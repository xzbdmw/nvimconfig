return {
    "nvim-treesitter/nvim-treesitter-context",
    keys = {
        {
            "gs",
            function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end,
            desc = "go to sticky scroll",
        },
    },
    opts = {
        line_numbers = true,
    },
}
