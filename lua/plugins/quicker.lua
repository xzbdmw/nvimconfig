return {
    "stevearc/quicker.nvim",
    lazy = false,
    ---@module "quicker"
    config = function()
        require("quicker").setup({
            -- Local options to set for quickfix
            opts = {
                buflisted = false,
                number = false,
                relativenumber = false,
                signcolumn = "auto",
                winfixheight = true,
                wrap = false,
            },
            -- Set to false to disable the default options in `opts`
            use_default_opts = true,
            -- Keymaps to set for the quickfix buffer
            keys = {
                { ">", "<cmd>lua require('quicker').toggle_expand()<CR>", desc = "Expand quickfix content" },
            },
            -- Callback function to run any custom logic or keymaps for the quickfix buffer
            on_qf = function(bufnr) end,
            edit = {
                -- Enable editing the quickfix like a normal buffer
                enabled = true,
                -- Set to true to write buffers after applying edits.
                -- Set to "unmodified" to only write unmodified buffers.
                autosave = false,
            },
            -- Keep the cursor to the right of the filename and lnum columns
            constrain_cursor = true,
            highlight = {
                attach_parser = true,
                -- Use treesitter highlighting
                treesitter = true,
                -- Use LSP semantic token highlighting
                lsp = true,
                -- Load the referenced buffers to apply more accurate highlights (may be slow)
                load_buffers = false,
            },
            follow = {
                -- When quickfix window is open, scroll to closest item to the cursor
                enabled = true,
            },
            -- Map of quickfix item type to icon
            type_icons = {
                E = "󰅚 ",
                W = "󰀪 ",
                I = " ",
                N = " ",
                H = " ",
            },
            -- Border characters
            borders = {
                vert = "│",
                -- Strong headers separate results from different files
                strong_header = "‾",
                strong_cross = "│",
                strong_end = "│",
                -- Soft headers separate results within the same file
                soft_header = "‾",
                soft_cross = "│",
                soft_end = "│",
            },
            -- How to trim the leading whitespace from results. Can be 'all', 'common', or false
            trim_leading_whitespace = false,
            -- Maximum width of the filename column
            max_filename_width = function()
                return 20
            end,
            -- How far the header should extend to the right
            header_length = function(type, start_col)
                return vim.o.columns - start_col
            end,
        })
    end,
}
