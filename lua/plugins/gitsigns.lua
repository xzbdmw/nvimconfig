return {
    "lewis6991/gitsigns.nvim",
    -- enabled = false,
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    gs.next_hunk()
                end)

                map("n", "[c", function()
                    gs.prev_hunk()
                end)

                -- -- Actions
                -- map("n", "<leader>hs", gs.stage_hunk)
                -- map("n", "<leader>hr", gs.reset_hunk)
                -- map("v", "<leader>hs", function()
                --     gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                -- end)
                -- map("v", "<leader>hr", function()
                --     gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                -- end)
                -- map("n", "<leader>hS", gs.stage_buffer)
                -- map("n", "<leader>hu", gs.undo_stage_hunk)
                -- map("n", "<leader>hR", gs.reset_buffer)
                -- map("n", "<leader>hp", gs.preview_hunk)
                -- map("n", "<leader>hb", function()
                --     gs.blame_line({ full = true })
                -- end)
                map("n", "<leader>ug", gs.toggle_current_line_blame)
                -- map("n", "<leader>hd", gs.diffthis)
                -- map("n", "<leader>hD", function()
                --     gs.diffthis("~")
                -- end)
                -- map("n", "<leader>td", gs.toggle_deleted)
                --
                -- -- Text object
                -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 0,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            -- current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            current_line_blame_formatter = "      <author_time:%Y-%m-%d> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = "none",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            yadm = {
                enable = false,
            },
        })
    end,
}
