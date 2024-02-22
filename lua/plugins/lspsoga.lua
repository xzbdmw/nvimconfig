return {
    "nvimdev/lspsaga.nvim",
    enabled = false,
    event = "LspAttach",
    commit = "2198c07124bef27ef81335be511c8abfd75db933",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lspsaga").setup({
            finder = {
                filter = {
                    ["textDocument/references"] = function(item)
                        local lnum = vim.api.nvim_win_get_cursor(0)[1]
                        local filepath = vim.api.nvim_buf_get_name(0)
                        print(filepath)
                        local a = 5
                        print(a)
                        print(a)
                        return item
                        --item now is list-like table .
                    end,
                },
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
                layout = "normal",
            },
        })
    end,
}
