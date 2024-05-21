_G.last = nil
local function on_complete(bo_line, bo_line_side, origin_height)
    vim.defer_fn(function()
        local obj = _G.telescope_picker
        local count = vim.api.nvim_buf_line_count(obj.results_bufnr)
        local top_win = vim.api.nvim_win_get_config(obj.results_win)
        local buttom_buf = vim.api.nvim_win_get_buf(obj.results_win + 1)
        local bottom_win = vim.api.nvim_win_get_config(obj.results_win + 1)
        top_win.height = math.max(count, 1)
        top_win.height = math.min(top_win.height, origin_height)
        bottom_win.height = math.max(count + 2, 3)
        bottom_win.height = math.min(bottom_win.height, origin_height + 2)
        vim.api.nvim_win_set_config(obj.results_win + 1, bottom_win)
        vim.api.nvim_win_set_config(obj.results_win, top_win)
        if _G.last ~= nil then
            vim.api.nvim_buf_set_lines(buttom_buf, _G.last, _G.last + 1, false, { bo_line_side })
        end
        vim.api.nvim_buf_set_lines(buttom_buf, math.max(count + 1, 2), math.max(count + 2, 3), false, { bo_line })
        _G.last = math.max(count + 1, 2)
        -- end
    end, 10)
end
return {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    {
        "nvim-telescope/telescope.nvim",
        commit = "221778e93bfaa58bce4be4e055ed2edecc26f799",
        version = false,
        keys = {
            { "<leader><space>", false },
            { "<leader>sw", false },
            { "<leader>so", false },
            { "<leader>sh", "<cmd>Telescope highlights<cr>", desc = "telescope highlights" },
            { "<leader>sr", "<cmd>Telescope resume<CR>" },
            { "<leader>sd", false },
            {
                "<leader>ss",
                function()
                    require("custom.telescope-pikers").prettyWorkspaceSymbols()
                end,
            },
            {
                "<leader>fb",
                function()
                    require("custom.telescope-pikers").prettyBuffersPicker(true, "normal")
                end,
            },
            {
                "<C-p>",
                function()
                    require("telescope").extensions["neovim-project"].history({
                        on_complete = {
                            function()
                                on_complete(
                                    "╰────────────────────────────────────────────────────────────────────────╯",
                                    "│                                                                        │",
                                    19
                                )
                            end,
                        },
                        layout_strategy = "horizontal",
                        layout_config = {
                            horizontal = {
                                width = 0.45,
                                height = 0.7,
                            },
                        },
                    })
                    vim.schedule(function()
                        FeedKeys("<down>", "t")
                    end)
                end,
            },
            {
                "<leader><leader>p",
                function()
                    require("telescope").extensions["neovim-project"].discover({
                        layout_strategy = "horizontal",
                        on_complete = {
                            function()
                                on_complete(
                                    "╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯",
                                    "│                                                                                                                  │",
                                    19
                                )
                            end,
                        },
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
                -- false,
                function()
                    require("custom.telescope-pikers").prettyGrepPicker("live_grep")
                end,
            },
            {
                "<leader>sa",
                false,
            }, -- {
            --     "<leader>f",
            --     function()
            --         require("custom.telescope-pikers").prettyGrepPicker("grep_string")
            --     end,
            --     mode = { "v" },
            -- },
            {
                "<C-6>",
                function()
                    require("custom.telescope-pikers").prettyBuffersPicker(true, "insert")
                end,
                mode = { "n", "i" },
            },
            {
                "<C-d>",
                function()
                    _G.aerial = true
                    _G.a_win = vim.api.nvim_get_current_win()
                    _G.a_buf = vim.api.nvim_get_current_buf()
                    _G.aerial_view = vim.fn.winsaveview()
                    vim.api.nvim_set_hl(0, "TelescopeMatching", { bold = true })
                    local ns_id = vim.api.nvim_create_namespace("indent")
                    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
                    pcall(close_stored_win, _G.a_win)
                    -- ST = os.clock()
                    require("telescope").extensions.aerial.aerial({
                        on_complete = {
                            function()
                                on_complete(
                                    "╰───────────────────────────────────────╯",
                                    "│                                       │",
                                    19
                                )
                            end,
                        },
                        prompt_title = "aerial",
                        initial_mode = "insert",
                        layout_strategy = "horizontal",
                        previewer = false,
                        layout_config = {
                            horizontal = {
                                height = 0.7, -- window height
                                width = 0.25, -- window width
                            },
                            mirror = false,
                        },
                        -- Display symbols as <root>.<parent>.<symbol>
                        show_nesting = {
                            ["_"] = true, -- This key will be the default
                            json = true, -- You can set the option for specific filetypes
                            yaml = true,
                        },
                    })
                end,
            },
            {
                "<D-e>",
                function()
                    -- ST = os.clock()
                    require("telescope").extensions.smart_open.smart_open({
                        on_complete = {
                            function()
                                on_complete(
                                    "╰────────────────────────────────────────────────────────╯",
                                    "│                                                        │",
                                    19
                                )
                            end,
                        },
                        cwd_only = true,
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
                "<leader>e",
                function()
                    require("telescope").extensions.smart_open.smart_open({
                        cwd_only = true,
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
                "<leader>ff",
                function()
                    require("telescope").extensions.smart_open.smart_open({
                        show_scores = false,
                        ignore_patterns = { "*.git/*", "*/tmp/*" },
                        match_algorithm = "fzf",
                        disable_devicons = false,
                        open_buffer_indicators = { previous = "󰎂 ", others = "󱇽 " },
                        prompt_title = "History File",
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
        dependencies = {
            "natecraddock/telescope-zf-native.nvim",
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
                vim.fn.setreg('"', text)
            end
            require("telescope").setup({
                defaults = {
                    winblend = 0,
                    initial_mode = "insert",
                    path_display = require("custom.path_display").filenameFirstWithoutParent,
                    file_sorter = require("custom.file_sorter").file_sorter,
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    -- borderchars = { " ", " ", "", " ", " ", " ", " ", " " },
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

                    layout_config = {
                        horizontal = {
                            width = 0.9,
                            height = 0.9,
                            preview_cutoff = 0,
                            prompt_position = "top",
                            preview_width = 0.65,
                        },
                    },
                    mappings = {
                        i = {
                            ["<Tab>"] = actions.toggle_selection,
                            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<c-t>"] = require("trouble.sources.telescope").open,
                            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                            ["<C-e>"] = function(bufnr)
                                _G.last = nil
                                vim.g.neovide_cursor_animation_length = 0.0
                                vim.defer_fn(function()
                                    vim.g.neovide_cursor_animation_length = 0.06
                                end, 100)
                                actions.close(bufnr)
                            end,
                            ["<C-d>"] = function()
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<C-w>", true, false, true),
                                    "t",
                                    true
                                )
                            end,
                            ["<C-u>"] = function()
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<C-CR>", true, false, true),
                                    "t",
                                    true
                                )
                            end,
                            ["<CR>"] = function(bufnr)
                                ST = vim.uv.hrtime()
                                vim.g.gd = true
                                vim.g.neovide_cursor_animation_length = 0.0
                                vim.defer_fn(function()
                                    vim.g.gd = false
                                    vim.g.neovide_cursor_animation_length = 0.06
                                end, 100)
                                actions.select_default(bufnr)
                                actions.center(bufnr)
                            end,
                            ["<esc>"] = function()
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                                    "n",
                                    true
                                )
                            end,
                            ["<C-->"] = actions.preview_scrolling_left,
                            ["<C-i>"] = function()
                                vim.g.gd = true
                                vim.cmd([[:stopinsert]])
                                vim.cmd([[call feedkeys("\<CR>")]])
                            end,
                            ["<C-=>"] = actions.preview_scrolling_right,
                            ["<D-v>"] = function()
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<C-r>1", true, false, true),
                                    "t",
                                    true
                                )
                            end,
                            ["<C-g>"] = actions.to_fuzzy_refine,
                            ["<f17>"] = function()
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<Cr>", true, false, true),
                                    "t",
                                    true
                                )
                            end,
                        },
                        n = {
                            ["<Tab>"] = actions.toggle_selection,
                            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<c-t>"] = require("trouble.sources.telescope").open,
                            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                            ["<C-g>"] = actions.to_fuzzy_refine,
                            ["<esc>"] = function(bufnr)
                                _G.last = nil
                                vim.g.neovide_cursor_animation_length = 0.0
                                vim.defer_fn(function()
                                    vim.g.neovide_cursor_animation_length = 0.06
                                end, 100)
                                actions.close(bufnr)
                            end,
                            ["<CR>"] = function(bufnr)
                                vim.g.gd = true
                                vim.g.neovide_cursor_animation_length = 0.0
                                vim.defer_fn(function()
                                    vim.g.gd = false
                                    vim.g.neovide_cursor_animation_length = 0.06
                                end, 100)
                                actions.select_default(bufnr)
                                actions.center(bufnr)
                            end,
                            ["Y"] = yank_preview_lines,
                            ["y"] = yank_selected_entry,
                            ["<C-->"] = actions.preview_scrolling_left,
                            ["<C-=>"] = actions.preview_scrolling_right,
                            ["<f16>"] = function()
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<Cr>", true, false, true),
                                    "t",
                                    true
                                )
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
                                preview_height = 0.5,
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
            require("telescope").load_extension("fzf")
            -- require("telescope").load_extension("zf-native")
        end,
    },
}
