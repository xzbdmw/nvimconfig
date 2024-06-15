return {
    "lewis6991/gitsigns.nvim",
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

                map("n", "<leader>sh", function()
                    vim.cmd("Gitsigns stage_hunk")
                end)
                map("n", "<leader>uh", function()
                    vim.cmd("Gitsigns undo_stage_hunk")
                end)
                map("n", "<leader>sq", function()
                    vim.cmd("Gitsigns setqflist")
                    vim.schedule(function()
                        FeedKeys("n", "t")
                    end)
                end)

                -- map("n", "<leader>hd", gs.diffthis)
                -- map("n", "<leader>hD", function()
                --     gs.diffthis("~")
                -- end)
                -- map("n", "<leader>td", gs.toggle_deleted)
                --
                -- -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 1,
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
        vim.keymap.set("n", "<leader>sb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
        vim.keymap.set("n", "<leader>sp", "<cmd>Gitsigns preview_hunk_inline<CR>")
    end,
}
