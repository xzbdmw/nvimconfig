return {
    "smjonas/inc-rename.nvim",
    event = "VeryLazy",
    keys = {
        { "<leader>cr", ":IncRename " },
        {
            "r",
            function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "x", true)
                return ":IncRename "
            end,
            expr = true,
            mode = { "x" },
        },
    },

    config = function()
        require("inc_rename").setup({
            -- cmd_name = "Rename",
        })
    end,
}
