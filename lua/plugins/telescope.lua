return {
    "nvim-telescope/telescope.nvim",
    version = false,
    keys = {
        { "<leader><space>", false },
        { "<leader>sh", "<cmd>Telescope highlights<cr>", desc = "telescope highlights" },
        { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "telescope resume" },
        { "<leader>sd", false },
        {
            "<leader>ff",
            function()
                require("custom.telescope-pikers").prettyFilesPicker("file")
            end,
        },
        {
            "<leader>ss",
            function()
                require("custom.telescope-pikers").prettyWorkspaceSymbols()
            end,
        },

        {
            "<leader>fb",
            function()
                require("custom.telescope-pikers").prettyBuffersPicker(false)
            end,
        },
        {
            "<leader>fr",
            function()
                require("custom.telescope-pikers").prettyFilesPicker("old_files")
            end,
        },
        {
            "<C-p>",
            function()
                require("telescope").extensions["neovim-project"].history({
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            width = 0.35,
                            height = 0.7,
                        },
                    },
                })
            end,
        },
        {
            "<leader><leader>p",
            function()
                require("telescope").extensions["neovim-project"].discover({
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            width = 0.7,
                            height = 0.7,
                        },
                    },
                })
            end,
            desc = "discover project",
        },
        {
            "<leader>sg",
            function()
                require("custom.telescope-pikers").prettyGrepPicker()
            end,
        },
        {
            "ml",
            function()
                local bookmark_actions = require("telescope").extensions.vim_bookmarks.actions
                require("telescope").extensions.vim_bookmarks.all({
                    initial_mode = "insert",
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            prompt_position = "top",
                            width = 0.7,
                            height = 0.9,
                            mirror = true,
                            preview_cutoff = 0,
                            preview_height = 0.55,
                        },
                    },
                })
            end,
            desc = "telescope bookmarks",
        },
        {
            "<C-6>",
            function()
                require("custom.telescope-pikers").prettyBuffersPicker(true)
            end,
            mode = { "n", "i" },
        },
        {
            "<D-e>",
            function()
                require("telescope").extensions.smart_open.smart_open({
                    show_scores = false,
                    ignore_patterns = { "*.git/*", "*/tmp/*" },
                    match_algorithm = "fzf",
                    disable_devicons = false,
                    open_buffer_indicators = { previous = "󰎂 ", others = "󱇽 " },
                    prompt_title = "Smart Open",
                    initial_mode = "insert",
                    layout_strategy = "horizontal",
                    previewer = false,
                    layout_config = {
                        horizontal = {
                            width = 0.35,
                            height = 0.7,
                        },
                        mirror = false,
                    },
                })
            end,
        },
        {
            "<D-f>",
            function()
                vim.cmd("normal! m'")
                vim.cmd("Telescope current_buffer_fuzzy_find")
            end,
            mode = { "n", "i" },
        },
    },
    config = function()
        local function flash(prompt_bufnr)
            require("flash").jump({
                pattern = "^",
                label = { after = { 0, 0 } },
                search = {
                    mode = "search",
                    exclude = {
                        function(win)
                            return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                        end,
                    },
                },
                action = function(match)
                    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                    picker:set_selection(match.pos[1] - 1)
                end,
            })
        end
        local actions = require("telescope.actions")
        local yank_selected_entry = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local entry_display = require("telescope.pickers.entry_display")
            local picker = action_state.get_current_picker(prompt_bufnr)
            local manager = picker.manager

            local selection_row = picker:get_selection_row()
            local entry = manager:get_entry(picker:get_index(selection_row))
            local display, _ = entry_display.resolve(picker, entry)

            actions.close(prompt_bufnr)

            vim.fn.setreg("1", display)
            vim.fn.setreg("*", display)
        end
        -- yank preview
        local yank_preview_lines = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local picker = action_state.get_current_picker(prompt_bufnr)
            local previewer = picker.previewer
            local winid = previewer.state.winid
            local bufnr = previewer.state.bufnr
            local line_start = vim.fn.line("w0", winid)
            local line_end = vim.fn.line("w$", winid)

            local lines = vim.api.nvim_buf_get_lines(bufnr, line_start, line_end, false)

            local text = table.concat(lines, "\n")

            actions.close(prompt_bufnr)
            vim.fn.setreg("+", text)
        end
        require("telescope").setup({
            defaults = {
                winblend = 0,
                initial_mode = "insert",
                path_display = require("custom.path_display").filenameFirstWithoutParent,
                file_sorter = require("custom.file_sorter").file_sorter,
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                borderchars = { " ", " ", "", " ", " ", " ", " ", " " },
                -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

                layout_config = {
                    horizontal = {
                        width = 0.9,
                        height = 0.9,
                        preview_cutoff = 0,
                        prompt_position = "top",
                        preview_width = 0.65,
                    },
                },
                --[[ layout_config = {
                    horizontal = {
                        width = 0.8,
                        height = 0.8,
                        preview_cutoff = 0,
                        prompt_position = "top",
                        preview_width = 0.6,
                    },
                }, ]]
                mappings = {
                    i = {
                        ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                        ["<C-e>"] = actions.close,
                        ["<C-d>"] = function()
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "t", true)
                        end,
                        ["<C-u>"] = function()
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("<C-CR>", true, false, true),
                                "t",
                                true
                            )
                        end,
                        ["<CR>"] = function()
                            vim.cmd([[:stopinsert]])
                            vim.cmd([[call feedkeys("\<CR>")]])
                        end,
                        ["<esc>"] = function()
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                        end,
                        ["<C-->"] = actions.preview_scrolling_left,
                        ["<C-=>"] = actions.preview_scrolling_right,
                        ["<D-v>"] = function()
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("<C-r>1", true, false, true),
                                "t",
                                true
                            )
                        end,
                        ["<f17>"] = function()
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Cr>", true, false, true), "t", true)
                        end,
                    },
                    n = {
                        ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                        ["<esc>"] = actions.close,
                        ["Y"] = yank_preview_lines,
                        ["y"] = yank_selected_entry,
                        ["<C-->"] = actions.preview_scrolling_left,
                        ["<C-=>"] = actions.preview_scrolling_right,
                        ["<f16>"] = function()
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Cr>", true, false, true), "t", true)
                        end,
                        s = flash,
                    },
                },
            },
            pickers = {
                lsp_implementations = {
                    entry_maker = require("custom.make_entry").gen_from_quickfix({ trim_text = true }),
                    initial_mode = "insert",
                    layout_strategy = "vertical",
                    trim_text = true,
                    reuse_win = true,
                    previewer = false,
                    layout_config = {
                        vertical = {
                            width = 0.6,
                            height = 0.9,
                            preview_cutoff = 0,
                            prompt_position = "top",
                            preview_width = 0.5,
                        },
                        mirror = true,
                    },
                },
                diagnostics = {
                    initial_mode = "normal",
                    wrap_results = false,
                    disable_coordinates = true,
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            prompt_position = "top",
                            width = 0.55,
                            height = 0.9,
                            mirror = true,
                            preview_cutoff = 0,
                            preview_height = 0.55,
                        },
                    },
                },
                lsp_dynamic_workspace_symbols = {
                    disable_coordinates = true,
                    mappings = {
                        i = { ["<c-f>"] = actions.to_fuzzy_refine },
                    },
                    fname_width = 15,
                    layout_config = {
                        horizontal = {
                            width = 0.9,
                            height = 0.9,
                            preview_cutoff = 0,
                            prompt_position = "top",
                            preview_width = 0.5,
                        },
                    },
                },
                live_grep = {
                    entry_maker = require("custom.make_entry").gen_from_vimgrep_lib(),
                    disable_coordinates = true,
                    layout_config = {
                        horizontal = {
                            width = 0.8,
                            height = 0.9,
                            preview_cutoff = 0,
                            prompt_position = "top",
                            preview_width = 0.5,
                        },
                    },
                    mappings = {
                        i = { ["<c-f>"] = actions.to_fuzzy_refine },
                    },
                },
                current_buffer_fuzzy_find = {
                    disable_coordinates = true,
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            prompt_position = "top",
                            width = 0.55,
                            height = 0.9,
                            mirror = true,
                            preview_cutoff = 0,
                            preview_height = 0.55,
                        },
                    },
                },
                lsp_references = {
                    -- entry_maker = require("custom.make_entry").gen_from_quickfix(),
                    trim_text = true,
                    layout_config = {
                        horizontal = {
                            width = 0.9,
                            height = 0.9,
                            preview_cutoff = 0,
                            prompt_position = "top",
                            preview_width = 0.5,
                        },
                    },
                    disable_coordinates = true,
                    include_declaration = false,
                    push_cursor_on_edit = true,
                },
                buffers = {
                    initial_mode = "normal",
                    mappings = {
                        n = {
                            ["d"] = "delete_buffer",
                        },
                    },
                    show_all_buffers = false,
                    path_display = require("custom.path_display").filenameFirst,
                    sort_mru = true,
                    sort_lastused = true,
                },
            },
            extensions = {},
        })
        -- require("telescope").load_extension("bookmarks")
        require("telescope").load_extension("fzf")
    end,
}
