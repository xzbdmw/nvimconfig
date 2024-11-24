return {
    "nvimdev/lspsaga.nvim",
    cmd = { "LspSaga code_action" },
    -- event = "LspAttach",
    commit = "2198c07124bef27ef81335be511c8abfd75db933",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        {
            "<leader>ca",
            function()
                vim.cmd("Lspsaga code_action")
            end,
            mode = { "n", "v" },
            desc = "Code Action",
        },
    },
    config = function()
        require("lspsaga").setup({
            finder = {
                enable = false,
                left_width = 0.3,
                layout = "float",
                default = "ref",
                silent = true,
                keys = {
                    vsplit = "v",
                    shuttle = "<C-;>",
                    toggle_or_open = "<CR>",
                },
            },
            hover = {
                max_width = 0.3,
                max_height = 0.4,
            },
            symbol_in_winbar = {
                enable = false,
            },
            ui = {
                width = 1,
                lines = { "└", "├", "│", "─", "┌" },
            },
            beacon = {
                enable = false,
                frequency = 14,
            },
            code_action = {
                extend_gitsigns = false,
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
                enable = false,
                layout = "normal",
            },
        })
    end,
}
