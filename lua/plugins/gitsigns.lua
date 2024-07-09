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
            signs_staged = {
                add = { text = "" },
                change = { text = "" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "" },
                untracked = { text = "" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
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
                    gs.nav_hunk("next", { target = "unstaged" })
                    vim.cmd("norm! zz")
                end)

                map("n", "[c", function()
                    gs.nav_hunk("prev", { target = "unstaged" })
                    vim.cmd("norm! zz")
                end)

                map("n", "]s", function()
                    gs.nav_hunk("next", { target = "staged" })
                    vim.cmd("norm! zz")
                end)

                map("n", "[s", function()
                    gs.nav_hunk("prev", { target = "staged" })
                    vim.cmd("norm! zz")
                end)

                map("n", "<leader>rh", function()
                    gs.reset_hunk()
                end)

                map("n", "<leader>sb", function()
                    gs.stage_buffer()
                end)

                map("n", "<leader>ub", function()
                    gs.reset_buffer_index()
                end)

                map("n", "<leader>rb", function()
                    gs.reset_buffer()
                end)

                local update_hunk_qflist = function()
                    if require("trouble").is_open("qflist") then
                        if _G.pre_gitsigns_qf_operation == "all" then
                            vim.defer_fn(function()
                                FeedKeys("<leader>aq", "m")
                            end, 200)
                        elseif _G.pre_gitsigns_qf_operation == "cur" then
                            vim.defer_fn(function()
                                FeedKeys("<leader>sq", "m")
                            end, 200)
                        end
                    end
                end

                map("v", "<leader>sh", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    update_hunk_qflist()
                end)

                map("n", "<leader>sh", function()
                    vim.cmd("Gitsigns stage_hunk")
                    update_hunk_qflist()
                end)

                map("n", "<leader>uh", function()
                    vim.cmd("Gitsigns undo_stage_hunk")
                end)

                map("n", "<leader>bb", function()
                    if require("config.utils").has_filetype("gitsigns.blame") then
                        FeedKeys("<Tab>q<d-1><tab>", "m")
                        return
                    end
                    if require("config.utils").has_filetype("NvimTree") then
                        require("nvim-tree.api").tree.toggle({ focus = false })
                    end
                    vim.cmd("Gitsigns blame")
                end)

                map("n", "<leader>sq", function()
                    _G.pre_gitsigns_qf_operation = "cur"
                    vim.cmd("Gitsigns setqflist")
                    api.nvim_create_autocmd("WinResized", {
                        once = true,
                        callback = vim.schedule_wrap(function()
                            FeedKeys("n", "t")
                        end),
                    })
                end)
                map("n", "<leader>aq", function()
                    _G.pre_gitsigns_qf_operation = "all"
                    gs.setqflist("all")
                    api.nvim_create_autocmd("WinResized", {
                        once = true,
                        callback = vim.schedule_wrap(function()
                            FeedKeys("n", "t")
                        end),
                    })
                end)

                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
            auto_attach = true,
            attach_to_untracked = true,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 1,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            -- current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            current_line_blame_formatter = "    <author> <author_time:%Y-%m-%d> - <summary>",
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
        })
        vim.keymap.set("n", "<leader><leader>b", "<cmd>Gitsigns toggle_current_line_blame<CR>")
        vim.keymap.set("n", "<leader>sp", "<cmd>Gitsigns preview_hunk_inline<CR>")
        vim.keymap.set("n", "<leader>cb", function()
            vim.g.Base_commit = ""
            vim.g.Base_commit_msg = ""
            require("gitsigns").reset_base(vim.g.Base_commit, true)
        end)
    end,
}
