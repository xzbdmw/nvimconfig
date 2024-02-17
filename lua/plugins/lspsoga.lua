return {
    "xzbdmw/lspsaga.nvim",
    event = "LspAttach",
    commit = "766e67ab3db45ddc11c3142132fbe1220cfeca14",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lspsaga").setup({
            finder = {
                -- max_height = 0.8,
                left_width = 0.3,
                -- right_width = 0.3,
                default = "ref",
                silent = true,
                keys = {
                    vsplit = "v",
                    shuttle = "<C-;>",
                    toggle_or_open = "<CR>",
                },
            },
            symbol_in_winbar = {
                enable = false,
            },
            ui = {
                lines = { "└", "├", "│", "─", "┌" },
            },
            beacon = {
                enable = false,
                frequency = 14,
            },
            implement = {
                enable = false,
                sign = true,
                virtual_text = true,
                priority = 1000,
            },
            lightbulb = {
                enable = false,
                sign = false,
                virtual_text = true,
            },
            outline = {
                layout = "float",
            },
        })
    end,
}
