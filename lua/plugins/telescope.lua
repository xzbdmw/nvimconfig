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
            { "<leader>sf", false },
            {
                "<leader>sH",
                function()
                    return "<cmd>Telescope highlights<cr>"
                end,
                desc = "telescope highlights",
                expr = true,
            },
            {
                "<leader>sh",
                false,
            },
            { "<leader>sr", "<cmd>Telescope resume<CR>" },
            { "<leader>sd", false },
            {
                "<leader>sc",
                function()
                    return "<cmd>Telescope git_commits<CR>"
                end,
                desc = "Commits",
                expr = true,
            },
            {
                "<leader>ss",
                function()
                    require("custom.telescope-pikers").prettyWorkspaceSymbols()
                end,
            },
            {
                "<leader>fB",
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
                                require("config.utils").on_complete(
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
                                require("config.utils").on_complete(
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
                function()
                    require("custom.telescope-pikers").prettyGrepPicker("egrepify", nil, vim.bo.filetype)
                end,
            },
            {
                "<leader>fb",
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
                "<leader>sw",
                function()
                    local filetype = vim.bo.filetype
                    local mode = api.nvim_get_mode()
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
                    _G.a_win = api.nvim_get_current_win()
                    _G.a_buf = api.nvim_get_current_buf()
                    _G.aerial_view = vim.fn.winsaveview()
                    require("telescope").extensions.aerial.aerial({
                        on_complete = {
                            function()
                                require("config.utils").on_complete(
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
                        attach_mappings = function(_, map)
                            map({ "i", "n" }, "<Cr>", function(prompt_bufnr)
                                require("telescope.actions").select_default(prompt_bufnr)
                                require("config.utils").adjust_view(0, 4)
                            end, { desc = "desc for which key" })
                            return true
                        end,
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
                                require("config.utils").on_complete(
                                    "╰──────────────────────────────────────────╯",
                                    "│                                          │",
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
                        open_buffer_indicators = { previous = "󱝂 ", others = "󰫣 " },
                        prompt_title = "Smart Open",
                        initial_mode = "insert",
                        layout_strategy = "horizontal",
                        previewer = false,
                        layout_config = {
                            horizontal = {
                                width = 0.27,
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
            local action_state = require("telescope.actions.state")

            local yank_selected_entry = function(prompt_bufnr)
                local entry_display = require("telescope.pickers.entry_display")
                local picker = action_state.get_current_picker(prompt_bufnr)
                local manager = picker.manager

                local selection_row = picker:get_selection_row()
                local entry = manager:get_entry(picker:get_index(selection_row))
                local display, _ = entry_display.resolve(picker, entry)

                actions.close(prompt_bufnr)

                vim.fn.setreg('"', display)
                vim.fn.setreg("+", display)
            end

            local delta = require("telescope.previewers").new_termopen_previewer({
                get_command = function(entry)
                    return {
                        "git",
                        "-c",
                        "core.pager=delta",
                        "-c",
                        "delta.side-by-side=false",
                        "diff",
                        entry.value .. "^!",
                        "--",
                        entry.current_file,
                    }
                end,
            })

            local function gitsign_change_base(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local commit = selection.value
                vim.g.Base_commit = commit
                vim.g.Base_commit_msg = ""
                local sts = vim.split(selection.ordinal, " ")
                for i = 2, #sts do
                    vim.g.Base_commit_msg = vim.g.Base_commit_msg .. sts[i] .. " "
                end
                -- __AUTO_GENERATED_PRINT_VAR_START__
                print(
                    [==[function#gitsign_change_base#for vim.g.Base_commit_msg:]==],
                    vim.inspect(vim.g.Base_commit_msg)
                ) -- __AUTO_GENERATED_PRINT_VAR_END__
                pcall(function()
                    require("gitsigns").change_base(commit, true)
                    vim.defer_fn(function()
                        vim.cmd("Gitsigns attach")
                    end, 100)
                end)
                vim.notify(selection.ordinal, vim.log.levels.INFO)
            end

            local focus_preview = function(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local prompt_win = picker.prompt_win
                local previewer = picker.previewer
                local winid = previewer.state.winid
                local bufnr = previewer.state.bufnr
                if previewer.state.winid == nil then
                    bufnr = previewer.state.termopen_bufnr
                    winid = vim.fn.win_findbuf(bufnr)[1]
                end
                local cursor = api.nvim_win_get_cursor(winid)
                vim.keymap.set("n", "<Tab>", function()
                    api.nvim_win_set_cursor(winid, cursor)
                    require("config.utils").update_preview_state(bufnr, winid)
                    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
                end, { buffer = bufnr })
                vim.keymap.set("n", "<cr>", function()
                    local filename = vim.b[bufnr].filepath
                    local row, col = unpack(api.nvim_win_get_cursor(winid))
                    actions.close(prompt_bufnr)

                    vim.cmd(
                        string.format("lua EditLineFromLazygit('%s','%s','%s')", filename, tostring(row), tostring(col))
                    )
                end, { buffer = bufnr })
                vim.keymap.set("n", "q", function()
                    _G.hide_cursor(function() end)
                    actions.close(prompt_bufnr)
                end, { buffer = bufnr })
                vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
            end

            -- yank preview
            local yank_preview_lines = function(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local previewer = picker.previewer
                local winid = previewer.state.winid
                local bufnr = previewer.state.bufnr
                local line_start = vim.fn.line("w0", winid)
                local line_end = vim.fn.line("w$", winid)

                local lines = api.nvim_buf_get_lines(bufnr, line_start, line_end, false)

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
                    set_env = {
                        LESS = "",
                        DELTA_PAGER = "less",
                    },
                    layout_config = {
                        horizontal = {
                            width = 0.9,
                            height = 0.9,
                            preview_cutoff = 0,
                            prompt_position = "top",
                            preview_width = 0.6,
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
                            ["<Tab>"] = focus_preview,
                            ["<c-f>"] = "to_fuzzy_refine",
                            ["("] = function()
                                FeedKeys("\\(", "n")
                            end,
                            [")"] = function()
                                FeedKeys("\\)", "n")
                            end,
                            ["<c-q>"] = function(bufnr)
                                actions.smart_send_to_qflist(bufnr)
                                FeedKeys("<C-q>", "m")
                            end,
                            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                            ["<C-e>"] = function(bufnr)
                                _G.last = nil
                                actions.close(bufnr)
                            end,
                            ["<C-d>"] = function()
                                FeedKeys("<c-w>", "t")
                            end,
                            ["<C-u>"] = function()
                                FeedKeys("<C-CR>", "t")
                            end,
                            ["<CR>"] = function(bufnr)
                                ST = vim.uv.hrtime()
                                vim.g.gd = true
                                vim.defer_fn(function()
                                    vim.g.gd = false
                                end, 100)
                                vim.g.neovide_cursor_animation_length = 0.0
                                actions.select_default(bufnr)
                                require("config.utils").adjust_view(0, 4)
                            end,
                            ["<esc>"] = function()
                                api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                            end,
                            ["<C-->"] = actions.preview_scrolling_up,
                            ["<C-=>"] = actions.preview_scrolling_down,
                            ["<D-v>"] = function()
                                FeedKeys('<C-r>"', "t")
                            end,
                            ["<f17>"] = function()
                                FeedKeys("<CR>", "t")
                            end,
                        },
                        n = {
                            ["<Tab>"] = focus_preview,
                            ["<C-f>"] = function(bufnr)
                                vim.cmd("startinsert")
                                actions.to_fuzzy_refine(bufnr)
                            end,
                            J = actions.preview_scrolling_down,
                            K = actions.preview_scrolling_up,
                            ["s"] = function(bufnr)
                                actions.toggle_selection(bufnr)
                                FeedKeys("j", "m")
                            end,
                            ["<c-q>"] = function(bufnr)
                                actions.smart_send_to_qflist(bufnr)
                                FeedKeys("<C-q>", "m")
                            end,
                            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                            ["<esc>"] = function(bufnr)
                                _G.last = nil
                                actions.close(bufnr)
                            end,
                            ["<CR>"] = function(bufnr)
                                actions.select_default(bufnr)
                                require("config.utils").adjust_view(0, 4)
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
                                FeedKeys("<CR>", "t")
                            end,
                        },
                    },
                },
                pickers = {
                    git_commits = {
                        initial_mode = "normal",
                        layout_config = {
                            horizontal = {
                                width = 0.95,
                                height = 0.95,
                                preview_cutoff = 0,
                                prompt_position = "top",
                                preview_width = 0.65,
                            },
                        },
                        previewer = {
                            delta,
                            require("telescope.previewers").git_commit_message.new({}),
                            require("telescope.previewers").git_commit_diff_as_was.new({}),
                        },
                        mappings = {
                            n = {
                                ["<CR>"] = gitsign_change_base,
                            },
                            i = {
                                ["<CR>"] = gitsign_change_base,
                            },
                        },
                    },
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
