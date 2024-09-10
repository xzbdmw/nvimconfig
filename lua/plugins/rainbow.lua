return {
    "HiPhish/rainbow-delimiters.nvim",
    keys = {
        {
            "<leader>ur",
            function()
                if vim.b.ranbow_attached then
                    require("rainbow-delimiters").disable(0)
                    vim.b.ranbow_attached = false
                else
                    vim.b.ranbow_attached = true
                    require("rainbow-delimiters").enable(0)
                    vim.api.nvim_exec_autocmds("User", {
                        pattern = "AttachRainBow",
                    })
                end
            end,
        },
    },
    config = function()
        local rainbow_delimiters = require("rainbow-delimiters")
        require("rainbow-delimiters.setup").setup({
            strategy = {
                [""] = rainbow_delimiters.strategy["global"],
                vim = rainbow_delimiters.strategy["local"],
            },
            query = {
                [""] = "rainbow-delimiters",
                -- lua = "rainbow-blocks",
            },
            priority = {
                [""] = 110,
                -- lua = 210,
            },
            highlight = {
                "RainbowDelimiterRed",
                "RainbowDelimiterYellow",
                "RainbowDelimiterBlue",
                "RainbowDelimiterOrange",
                "RainbowDelimiterGreen",
                "RainbowDelimiterViolet",
                "RainbowDelimiterCyan",
            },
        })
    end,
}
