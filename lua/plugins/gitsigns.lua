return {
    "lewis6991/gitsigns.nvim",
    cond = function()
        return not vim.g.scrollback
    end,
    config = function()
        local utils = require("config.utils")
        local config = require("gitsigns.config").config
        local Signs = require("gitsigns.signs")
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
                local function update_auto_commands()
                    api.nvim_exec_autocmds("User", {
                        pattern = "GitSignsUserUpdate",
                    })
                end
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    gs.nav_hunk("next", { target = "unstaged", navigation_message = false })
                    require("config.utils").adjust_view(0, 3)
                end)

                map("n", "[c", function()
                    gs.nav_hunk("prev", { target = "unstaged", navigation_message = false })
                    require("config.utils").adjust_view(0, 3)
                end)

                map("n", "<leader>rh", function()
                    gs.reset_hunk()
                    update_auto_commands()
                end)

                map("n", "<leader>ub", function()
                    gs.reset_buffer_index()
                    update_auto_commands()
                end)

                map("n", "<leader>rb", function()
                    gs.reset_buffer()
                    update_auto_commands()
                end)

                map("n", "<leader>sb", function()
                    if vim.g.Base_commit ~= "" then
                        vim.notify("Hunks are not in INDEX ", vim.log.levels.WARN)
                        return
                    end
                    gs.stage_buffer()
                    update_auto_commands()
                end)

                map("v", "<leader>sh", function()
                    if vim.g.Base_commit ~= "" then
                        vim.notify("Hunks are not in INDEX ", vim.log.levels.WARN)
                        return
                    end
                    local s, e = vim.fn.line("."), vim.fn.line("v")
                    FeedKeys(string.format('ms<cmd>lua require("gitsigns").stage_hunk({%s,%s})<CR>`s', s, e), "n")
                    update_auto_commands()
                end)

                map("n", "<leader>sh", function()
                    if vim.g.Base_commit ~= "" then
                        vim.notify("Hunks are not in INDEX", vim.log.levels.WARN)
                        return
                    end
                    vim.cmd("Gitsigns stage_hunk")
                    update_auto_commands()
                end)

                map("n", "<leader>uh", function()
                    if vim.g.Base_commit ~= "" then
                        vim.notify("Hunks are not in INDEX ", vim.log.levels.WARN)
                        return
                    end
                    vim.cmd("Gitsigns undo_stage_hunk")
                    update_auto_commands()
                end)

                map("n", "<leader>bb", function()
                    if require("config.utils").has_filetype("gitsigns.blame") then
                        FeedKeys("<Tab>q<d-1>", "m")
                        return
                    end
                    if require("config.utils").has_filetype("NvimTree") then
                        require("nvim-tree.api").tree.toggle({ focus = false })
                    end
                    vim.cmd("Gitsigns blame")
                end)

                local function toggle_inline_diff()
                    local namespaces = { "gitsigns_removed", "gitsigns", "gitsigns_signs_staged", "gitsigns_signs_" }
                    for _, namespace in ipairs(namespaces) do
                        api.nvim_buf_clear_namespace(0, api.nvim_create_namespace(namespace), 0, -1)
                    end
                    gs.toggle_word_diff()
                    gs.toggle_deleted()
                    gs.toggle_linehl()
                end

                map("n", "<leader>sj", function()
                    FeedKeys("]c", "m")
                    api.nvim_create_autocmd("CursorMoved", {
                        once = true,
                        callback = toggle_inline_diff,
                    })
                end)

                map("n", "<leader>si", function()
                    toggle_inline_diff()
                    local times = { 0, 10, 30, 60 }
                    for _, time in ipairs(times) do
                        vim.defer_fn(function()
                            pcall(_G.indent_update)
                        end, time)
                    end
                end)

                map("n", "<leader>sk", function()
                    FeedKeys("[c", "m")
                    api.nvim_create_autocmd("CursorMoved", {
                        once = true,
                        callback = toggle_inline_diff,
                    })
                end)
                map("n", "<leader>sq", function()
                    _G.pre_gitsigns_qf_operation = "cur"
                    if not utils.has_filetype("trouble") then
                        api.nvim_create_autocmd("User", {
                            pattern = "TroubleOpen",
                            once = true,
                            callback = vim.schedule_wrap(function()
                                require("gitsigns").nav_hunk("first", { target = target, navigation_message = false })
                                FeedKeys("z", "m")
                            end),
                        })
                    end
                    vim.cmd("Gitsigns setqflist")
                end)

                map("n", "<leader>aq", function()
                    _G.pre_gitsigns_qf_operation = "all"
                    if not utils.has_filetype("trouble") then
                        api.nvim_create_autocmd("User", {
                            once = true,
                            pattern = "TroubleOpen",
                            callback = vim.schedule_wrap(function()
                                require("gitsigns").nav_hunk("first", { target = target, navigation_message = false })
                                if not require("gitsigns.config").config.word_diff then
                                    toggle_inline_diff()
                                end
                                FeedKeys("z", "m")
                                if not require("nvim-tree.explorer.filters").config.filter_git_clean then
                                    FeedKeys("<leader>S", "m")
                                else
                                    require("nvim-tree.api").tree.expand_all()
                                    require("nvim-tree.actions").tree.find_file.fn()
                                end
                            end),
                        })
                    end
                    gs.setqflist("all")
                end)

                map({ "o", "x" }, "ih", function()
                    gs.select_hunk()
                end)
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
        vim.keymap.set("n", "<leader>sp", function()
            vim.cmd("Gitsigns preview_hunk_inline")
            local times = { 0, 10, 30, 60 }
            for _, time in ipairs(times) do
                vim.defer_fn(function()
                    _G.indent_update()
                end, time)
            end
        end)
        vim.keymap.set("n", "<leader>cb", function()
            vim.g.Base_commit = ""
            vim.g.Base_commit_msg = ""
            require("gitsigns").reset_base("", true)

            Signs_staged = Signs.new(config.signs_staged, "staged")

            utils.refresh_last_commit()
            utils.update_diff_file_count()
            utils.refresh_nvim_tree_git()
            api.nvim_exec_autocmds("User", {
                pattern = "GitSignsUserUpdate",
            })
        end)
    end,
}
