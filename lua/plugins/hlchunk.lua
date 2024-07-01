return {
    "shellRaining/hlchunk.nvim",
    -- enabled = false,
    -- event = { "UIEnter" },
    event = "VeryLazy",
    config = function()
        require("hlchunk").setup({
            chunk = {
                enable = false,
                notify = true,
                use_treesitter = true,
                -- details about support_filetypes and exclude_filetypes in https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
                chars = {
                    horizontal_line = "─",
                    vertical_line = "│",
                    left_top = "╭",
                    left_bottom = "╰",
                    right_arrow = ">",
                },
                style = {
                    { fg = "#806d9c" },
                    { fg = "#c21f30" },
                },
                textobject = "",
                max_file_size = 1024 * 1024,
                error_sign = true,
            },

            indent = {
                enable = true,
                use_treesitter = false,
                chars = {
                    "│",
                },
                style = {
                    { fg = "#EDEDED" },
                    -- { fg = "#6B7088" },
                },
            },

            line_num = {
                enable = false,
                use_treesitter = false,
                style = "#806d9c",
            },

            blank = {
                enable = false,
                chars = {
                    "․",
                },
                style = {
                    vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
                },
            },
        })

        -- vim.cmd("DisableHL")
    end,
}
