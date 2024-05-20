return {
    "nvimdev/lspsaga.nvim",
    -- event = "LspAttach",
    commit = "2198c07124bef27ef81335be511c8abfd75db933",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        {
            "<C-e>",
            "<cmd>Lspsaga diagnostic_jump_next<CR>",
            mode = { "n", "i" },
        },
        {
            "<leader>ca",
            function()
                -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>ca", true, false, true), "t", true)
                vim.cmd("Lspsaga code_action")
            end,
            mode = { "n", "v" },
            desc = "Code Action",
        },
        {
            "<C-cr>",
            function()
                -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>ca", true, false, true), "t", true)
                local origin = vim.o.eventignore
                vim.o.eventignore = "all"
                vim.cmd([[:stopinsert]])
                vim.cmd("Lspsaga code_action")
                vim.o.eventignore = origin
            end,
            desc = "Code Action",
            mode = { "n", "v" },
        },
    },
    config = function()
        require("lspsaga").setup({
            finder = {
                enable = false,
                --[[ filter = {
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
                }, ]]
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
                extend_gitsigns = true,
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
