local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("config.utils")
local state = require("telescope.state")
local builtin = require("telescope.builtin")
local keymap = vim.keymap.set
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
                "<D-f>",
                function()
                    vim.cmd("normal! m'")
                    vim.cmd("Telescope current_buffer_fuzzy_find")
                end,
                mode = { "n", "i" },
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
                    local options = {
                        attach_mappings = function(_, map)
                            utils.map_checkout("<space>", map)
                            return true
                        end,
                    }
                    builtin.git_commits(options)
                end,
                desc = "Commits",
            },
            {
                "<leader>xb",
                function()
                    local options = {
                        attach_mappings = function(_, map)
                            local maps = { "<space>", "<CR>" }
                            for _, m in ipairs(maps) do
                                utils.map_checkout(m, map)
                            end
                            return true
                        end,
                    }
                    builtin.git_branches(options)
                end,
                desc = "Commits",
            },
            {
                "<leader>ss",
                function()
                    if vim.g.Diff_file_count == 0 then
                        vim.notify("", vim.log.levels.INFO, { title = "No Changes" })
                        return
                    end
                    local options = {
                        attach_mappings = function(_, map)
                            map({ "n" }, "<space>", function(prompt_bufnr)
                                if utils.is_detached() then
                                    return
                                end
                                actions.git_staging_toggle(prompt_bufnr)
                            end, { nowait = true, desc = "Git stage file" })
                            return true
                        end,
                    }
                    if vim.g.Base_commit ~= "" then
                        options.commit = vim.g.Base_commit
                    end
                    builtin.git_status(options)
                end,
                desc = "Commits",
            },
            {
                "<leader>bl",
                function()
                    local options = {
                        attach_mappings = function(_, map)
                            utils.map_checkout("<space>", map)
                            return true
                        end,
                    }
                    builtin.git_bcommits_range(options)
                end,
            },
            {
                "<leader>sS",
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
                "<leader>br",
                function()
                    local options = {
                        attach_mappings = function(_, map)
                            utils.map_checkout("<space>", map)
                            return true
                        end,
                    }
                    local from, to = vim.fn.line("."), vim.fn.line("v")
                    options.from = from
                    options.to = to
                    builtin.git_bcommits_range(options)
                end,
                mode = { "x" },
            },
            {
                "<C-p>",
                function()
                    require("telescope").extensions["neovim-project"].history({
                        on_complete = {
                            function()
                                if vim.o.lines == 31 then
                                    require("config.utils").on_complete(
                                        "                                                          ",
                                        "                                                          ",
                                        16
                                    )
                                else
                                    require("config.utils").on_complete(
                                        "                                                                         ",
                                        "                                                                         ",
                                        18
                                    )
                                end
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
                                if vim.o.lines == 31 then
                                    require("config.utils").on_complete(
                                        "                                                                                           ",
                                        "                                                                                           ",
                                        16
                                    )
                                else
                                    require("config.utils").on_complete(
                                        "                                                                                                                    ",
                                        "                                                                                                                    ",
                                        18
                                    )
                                end
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
                "<leader>fd",
                function()
                    require("custom.telescope-pikers").prettyGrepPicker("agitator", nil, vim.bo.filetype)
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
                    local w = utils.get_cword()
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
                                if vim.o.lines == 31 then
                                    require("config.utils").on_complete(
                                        "                                       ",
                                        "                                       ",
                                        16
                                    )
                                else
                                    require("config.utils").on_complete(
                                        "                                         ",
                                        "                                         ",
                                        18
                                    )
                                end
                            end,
                        },
                        -- prompt_title = "aerial",
                        initial_mode = "insert",
                        layout_strategy = "horizontal",
                        previewer = false,
                        attach_mappings = function(_, map)
                            map({ "i", "n" }, "<Cr>", function(prompt_bufnr)
                                actions.select_default(prompt_bufnr)
                                utils.adjust_view(0, 4)
                            end, { desc = "desc for which key" })
                            return true
                        end,
                        layout_config = {
                            horizontal = {
                                height = 0.7, -- window height
                                width = vim.o.lines == 31 and 0.30 or 0.25, -- window width
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
                    require("telescope").extensions.smart_open.smart_open({
                        on_complete = {
                            function()
                                if vim.o.lines == 31 then
                                    require("config.utils").on_complete(
                                        "                                       ",
                                        "                                       ",
                                        16
                                    )
                                else
                                    require("config.utils").on_complete(
                                        "                                                     ",
                                        "                                                     ",
                                        18
                                    )
                                end
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
                                width = vim.o.lines == 31 and 0.30 or 0.32,
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
        },
        config = function()
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

            local commit_delta = require("telescope.previewers").new_termopen_previewer({
                get_command = function(entry)
                    return {
                        "git",
                        "show",
                        "--stat",
                        "-p",
                        entry.value .. "^!",
                    }
                end,
            })

            local goto_next_hunk_cr = function(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local title = picker.layout.picker.preview_title
                actions.select_default(prompt_bufnr)
                local ok = false
                local fn = function()
                    if ok then
                        return
                    end
                    local hunks = require("gitsigns.actions").get_nav_hunks(api.nvim_get_current_buf(), "all", true)
                    local target
                    if title == "Staged changes" then
                        target = "staged"
                    else -- include history revision(start with Diff)
                        target = "unstaged"
                    end
                    if hunks ~= nil and #hunks > 0 then
                        ok = true
                        require("gitsigns").nav_hunk("first", { target = target, navigation_message = false })
                        require("config.utils").adjust_view(0, 4)
                    end
                end
                fn()
                local id
                id = api.nvim_create_autocmd("User", {
                    pattern = "GitSignsUpdate",
                    callback = function()
                        if ok then
                            api.nvim_del_autocmd(id)
                        end
                        fn()
                    end,
                })
                vim.defer_fn(function()
                    pcall(api.nvim_del_autocmd, id)
                end, 1000)
            end

            local status_delta = require("telescope.previewers").new_termopen_previewer({
                title = "Grep Preview",
                dyn_title = function(_, entry)
                    if vim.g.stage_title ~= "" and vim.g.last_staged_title_path == entry.path then
                        return vim.g.stage_title
                    end
                    local title
                    if vim.g.Base_commit ~= "" then
                        title = "Diff with " .. vim.g.Base_commit_msg
                    else
                        if entry.status == "M " then
                            title = "Staged changes"
                        else
                            title = "Unstaged changes"
                        end
                    end
                    return title
                end,
                get_command = function(entry, _)
                    local command
                    if vim.g.Base_commit ~= "" then
                        command = {
                            "git",
                            "diff",
                            vim.g.Base_commit,
                            "--",
                            entry.path,
                        }
                    else
                        if entry.status == "M " then
                            command = {
                                "git",
                                "diff",
                                "--cached",
                                "--",
                                entry.path,
                            }
                        else
                            command = {
                                "git",
                                "diff",
                                "--",
                                entry.path,
                            }
                        end
                    end
                    return command
                end,
            })

            local function change_base(commit, commit_msg, prompt_bufnr)
                vim.g.Base_commit = commit
                Signs_staged = nil
                vim.g.Base_commit_msg = ""
                local sts = vim.split(commit_msg, " ")
                table.remove(sts, 1)
                commit_msg = table.concat(sts, " ")
                if #commit_msg > 30 then
                    local cut_pos = commit_msg:find(" ", 31)
                    if cut_pos then
                        commit_msg = commit_msg:sub(1, cut_pos - 1) .. "…"
                    else
                        commit_msg = commit_msg:sub(1, 30) .. "…"
                    end
                end
                vim.g.Base_commit_msg = vim.g.Base_commit_msg .. commit_msg
                require("gitsigns").change_base(commit, true)
                utils.update_diff_file_count()
                utils.refresh_nvim_tree_git()
                if not require("nvim-tree.explorer.filters").config.filter_git_clean then
                    vim.api.nvim_create_autocmd("User", {
                        once = true,
                        pattern = { "NvimTreeReloaded" },
                        callback = function()
                            FeedKeys("<leader>S", "m")
                        end,
                    })
                end
                vim.defer_fn(function()
                    vim.cmd("Gitsigns attach")
                end, 100)
                vim.notify(commit_msg, vim.log.levels.INFO)
                api.nvim_exec_autocmds("User", {
                    pattern = "GitSignsUserUpdate",
                })
            end

            local function gitsign_change_base_pre(prompt_bufnr, checkout)
                local selection = action_state.get_selected_entry()
                local commit = selection.value
                local result = vim.system({ "git", "log", "-n 1", "--pretty=format:%H%n%B", commit .. "^" }):wait()
                if result.code ~= 0 then
                    return
                end
                if checkout ~= nil then
                    checkout()
                end
                actions.close(prompt_bufnr)
                local splits = vim.split(result.stdout, "\n")
                commit = splits[1]:sub(1, 7)
                local commit_msg = splits[2]:gsub("\n", "")
                change_base(commit, commit_msg, prompt_bufnr)
            end

            local function gitsign_change_base(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local commit = selection.value
                local sts = vim.split(selection.ordinal, " ")
                table.remove(sts, 1)
                local commit_msg = table.concat(sts, " ")
                change_base(selection.value, commit_msg, prompt_bufnr)
            end

            local focus_preview = function(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local prompt_win = picker.prompt_win
                local previewer = picker.previewer
                if previewer == nil then
                    return
                end
                local winid = previewer.state.winid
                local bufnr = previewer.state.bufnr
                if previewer.state.winid == nil then
                    bufnr = previewer.state.termopen_bufnr
                    winid = vim.fn.win_findbuf(bufnr)[1]
                end
                local cursor = api.nvim_win_get_cursor(winid)
                keymap("n", "<Tab>", function()
                    api.nvim_win_set_cursor(winid, cursor)
                    require("config.utils").update_preview_state(bufnr, winid)
                    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
                end, { buffer = bufnr })
                keymap("n", "<cr>", function()
                    local filename = vim.b[bufnr].filepath
                    local row, col = unpack(api.nvim_win_get_cursor(winid))
                    actions.close(prompt_bufnr)

                    vim.cmd(
                        string.format("lua EditLineFromLazygit('%s','%s','%s')", filename, tostring(row), tostring(col))
                    )
                end, { buffer = bufnr })
                keymap("n", "q", function()
                    _G.hide_cursor(function() end)
                    actions.close(prompt_bufnr)
                end, { buffer = bufnr })
                vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
            end

            local focus_result = function(prompt_bufnr)
                local maps = vim.api.nvim_buf_get_keymap(prompt_bufnr, "n")
                local checkout_callback = nil
                local p_callback = nil
                local c_callback = nil
                for _, map in ipairs(maps) do
                    if map.lhs == " " then
                        checkout_callback = map.callback
                    end
                    if map.lhs == "p" then
                        p_callback = map.callback
                    end
                    if map.lhs == "c" then
                        c_callback = map.callback
                    end
                end
                local picker = action_state.get_current_picker(prompt_bufnr)
                local prompt_win = picker.prompt_win
                local results = picker.layout.results
                local winid = results.winid
                local bufnr = results.bufnr

                local id = api.nvim_create_autocmd("CursorMoved", {
                    callback = function()
                        local selection_row = picker:get_selection_row()
                        local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
                        if selection_row ~= cursor_row - 1 then
                            picker:set_selection(cursor_row - 1)
                        end
                    end,
                })

                local closed = false
                api.nvim_create_autocmd("User", {
                    once = true,
                    pattern = "TelescopeClose",
                    callback = function()
                        if not closed then
                            api.nvim_del_autocmd(id)
                        end
                    end,
                })

                keymap("n", "h", function()
                    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
                    closed = true
                    api.nvim_del_autocmd(id)
                end, { buffer = bufnr })

                keymap("n", "<Tab>", function()
                    focus_preview(prompt_bufnr)
                    closed = true
                    api.nvim_del_autocmd(id)
                end, { buffer = bufnr })

                keymap("n", "zz", function()
                    vim.cmd("norm! zz")
                end, { buffer = bufnr })

                keymap("n", "<cr>", function()
                    FeedKeys("h<CR>", "m")
                end, { buffer = bufnr })

                keymap("n", "K", function()
                    actions.preview_scrolling_up(prompt_bufnr)
                end, { buffer = bufnr })
                keymap("n", "J", function()
                    actions.preview_scrolling_down(prompt_bufnr)
                end, { buffer = bufnr })

                keymap("n", "q", function()
                    _G.hide_cursor(function() end)
                    actions.close(prompt_bufnr)
                end, { buffer = bufnr })

                if checkout_callback ~= nil then
                    keymap("n", "<space>", function()
                        checkout_callback()
                    end, { nowait = true, buffer = bufnr })
                end
                if p_callback ~= nil then
                    keymap("n", "p", function()
                        p_callback()
                    end, { nowait = true, buffer = bufnr })
                end
                if c_callback ~= nil then
                    keymap("n", "c", function()
                        c_callback()
                    end, { nowait = true, buffer = bufnr })
                end
                vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
            end

            local center_results = function(prompt_bufnr)
                focus_result(prompt_bufnr)
                FeedKeys("zzh", "m")
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
                    preview = {
                        highlight_limit = 0.8,
                    },
                    dynamic_preview_title = true,
                    disable_devicons = true,
                    prompt_prefix = " ",
                    entry_prefix = " ",
                    selection_caret = " ",
                    winblend = 0,
                    initial_mode = "insert",
                    path_display = require("custom.path_display").filenameFirstWithoutParent,
                    file_sorter = require("custom.file_sorter").file_sorter,
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    borderchars = { " ", " ", "", " ", " ", " ", " ", " " },
                    -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
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
                            ["<c-g>"] = "to_fuzzy_refine",
                            ["<down>"] = function(prompt_bufnr)
                                local ok, cmp = pcall(require, "cmp")
                                if ok and cmp.visible() then
                                    if cmp.core.view.custom_entries_view:is_direction_top_down() then
                                        _G.no_animation(_G.CI)
                                        cmp.select_next_item()
                                    else
                                        cmp.select_prev_item()
                                    end
                                else
                                    actions.move_selection_next(prompt_bufnr)
                                end
                            end,
                            ["<up>"] = function(prompt_bufnr)
                                local ok, cmp = pcall(require, "cmp")
                                if ok and cmp.visible() then
                                    if cmp.core.view.custom_entries_view:is_direction_top_down() then
                                        _G.no_animation(_G.CI)
                                        cmp.select_prev_item()
                                    else
                                        cmp.select_next_item()
                                    end
                                else
                                    actions.move_selection_previous(prompt_bufnr)
                                end
                            end,
                            ["("] = function()
                                FeedKeys("\\(", "n")
                            end,
                            [")"] = function()
                                FeedKeys("\\)", "n")
                            end,
                            ["<c-q>"] = function(bufnr)
                                actions.smart_send_to_qflist(bufnr)
                                if not require("trouble").is_open("qflist") then
                                    FeedKeys("<C-q>", "m")
                                end
                            end,
                            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                            ["<C-c>"] = function(bufnr)
                                _G.last = nil
                                actions.close(bufnr)
                            end,
                            ["<C-cr>"] = function(bufnr)
                                FeedKeys("<cr>", "t")
                            end,
                            ["<C-d>"] = function()
                                FeedKeys("<c-w>", "t")
                            end,
                            ["<C-u>"] = function()
                                FeedKeys("<C-CR>", "t")
                            end,
                            ["<C-b>"] = function()
                                FeedKeys("<s-left>", "t")
                            end,
                            ["<C-f>"] = function()
                                FeedKeys("<s-right>", "t")
                            end,
                            ["<C-a>"] = function()
                                FeedKeys("<Home>", "t")
                            end,
                            ["<C-e>"] = function(bufnr)
                                _G.last = nil
                                actions.close(bufnr)
                            end,
                            ["<CR>"] = function(bufnr)
                                local ok, cmp = pcall(require, "cmp")
                                if ok and cmp.visible() then
                                    _G.no_animation(_G.CI)
                                    cmp.confirm({ select = true })
                                else
                                    ST = vim.uv.hrtime()
                                    vim.g.gd = true
                                    vim.defer_fn(function()
                                        vim.g.gd = false
                                    end, 100)
                                    _G.set_cursor_animation(0.0)
                                    actions.select_default(bufnr)
                                    require("config.utils").adjust_view(0, 4)
                                end
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
                            ["R"] = focus_result,
                            ["<C-cr>"] = function(bufnr)
                                FeedKeys("<cr>", "t")
                            end,
                            ["<C-c>"] = function(bufnr)
                                _G.last = nil
                                actions.close(bufnr)
                            end,
                            ["<Tab>"] = focus_preview,
                            ["<C-g>"] = function(bufnr)
                                vim.cmd("startinsert")
                                actions.to_fuzzy_refine(bufnr)
                            end,
                            J = function(bufnr)
                                require("telescope.actions.set").shift_selection(bufnr, 3)
                            end,
                            K = function(bufnr)
                                require("telescope.actions.set").shift_selection(bufnr, -3)
                            end,
                            ["s"] = function(bufnr)
                                actions.toggle_selection(bufnr)
                                FeedKeys("j", "m")
                            end,
                            ["zz"] = center_results,
                            ["<c-q>"] = function(bufnr)
                                actions.smart_send_to_qflist(bufnr)
                                if not require("trouble").is_open("qflist") then
                                    FeedKeys("<C-q>", "m")
                                end
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
                    resume = {
                        initial_mode = "normal",
                    },
                    git_branches = {
                        initial_mode = "normal",
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
                    git_status = {
                        initial_mode = "normal",
                        layout_config = {
                            horizontal = {
                                width = 0.9,
                                height = 0.9,
                                preview_cutoff = 0,
                                prompt_position = "top",
                                preview_width = 0.7,
                            },
                        },
                        previewer = {
                            status_delta,
                            require("telescope.previewers").git_commit_message.new({}),
                            require("telescope.previewers").git_commit_diff_as_was.new({}),
                        },
                        mappings = {
                            n = {
                                J = actions.preview_scrolling_down,
                                K = actions.preview_scrolling_up,
                                ["<Tab>"] = focus_preview,
                                ["<cr>"] = goto_next_hunk_cr,
                                ["S"] = function()
                                    FeedKeys("<leader>S", "m")
                                end,
                                ["c"] = function()
                                    if utils.is_detached() then
                                        return
                                    end
                                    Open_git_commit()
                                end,
                                ["a"] = function()
                                    if utils.is_detached() then
                                        return
                                    end
                                    local result = vim.system({ "git", "status", "--short" }):wait()
                                    local has_unstaged_file = false
                                    if result.code == 0 then
                                        local results = vim.split(result.stdout, "\n", { trimempty = true })
                                        for _, line in ipairs(results) do
                                            if line:sub(1, 1) ~= "M" then
                                                has_unstaged_file = true
                                                break
                                            end
                                        end
                                    end
                                    if has_unstaged_file then
                                        vim.system({ "git", "add", "-A" }):wait()
                                    else
                                        vim.system({ "git", "reset" }):wait()
                                    end
                                    utils.refresh_telescope_git_status()
                                end,
                                ["d"] = function()
                                    if utils.is_detached() then
                                        return
                                    end
                                    local selection = action_state.get_selected_entry()
                                    vim.system({ "git", "reset", "--", selection.value }):wait()
                                    vim.system({ "git", "checkout", "--", selection.value }):wait()
                                    utils.refresh_telescope_git_status()
                                end,
                                ["D"] = function()
                                    if utils.is_detached() then
                                        return
                                    end
                                    vim.system({ "git", "reset", "--hard", "HEAD" }):wait()
                                    vim.system({ "git", "clean", "-", "fd" }):wait()
                                    utils.refresh_telescope_git_status()
                                end,
                                ["<c-p>"] = function(prompt_bufnr)
                                    if vim.g.Base_commit ~= "" then
                                        vim.notify("Detached in " .. vim.g.Base_commit_msg, vim.log.levels.WARN)
                                        return
                                    end
                                    local picker = action_state.get_current_picker(prompt_bufnr)
                                    local preview_fn = getmetatable(picker._selection_entry).previewer[1].preview_fn
                                    local previewer = picker.previewer
                                    local title = picker.layout.picker.preview_title
                                    local command
                                    if title == "Unstaged changes" then
                                        vim.g.stage_title = "Staged changes"
                                        command = {
                                            "git",
                                            "diff",
                                            "--cached",
                                            "--",
                                            picker._selection_entry.path,
                                        }
                                    else
                                        vim.g.stage_title = "Unstaged changes"
                                        command = {
                                            "git",
                                            "diff",
                                            "--",
                                            picker._selection_entry.path,
                                        }
                                    end
                                    vim.g.last_staged_title_path = picker._selection_entry.path
                                    local status = state.get_status(prompt_bufnr)
                                    preview_fn(previewer, picker._selection_entry, status, command)
                                    picker:refresh_previewer()
                                end,
                            },
                            i = {
                                ["<Tab>"] = focus_preview,
                                ["<c-o>"] = actions.git_staging_toggle,
                                ["<cr>"] = goto_next_hunk_cr,
                            },
                        },
                    },
                    git_bcommits_range = {
                        initial_mode = "normal",
                        layout_config = {
                            horizontal = {
                                width = 0.95,
                                height = 0.95,
                                preview_cutoff = 0,
                                prompt_position = "top",
                                preview_width = 0.6,
                            },
                        },
                        previewer = {
                            commit_delta,
                            require("telescope.previewers").git_commit_message.new({}),
                            require("telescope.previewers").git_commit_diff_as_was.new({}),
                        },
                        mappings = {
                            n = {
                                ["<CR>"] = gitsign_change_base,
                                ["p"] = gitsign_change_base_pre,
                                ["/"] = function()
                                    FeedKeys("l/", "m")
                                end,
                                ["c"] = function(prompt_bufnr)
                                    gitsign_change_base_pre(prompt_bufnr, function()
                                        utils.checkout(action_state.get_selected_entry().value)
                                    end)
                                end,
                            },
                            i = {
                                ["<CR>"] = gitsign_change_base,
                                ["<c-p>"] = gitsign_change_base_pre,
                            },
                        },
                    },
                    git_commits = {
                        initial_mode = "normal",
                        layout_config = {
                            horizontal = {
                                width = 0.95,
                                height = 0.95,
                                preview_cutoff = 0,
                                prompt_position = "top",
                                preview_width = 0.6,
                            },
                        },
                        previewer = {
                            commit_delta,
                            require("telescope.previewers").git_commit_message.new({}),
                            require("telescope.previewers").git_commit_diff_as_was.new({}),
                        },
                        mappings = {
                            n = {
                                J = actions.preview_scrolling_down,
                                K = actions.preview_scrolling_up,
                                ["<CR>"] = gitsign_change_base,
                                ["p"] = gitsign_change_base_pre,
                                ["/"] = function()
                                    FeedKeys("l/", "m")
                                end,
                                ["c"] = function(prompt_bufnr)
                                    gitsign_change_base_pre(prompt_bufnr, function()
                                        utils.checkout(action_state.get_selected_entry().value)
                                    end)
                                end,
                                ["l"] = focus_result,
                            },
                            i = {
                                ["<CR>"] = gitsign_change_base,
                                ["<c-p>"] = gitsign_change_base_pre,
                            },
                        },
                    },
                    find_files = {
                        disable_devicons = true,
                    },
                    lsp_implementations = {
                        entry_maker = require("custom.make_entry").gen_from_quickfix({ trim_text = true }),
                        initial_mode = "normal",
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
                        on_complete = {
                            function()
                                if vim.o.lines == 31 then
                                    require("config.utils").on_complete(
                                        "                                       ",
                                        "                                       ",
                                        16
                                    )
                                else
                                    require("config.utils").on_complete(
                                        "                                                     ",
                                        "                                                     ",
                                        18
                                    )
                                end
                            end,
                        },
                        mappings = {
                            n = {
                                ["<M-Tab>"] = function(prompt_bufnr)
                                    require("telescope.actions.set").shift_selection(prompt_bufnr, 1)
                                end,
                                ["<f19>"] = function(prompt_bufnr)
                                    actions.select_default(prompt_bufnr)
                                end,
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
