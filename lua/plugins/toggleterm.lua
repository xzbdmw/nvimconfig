return {
    "akinsho/toggleterm.nvim",
    keys = {
        {
            "<D-k>",
            "<Cmd>ToggleTerm<CR>",
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
                vim.b.minihipatterns_config = {
                    highlighters = {
                        -- at ./src/sql/parser/mod.rs:436:9
                        fixme = { pattern = " at .*:?%d?:?%d?", group = "Links" },
                    },
                }
                require("mini.hipatterns").enable()
                vim.keymap.set("t", "<esc>", function()
                    _G.set_cursor_animation(0.0)
                    local term_title = vim.b.term_title
                    local line = vim.api.nvim_get_current_line()
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
                        or vim.startswith(term_title, "codex")
                        or vim.startswith(term_title, "✳")
                        or vim.startswith(term_title, "Yazi")
                        or vim.startswith(term_title, "lazygit ")
                        or vim.startswith(line, "╰─────────────────────")
                        or vim.startswith(term_title, "y ")
                        or vim.endswith(last_line, "All")
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
                    return math.floor(vim.o.columns * 0.7)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.8)
                end,
                winblend = 5,
                zindex = 50,
                title_pos = "left",
            },
            winbar = {
                enabled = true,
                name_formatter = function(term) --  term: Terminal
                    return term.name
                end,
            },
        })
    end,
}
