return {
    "Wansmer/symbol-usage.nvim",
    keys = {
        {
            "<leader>cl",
            function()
                require("symbol-usage").toggle_globally()
                require("symbol-usage").refresh()
            end,
        },
    },
    event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
        require("symbol-usage").setup()
    end,
}
