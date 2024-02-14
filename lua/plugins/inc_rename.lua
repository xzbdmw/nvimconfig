return {
    "smjonas/inc-rename.nvim",
    lazy = false,
    keys = {
        { "<leader>cr", ":IncRename " },
    },

    config = function()
        require("inc_rename").setup({
            -- cmd_name = "Rename",
        })
    end,
}
