return {
    "mrjones2014/smart-splits.nvim",
    keys = {
        {
            "<C-->",
            function()
                require("smart-splits").resize_left()
            end,
            mode = { "n", "i" },
        },
        {
            "<C-=>",
            function()
                require("smart-splits").resize_right()
            end,
            mode = { "n", "i" },
        },
    },
    config = function()
        require("smart-splits").setup({
            -- Ignored filetypes (only while resizing)
            ignored_filetypes = {
                "nofile",
                "quickfix",
                "prompt",
            },
            -- Ignored buffer types (only while resizing)
            ignored_buftypes = { "NvimTree" },
            -- the default number of lines/columns to resize by at a time
            default_amount = 6,
            at_edge = "wrap",
        })
    end,
}
