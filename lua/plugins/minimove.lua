return {
    "echasnovski/mini.move",
    keys = {
        {
            "<up>",
            mode = { "n", "x" },
        },
        {
            "<down>",
            mode = { "n", "x" },
        },
    },
    config = function()
        require("mini.move").setup({
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                left = "",
                right = "",
                down = "<down>",
                up = "<up>",

                -- Move current line in Normal mode
                line_left = "",
                line_right = "",
                line_down = "<down>",
                line_up = "<up>",
            },

            -- Options which control moving behavior
            options = {
                -- Automatically reindent selection during linewise vertical move
                reindent_linewise = true,
            },
        })
    end,
}
