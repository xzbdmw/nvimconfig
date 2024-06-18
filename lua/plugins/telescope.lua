_G.last = nil
_G.first_time = false
local function on_complete(bo_line, bo_line_side, origin_height)
    vim.schedule(function()
        ---@diagnostic disable-next-line: undefined-field
        local obj = _G.telescope_picker
        if not vim.api.nvim_buf_is_valid(obj.results_bufnr) then
            return
        end
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
    end)
end
return {
    {
        "nvim-telescope/telescope.nvim",
        -- dir = "~/Project/lua/telescope.nvim/",
        commit = "221778e93bfaa58bce4be4e055ed2edecc26f799",
        version = false,
        lazy = false,
        keys = {
            { "<leader><space>", false },
            { "<leader>so", false },
            { "<leader>sh", "<cmd>Telescope highlights<cr>", desc = "telescope highlights" },
            { "<leader>sr", "<cmd>Telescope resume<CR>" },
            { "<leader>sd", false },
            { "<leader>sh", false },
            { "<leader>sH", "<cmd>Telescope highlights<CR>" },
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
                    require("custom.telescope-pikers").prettyGrepPicker("egrepify", nil, vim.bo.filetype)
                end,
            },
            {
                "<leader>sc",
                -- false,
                function()
                    local filename = vim.fn.expand("%:t")
                    local default_text = "@" .. filename .. " "
                    require("custom.telescope-pikers").prettyGrepPicker("egrepify", default_text, nil)
                end,
            },
            {
                "<leader>sa",
                function()
                    local mode = vim.fn.mode()
                    if mode == "v" then
                        local get_selection = function()
                            return vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { mode = "v" })
                        end
                        require("custom.telescope-pikers").prettyGrepPicker(
                            "egrepify",
                            get_selection()[1],
                            vim.bo.filetype
                        )
                    else
                        local s = vim.fn.getreg('"')
                        require("custom.telescope-pikers").prettyGrepPicker("egrepify", s, vim.bo.filetype)
                    end
                end,
                mode = { "v", "n" },
            },
            {
                "<leader>sb",
                false,
            },
            {
                "<leader>sw",
                function()
                    local filetype = vim.bo.filetype
                    local mode = vim.api.nvim_get_mode()
                    local w
                    if mode.mode == "v" or mode.mode == "V" then
                        vim.cmd([[noautocmd sil norm! "vy]])
                        w = vim.fn.getreg("v")
                    else
                        w = vim.fn.expand("<cword>")
                    end
                    require("custom.telescope-pikers").prettyGrepPicker("egrepify", w, filetype)
                end,
                mode = { "n", "v" },
            },
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
                    _G.first_time = true
                    _G.aerial = true
                    _G.a_win = vim.api.nvim_get_current_win()
                    _G.a_buf = vim.api.nvim_get_current_buf()
                    _G.aerial_view = vim.fn.winsaveview()
                    vim.api.nvim_set_hl(0, "TelescopeMatching", { bold = true })
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
                        -- prompt_title = "aerial",
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
                    -- require("config.utls").cmd_e()
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
                        default_text = "'",
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
        config = function()
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

                vim.fn.setreg('"', display)
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
                    disable_devicons = true,
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
                            ["<D-a>"] = function()
                                FeedKeys("a", "n")
                            end,
                            ["<D-b>"] = function()
                                FeedKeys("b", "n")
                            end,
                            ["<D-c>"] = function()
                                FeedKeys("c", "n")
                            end,
                            ["<D-d>"] = function()
                                FeedKeys("d", "n")
                            end,
                            ["<D-e>"] = function()
                                FeedKeys("e", "n")
                            end,
                            ["<D-f>"] = function()
                                FeedKeys("f", "n")
                            end,
                            ["<D-g>"] = function()
                                FeedKeys("g", "n")
                            end,
                            ["<f13>"] = function()
                                FeedKeys("h", "n")
                            end,
                            ["<D-i>"] = function()
                                FeedKeys("i", "n")
                            end,
                            ["<D-j>"] = function()
                                FeedKeys("j", "n")
                            end,
                            ["<D-k>"] = function()
                                FeedKeys("k", "n")
                            end,
                            ["<f12>"] = function()
                                FeedKeys("l", "n")
                            end,
                            ["<D-m>"] = function()
                                FeedKeys("m", "n")
                            end,
                            ["<D-n>"] = function()
                                FeedKeys("n", "n")
                            end,
                            ["<D-o>"] = function()
                                FeedKeys("o", "n")
                            end,
                            ["<D-p>"] = function()
                                FeedKeys("p", "n")
                            end,
                            ["<f16>"] = function()
                                FeedKeys("k", "n")
                            end,
                            ["<D-q>"] = function()
                                FeedKeys("q", "n")
                            end,
                            ["<D-r>"] = function()
                                FeedKeys("r", "n")
                            end,
                            ["<D-s>"] = function()
                                FeedKeys("s", "n")
                            end,
                            ["<D-t>"] = function()
                                FeedKeys("t", "n")
                            end,
                            ["<D-u>"] = function()
                                FeedKeys("u", "n")
                            end,
                            ["<D-w>"] = function()
                                FeedKeys("w", "n")
                            end,
                            ["<D-x>"] = function()
                                FeedKeys("x", "n")
                            end,
                            ["<D-y>"] = function()
                                FeedKeys("y", "n")
                            end,
                            ["<D-z>"] = function()
                                FeedKeys("z", "n")
                            end,
                            ["<C-y>"] = "toggle_selection",
                            ["<Tab>"] = "to_fuzzy_refine",
                            ["("] = function()
                                FeedKeys("\\(", "n")
                            end,
                            [")"] = function()
                                FeedKeys("\\)", "n")
                            end,
                            ["<c-q>"] = function(bufnr)
                                actions.smart_send_to_qflist(bufnr)
                                vim.cmd("Trouble before_qflist")
                                -- require("trouble").open("before_qflist")
                            end,
                            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                            ["<C-e>"] = function(bufnr)
                                _G.last = nil
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
                                vim.g.neovide_cursor_animation_length = 0.0
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
                            ["<C-->"] = actions.preview_scrolling_up,
                            ["<C-=>"] = actions.preview_scrolling_down,
                            ["<D-v>"] = function()
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<C-r>1", true, false, true),
                                    "t",
                                    true
                                )
                            end,
                            ["<C-g>"] = function(bufnr)
                                actions.to_fuzzy_refine(bufnr)
                            end,
                            ["<f17>"] = function()
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<Cr>", true, false, true),
                                    "t",
                                    true
                                )
                            end,
                        },
                        n = {
                            ["`"] = function()
                                FeedKeys("a", "n")
                                FeedKeys("<space>", "n")
                                FeedKeys("`", "n")
                            end,
                            ["s"] = function(bufnr)
                                actions.toggle_selection(bufnr)
                                FeedKeys("j", "m")
                            end,
                            ["<Tab>"] = function(bufnr)
                                actions.to_fuzzy_refine(bufnr)
                                FeedKeys("i", "n")
                            end,
                            ["<c-q>"] = function(bufnr)
                                actions.smart_send_to_qflist(bufnr)
                                vim.cmd("Trouble before_qflist")
                            end,
                            ["<c-t>"] = function(bufnr)
                                require("trouble.sources.telescope").open(bufnr)
                            end,
                            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                            ["<C-g>"] = actions.to_fuzzy_refine,
                            ["<esc>"] = function(bufnr)
                                _G.last = nil
                                actions.close(bufnr)
                            end,
                            ["<CR>"] = function(bufnr)
                                actions.select_default(bufnr)
                                actions.center(bufnr)
                            end,
                            ["q"] = function(bufnr)
                                _G.last = nil
                                actions.close(bufnr)
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
                        },
                    },
                },
                pickers = {
                    find_files = {
                        disable_devicons = true,
                    },
                    lsp_implementations = {
                        entry_maker = require("custom.make_entry").gen_from_quickfix({ trim_text = true }),
                        initial_mode = "insert",
                        layout_strategy = "vertical",
                        trim_text = true,
                        reuse_win = true,
                        previewer = true,
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
                    live_grep = {
                        additional_args = { "--glob", "!.git", "--max-count", "10" },
                        max_results = 20,
                        disable_devicons = true,
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
            require("telescope").load_extension("egrepify")
        end,
    },
}
