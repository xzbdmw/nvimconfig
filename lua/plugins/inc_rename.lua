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
            preview_empty_name = true,
            po = function(results)
                -- __AUTO_GENERATED_PRINT_VAR_START__
                print([==[function#function results:]==], vim.inspect(results)) -- __AUTO_GENERATED_PRINT_VAR_END__
            end,
            -- cmd_name = "Rename",
        })
    end,
}
