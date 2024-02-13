return {
    "nvim-telescope/telescope.nvim",
    version = false,
    keys = {
        { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "recent files" },
        -- disable the keymap to grep files
        { "<leader><space>", false },
        { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "telescope resume" },
        {
            "<C-d>",
            function()
                require("telescope.builtin").lsp_document_symbols({
                    symbols = require("lazyvim.config").get_kind_filter(),
                })
            end,
            desc = "Goto Symbol",
        },
        {
            "<leader>ff",
            function()
                require("telescope.builtin").grep_string({
                    path_display = { "smart" },
                    only_sort_text = true,
                    word_match = "-w",
                    search = "",
                })
            end,
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

            vim.fn.setreg("+", display)
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
                initial_mode = "insert",
                path_display = require("custom.path_display").filenameFirstWithoutParent,
                file_sorter = require("custom.file_sorter").file_sorter,
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                layout_config = {
                    horizontal = {
                        width = 0.8,
                        height = 0.8,
                        preview_cutoff = 0,
                        prompt_position = "top",
                        preview_width = 0.6,
                    },
                },
                mappings = {
                    i = {
                        ["<C-e>"] = actions.close,
                        ["<C-->"] = actions.preview_scrolling_left,
                        ["<C-=>"] = actions.preview_scrolling_right,
                    },
                    n = {
                        ["<C-e>"] = actions.close,
                        ["Y"] = yank_preview_lines,
                        ["y"] = yank_selected_entry,
                        ["<C-->"] = actions.preview_scrolling_left,
                        ["<C-=>"] = actions.preview_scrolling_right,
                        s = flash,
                    },
                },
            },
            pickers = {
                lsp_implementations = {
                    initial_mode = "normal",
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
                    layout_config = {
                        horizontal = {
                            width = 0.9,
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
                    include_declaration = false,
                    push_cursor_on_edit = true,
                },
                buffers = {
                    path_display = require("custom.path_display").filenameFirst,
                    sort_mru = true,
                    sort_lastused = true,
                },
            },
            extensions = {
                smart_open = {
                    show_scores = true,
                    ignore_patterns = { "*.git/*", "*/tmp/*" },
                    match_algorithm = "fzf",
                    disable_devicons = true,
                    open_buffer_indicators = { previous = "😄", others = "👀" },
                },
            },
        })
        require("telescope").load_extension("bookmarks")
        require("telescope").load_extension("fzf")
    end,
}
