return {
    "akinsho/toggleterm.nvim",
    keys = {
        {
            "<D-k>",
            function()
                local ui = require("toggleterm.ui") -- toggleterm 的窗口/视图工具
                local terms = require("toggleterm.terminal") -- 终端列表工具
                local has_open = ui.find_open_windows() -- 当前是否有终端窗口开着
                if has_open then
                    -- 关闭前记住当前聚焦的终端 id,绕开插件 fallback-to-1 的逻辑
                    _G.toggleterm_last_id = terms.get_focused_id() or _G.toggleterm_last_id
                    vim.cmd("ToggleTerm") -- 关闭当前终端视图
                elseif _G.toggleterm_last_id and terms.get(_G.toggleterm_last_id) then
                    -- 用带 id 的命令重开上次那个终端,而不是默认的第一个
                    vim.cmd(_G.toggleterm_last_id .. "ToggleTerm")
                else
                    vim.cmd("ToggleTerm") -- 没有记录时退回默认行为
                end
            end,
            mode = { "n", "t" },
        },
    },
    cmd = {
        "ToggleTerm",
        "ToggleTermSetName",
        "ToggleTermToggleAll",
        "ToggleTermSendVisualLines",
        "ToggleTermSendCurrentLine",
        "ToggleTermSendVisualSelection",
    },
    config = function()
        local number = false
        -- Track each terminal's mode, cursor position, and view
        local term_modes = {}
        local term_cursors = {}
        local term_views = {}

        -- Build floating window title showing all terminal tabs (only when >1)
        function _G.ToggletermUpdateTitle()
            local ok, terms = pcall(function()
                return require("toggleterm.terminal").get_all()
            end)
            if not ok or not terms or #terms <= 1 then
                -- Reset title to empty when only 1 terminal
                pcall(function()
                    vim.api.nvim_win_set_config(0, { title = "" })
                end)
                return
            end

            -- Create bold highlight for current tab (inherit TabLine bg, bold fg)
            local tabline_hl = vim.api.nvim_get_hl(0, { name = "TabLine", link = false })
            vim.api.nvim_set_hl(0, "ToggleTermCurrent", {
                fg = tabline_hl.fg,
                bg = tabline_hl.bg,
                bold = true,
                italic = true,
            })

            local cur_buf = vim.api.nvim_get_current_buf()
            local title = {}
            for idx, term in ipairs(terms) do
                local name = ""
                if term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr) then
                    name = vim.b[term.bufnr].term_title or ""
                end
                if name == "" then
                    name = term.name or ("term " .. term.id)
                end
                if #name > 20 then
                    name = name:sub(1, 17) .. "..."
                end
                local is_current = term.bufnr == cur_buf
                if idx > 1 then
                    local prev_is_current = terms[idx - 1].bufnr == cur_buf
                    local sep_hl = (is_current or prev_is_current) and "Comment" or "TabLineSel"
                    table.insert(title, { "|", sep_hl })
                end
                if is_current then
                    table.insert(title, { " " .. name .. " ", "ToggleTermCurrent" })
                else
                    table.insert(title, { " " .. name .. " ", "TabLineSel" })
                end
            end
            pcall(function()
                vim.api.nvim_win_set_config(0, { title = title, title_pos = "left" })
            end)
        end

        require("toggleterm").setup({
            -- size can be a number or function which is passed the current terminal
            size = function(term)
                if term.direction == "horizontal" then
                    return 12
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            -- open_mapping = [[<f16>]],
            -- on_create = fun(t: Terminal), -- function to run when the terminal is first created
            on_open = function()
                if number then
                    vim.wo.number = true
                end
                vim.wo.scrolloff = 0
                -- Update float title to show terminal tabs
                _G.ToggletermUpdateTitle()
                vim.cmd("redraw!")
                _G.set_cursor_animation(_G.CI)
                -- We have to set the keymapping here for excluding lazygit.
                vim.keymap.set("n", "<CR>", function()
                    local cur = vim.api.nvim_win_get_cursor(0)
                    local word = vim.fn.expand("<cword>")
                    while word:match("%d") ~= nil do
                        vim.cmd("norm! b")
                        word = vim.fn.expand("<cword>")
                    end
                    local f = vim.fn.findfile(vim.fn.expand("<cfile>"))
                    if f == "" then
                        vim.api.nvim_win_set_cursor(0, { cur[1] + 1, cur[2] })
                        f = vim.fn.findfile(vim.fn.expand("<cfile>"))
                        if f == "" then
                            vim.api.nvim_win_set_cursor(0, cur)
                            return
                        end
                    end
                    FeedKeys("gF", "nx")
                    local buf = vim.api.nvim_win_get_buf(0)
                    local line = vim.api.nvim_win_get_cursor(0)[1]
                    FeedKeys("<c-o>", "nx")
                    vim.cmd("stopinsert")
                    vim.api.nvim_win_set_cursor(0, cur)
                    vim.schedule(function()
                        vim.cmd("close")
                        vim.api.nvim_win_set_buf(0, buf)
                        FeedKeys(line .. "G^", "n")
                        require("config.utils").adjust_view(0, 3)
                        vim.wo.number = true
                        vim.wo.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
                        vim.wo.signcolumn = "yes"
                    end)
                end, { buffer = 0 })
                vim.keymap.set("t", "<esc>", function()
                    _G.set_cursor_animation(0.0)
                    local term_title = vim.b.term_title
                    local line = vim.api.nvim_get_current_line()
                    local buffer_text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
                    local has_codex_prompt = buffer_text:find("›", 1, true) ~= nil
                    local has_claude_prompt = buffer_text:find("⏺", 1, true) ~= nil
                    local last_line = vim.api.nvim_buf_get_lines(
                        0,
                        vim.api.nvim_buf_line_count(0) - 2,
                        vim.api.nvim_buf_line_count(0) - 1,
                        false
                    )[1]
                    if
                        vim.startswith(line, "│")
                        or vim.startswith(term_title, "fzf")
                        or vim.startswith(term_title, "claude")
                        or vim.startswith(term_title, "⠂ Claude Code")
                        or vim.startswith(term_title, "codex")
                        or vim.startswith(term_title, "✳")
                        or vim.startswith(term_title, "Yazi")
                        or vim.startswith(term_title, "lazygit ")
                        or vim.startswith(line, "╰─────────────────────")
                        or vim.startswith(term_title, "y ")
                        or vim.endswith(last_line, "All")
                        or has_codex_prompt
                        or has_claude_prompt
                    then
                        return "<esc>"
                    end
                    return [[<C-\><C-n>]]
                end, { buffer = 0, expr = true })
                vim.keymap.set("t", "<d-l>", function()
                    FeedKeys("<c-l>", "n")
                    vim.bo.scrollback = 1
                    vim.bo.scrollback = 100000
                end, { buffer = true })
                vim.keymap.set("t", "<C-_>", function()
                    vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x1f") -- send raw Ctrl-_ to the terminal process
                end, { buffer = true })
                vim.keymap.set("t", "<c-p>", function()
                    FeedKeys([[<C-\><C-n>]], "n")
                    require("telescope").extensions["neovim-project"].history({
                        on_complete = {
                            function()
                                if vim.o.lines == 31 or vim.o.lines == 30 then
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
                        FeedKeys("a", "t")
                    end)
                end, { buffer = true })

                vim.keymap.set("t", "<c-s-p>", function()
                    local term_title = vim.b.term_title
                    local has_codex_prompt = table
                        .concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
                        :find("›", 1, true) ~= nil
                    if (term_title and vim.startswith(term_title, "codex")) or has_codex_prompt then
                        FeedKeys("<c-\\><c-n>k", "n")
                        vim.defer_fn(function()
                            vim.fn.search("› ", "b")
                            _G.no_animation()
                        end, 20)
                    else
                        -- › Improve documentation in @filename
                        FeedKeys("<c-\\><c-n>", "n")
                        vim.defer_fn(function()
                            vim.fn.search("⏺ ", "b")
                            _G.no_animation()
                        end, 20)
                    end
                end, { buffer = true })
                vim.keymap.set("t", "<c-s-y>", function()
                    FeedKeys("<c-j>", "n")
                end, { buffer = true })
                vim.keymap.set("t", "<c-[>", function()
                    _G.set_cursor_animation(0.0)
                    return [[<C-\><C-n>]]
                end, { buffer = true, expr = true })
                vim.keymap.set("t", "<c-cr>", function()
                    FeedKeys("\\", "n")
                    vim.defer_fn(function()
                        FeedKeys("<CR>", "n")
                    end, 2)
                end, { buffer = true })
                vim.keymap.set("t", "<c-s-d>", function()
                    _G.restore_animation()
                    return "<c-8>"
                end, { buffer = true, expr = true })
                -- Helper: save current terminal's mode, cursor, and view; restore on switch
                local function save_current_term_state()
                    local cur_buf = vim.api.nvim_get_current_buf()
                    local terms = require("toggleterm.terminal").get_all()
                    for _, term in ipairs(terms) do
                        if term.bufnr == cur_buf then
                            term_modes[term.id] = (vim.fn.mode() == "t")
                            term_cursors[term.id] = vim.api.nvim_win_get_cursor(0)
                            term_views[term.id] = vim.fn.winsaveview()
                            break
                        end
                    end
                end
                local function restore_term_state(target_id)
                    vim.schedule(function()
                        if term_modes[target_id] == false then
                            _G.set_cursor_animation(0.0)
                            vim.cmd("stopinsert")
                            if term_views[target_id] then
                                vim.fn.winrestview(term_views[target_id])
                            end
                            if term_cursors[target_id] then
                                pcall(vim.api.nvim_win_set_cursor, 0, term_cursors[target_id])
                            end
                        else
                            vim.cmd("startinsert")
                        end
                    end)
                end
                -- Switch to terminal by position (1st/2nd/3rd tab in the list)
                local function switch_term_by_index(idx)
                    local terms = require("toggleterm.terminal").get_all()
                    if idx > #terms then
                        return
                    end
                    local target = terms[idx]
                    if target then
                        save_current_term_state()
                        vim.cmd(target.id .. "ToggleTerm")
                        restore_term_state(target.id)
                    end
                end
                vim.keymap.set({ "n", "t" }, "<d-1>", function()
                    switch_term_by_index(1)
                end, { buffer = 0, desc = "Switch to terminal 1" })
                vim.keymap.set({ "n", "t" }, "<d-2>", function()
                    switch_term_by_index(2)
                end, { buffer = 0, desc = "Switch to terminal 2" })
                vim.keymap.set({ "n", "t" }, "<d-3>", function()
                    switch_term_by_index(3)
                end, { buffer = 0, desc = "Switch to terminal 3" })
                vim.keymap.set({ "n", "t" }, "<d-4>", function()
                    switch_term_by_index(4)
                end, { buffer = 0, desc = "Switch to terminal 4" })
                vim.keymap.set({ "n", "t" }, "<d-5>", function()
                    switch_term_by_index(5)
                end, { buffer = 0, desc = "Switch to terminal 5" })

                -- Cmd+T to create a new terminal tab
                local function new_term_tab()
                    save_current_term_state()
                    local terms = require("toggleterm.terminal").get_all()
                    local max_id = 0
                    for _, term in ipairs(terms) do
                        if term.id > max_id then
                            max_id = term.id
                        end
                    end
                    local new_id = max_id + 1
                    term_modes[new_id] = true -- new terminals start in insert
                    vim.cmd(new_id .. "ToggleTerm")
                    vim.defer_fn(function()
                        _G.ToggletermUpdateTitle()
                    end, 150)
                    restore_term_state(new_id)
                end
                vim.keymap.set("n", "<D-t>", new_term_tab, { buffer = 0, desc = "New terminal tab" })
                vim.keymap.set("t", "<D-t>", new_term_tab, { buffer = 0, desc = "New terminal tab" })
                -- Cmd+] / Cmd+[ to go to next/prev terminal
                local function go_next_term()
                    local terms = require("toggleterm.terminal").get_all()
                    if #terms <= 1 then
                        return
                    end
                    save_current_term_state()
                    local cur_buf = vim.api.nvim_get_current_buf()
                    for i, term in ipairs(terms) do
                        if term.bufnr == cur_buf then
                            local next_idx = (i % #terms) + 1
                            local target = terms[next_idx]
                            vim.cmd(target.id .. "ToggleTerm")
                            restore_term_state(target.id)
                            return
                        end
                    end
                end
                local function go_prev_term()
                    local terms = require("toggleterm.terminal").get_all()
                    if #terms <= 1 then
                        return
                    end
                    save_current_term_state()
                    local cur_buf = vim.api.nvim_get_current_buf()
                    for i, term in ipairs(terms) do
                        if term.bufnr == cur_buf then
                            local prev_idx = ((i - 2) % #terms) + 1
                            local target = terms[prev_idx]
                            vim.cmd(target.id .. "ToggleTerm")
                            restore_term_state(target.id)
                            return
                        end
                    end
                end
                vim.keymap.set({ "n", "t" }, "<D-]>", go_next_term, { buffer = 0, desc = "Next terminal tab" })
                vim.keymap.set({ "n", "t" }, "<D-[>", go_prev_term, { buffer = 0, desc = "Prev terminal tab" })
                -- Cmd+W to close current terminal and focus the previous one
                local function close_current_term()
                    vim.cmd("stopinsert")
                    FeedKeys("<space>bd", "m")
                    vim.schedule(function()
                        FeedKeys("<d-k>", "m")
                    end)
                end
                vim.keymap.set({ "n", "t" }, "<D-w>", close_current_term, { buffer = 0, desc = "Close terminal tab" })
            end,
            on_close = function()
                if vim.api.nvim_buf_get_name(0):find("#toggleterm") ~= nil then
                    vim.o.scrolloff = 6
                    number = vim.wo.number
                end
            end, -- function to run when the terminal closes
            -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
            -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
            -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
            hide_numbers = false, -- hide the number column in toggleterm buffers
            shade_filetypes = {},
            autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
            highlights = {
                -- highlights which map to a highlight group name and a table of it's values
                -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
                Normal = {
                    link = "Normal",
                },
                FloatBorder = {
                    link = "FloatBorder",
                },
                -- FloatBorder = {
                --     guifg = "<VALUE-HERE>",
                --     guibg = "<VALUE-HERE>",
                -- },
            },
            open_mapping = [[<f16>]],
            shade_terminals = false, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
            -- shading_factor = "<number>", -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
            start_in_insert = true,
            insert_mappings = true, -- whether or not the open mapping applies in insert mode
            terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
            persist_size = true,
            persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
            direction = "float",
            close_on_exit = true, -- close the terminal window when the process exits
            -- Change the default shell. Can be a string or a function returning a string
            shell = vim.o.shell,
            auto_scroll = false, -- automatically scroll to the bottom on terminal output
            -- This field is only relevant if direction is set to 'float'
            float_opts = {
                -- The border key is *almost* the same as 'nvim_open_win'
                -- see :h nvim_open_win for details on borders however
                -- the 'curved' border is a custom border type
                -- not natively supported but implemented in this plugin.
                border = vim.g.neovide and "solid" or "rounded",
                -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
                width = function()
                    return math.floor(vim.o.columns * 0.8)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.9)
                end,
                winblend = 5,
                zindex = 50,
                title_pos = "left",
            },
            winbar = {
                enabled = false,
            },
        })
    end,
}
