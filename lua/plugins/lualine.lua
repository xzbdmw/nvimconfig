return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = false,
                theme = "auto",
                component_separators = { left = "", right = "" },
                section_separators = { left = " ", right = " " },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
                extensions = { "nvim-tree" },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
            },
        })
    end,
}
