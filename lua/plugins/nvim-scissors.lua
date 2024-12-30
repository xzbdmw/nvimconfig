return {
    "chrisgrieser/nvim-scissors",
    keys = {
        {
            "S",
            function()
                require("scissors").addNewSnippet()
            end,
            mode = "x",
        },
    },
    dependencies = "nvim-telescope/telescope.nvim",
    config = function()
        require("scissors").setup({
            snippetDir = "~/.config/nvim/snippets/",
            editSnippetPopup = {
                height = 0.4, -- relative to the window, between 0-1
                width = 0.6,
                border = "rounded",
                keymaps = {
                    cancel = "q",
                    saveChanges = "<CR>", -- alternatively, can also use `:w`
                    goBackToSearch = "<BS>",
                    deleteSnippet = "<C-BS>",
                    duplicateSnippet = "<C-d>",
                    openInFile = "<C-o>",
                    insertNextPlaceholder = "<C-p>", -- insert & normal mode
                },
            },
            jsonFormatter = "jq",
            backdrop = {
                enabled = true,
                blend = 50, -- between 0-100
            },
        })
    end,
}
