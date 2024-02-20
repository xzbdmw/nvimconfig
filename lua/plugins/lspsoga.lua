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
                -- filter = {
                --     ["textDocument/references"] = function(client_id)
                --         local a = 5
                --         print(a)
                --         print(a)
                --         print(vim.inspect(client_id))
                --         -- print(vim.inspect(v))
                --         -- return false
                --         return true
                --         -- local lnum = vim.api.nvim_win_get_cursor(0)[1]
                --         -- print(lnum)
                --         -- local filepath = vim.api.nvim_buf_get_name(0)
                --         -- return not (v.filename == filepath and v.lnum == lnum)
                --     end,
                -- },
                filter = {
                    ["textDocument/references"] = function(item)
                        local lnum = vim.api.nvim_win_get_cursor(0)[1]
                        local filepath = vim.api.nvim_buf_get_name(0)
                        print(filepath)
                        -- print(vim.inspect(item))
                        -- local results =
                        --     vim.lsp.util.locations_to_items(item, vim.lsp.get_client_by_id(0).offset_encoding)
                        -- locations = vim.tbl_filter(function(v)
                        --     -- Remove current line from result
                        --     return not (v.uri == filepath and v.range.start.line == lnum)
                        -- end, vim.F.if_nil(item, {}))
                        -- print(vim.inspect(locations))
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
