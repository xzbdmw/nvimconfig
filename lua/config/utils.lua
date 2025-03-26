local M = {}
_G.FeedKeys = function(keymap, mode)
    api.nvim_feedkeys(api.nvim_replace_termcodes(keymap, true, false, true), mode, false)
end

_G.set_cursor_animation = function(len)
    local mode = vim.api.nvim_get_mode().mode
    if (mode == "n" or mode == "nt") and len > 0 then
        return
    else
        vim.g.neovide_cursor_animation_length = len
    end
end

local function get_normal_bg_color()
    local normal_hl = api.nvim_get_hl_by_name("Normal", true)
    local bg_color = string.format("#%06x", normal_hl.background)
    return bg_color
end

function M.gitsign_try_nav_first(title)
    title = title or ""
    local ok = false
    local fn = function()
        if ok then
            return
        end
        local hunks = require("gitsigns.actions").get_hunks(api.nvim_get_current_buf())
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

function M.get_cword()
    local mode = api.nvim_get_mode()
    local w
    if mode.mode == "v" or mode.mode == "V" then
        vim.cmd([[noautocmd sil norm! "vy]])
        w = vim.fn.getreg("v")
    else
        w = vim.fn.expand("<cword>")
    end
    return w
end

function M.load_appropriate_theme()
    local bg_color = get_normal_bg_color()
    if bg_color == "#24273a" then
        require("theme.dark")
    else
        require("theme.light")
    end
end

function M.hide_cursor()
    pcall(api.nvim_set_hl, 0, "Cursor", _G.hide_cursor_hl())
end

function M.show_cursor(timeout)
    timeout = timeout or 1
    local old_hl = _G.curosr_hl
    old_hl.blend = 0
    if timeout == 1 then
        vim.defer_fn(function()
            pcall(api.nvim_set_hl, 0, "Cursor", old_hl)
        end, timeout)
    else
        pcall(api.nvim_set_hl, 0, "Cursor", old_hl)
    end
end

function _G.hide_cursor(callback, timeout)
    callback()
    M.show_cursor(timeout)
end

function M.close_any_trouble_window()
    local ret = false
    if require("trouble").is_open("qflist") then
        vim.cmd("Trouble qflist toggle focus=false")
        ret = true
    elseif require("trouble").is_open("mydiags") then
        vim.cmd("Trouble mydiags toggle filter.buf=0 focus=false")
        ret = true
    end
    return ret
end

function M.refresh_telescope_git_status()
    local windows = vim.api.nvim_list_wins()
    local prompt_bufnr = nil
    for _, window in ipairs(windows) do
        local b = vim.api.nvim_win_get_buf(window)
        local ft = vim.bo[b].filetype
        if ft == "TelescopePrompt" then
            prompt_bufnr = b
            break
        end
    end
    if prompt_bufnr ~= nil then
        local action_state = require("telescope.actions.state")
        local picker = action_state.get_current_picker(prompt_bufnr)

        -- temporarily register a callback which keeps selection on refresh
        local selection = picker:get_selection_row()
        local callbacks = { unpack(picker._completion_callbacks) } -- shallow copy
        picker:register_completion_callback(function(self)
            self:set_selection(selection)
            self._completion_callbacks = callbacks
        end)

        -- refresh
        picker:refresh(vim.g.git_finer(), { reset_prompt = false })
    end
end

function M.is_detached()
    if vim.g.Base_commit ~= "" then
        vim.notify("Branch is detached", vim.log.levels.WARN)
        return true
    end
    return false
end

function M.git_root()
    local root_spec = vim.uv.cwd()
    local f_buf = _G.lazygit_previous_win == nil and 0 or vim.api.nvim_win_get_buf(_G.lazygit_previous_win)
    if vim.b[f_buf].lib == true then
        local pathes = vim.fs.find(".git", {
            path = vim.api.nvim_buf_get_name(f_buf),
            upward = true,
            limit = math.huge,
            type = "directory",
        })
        if pathes == nil or #pathes == 0 then
            vim.notify("No Git Root found", vim.log.levels.WARN)
        else
            root_spec = vim.fs.dirname(pathes[1])
        end
    end
    return root_spec
end

function Open_git_commit()
    local root_spec = M.git_root()
    vim.system({ "git", "commit" }, { cwd = root_spec }):wait()
    local previous_win = vim.api.nvim_get_current_win()
    local previous_buf = vim.api.nvim_win_get_buf(previous_win)
    local file_path = root_spec .. "/.git/COMMIT_EDITMSG"
    local filetype = vim.bo[previous_buf].filetype
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_call(buf, function()
        vim.cmd("e " .. file_path)
    end)
    vim.keymap.set("n", "q", function()
        vim.cmd(string.format("bw! %d", buf))
    end, { buffer = buf })
    local function modify_commit_message(bufnr)
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local new_lines = {}
        table.insert(new_lines, "")
        local start_collecting = false

        for _, line in ipairs(lines) do
            if line:match("^# Changes to be committed:") then
                start_collecting = true
            end
            if start_collecting then
                table.insert(new_lines, line)
            end
        end

        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
    end
    modify_commit_message(buf)

    if filetype == "lazyterm" or filetype == "TelescopePrompt" or filetype == "TelescopeResults" then
        local winid = vim.api.nvim_open_win(buf, true, {
            style = "minimal",
            row = 10,
            col = math.ceil((vim.o.columns - 60) / 2),
            width = 60,
            height = 10,
            relative = "editor",
            border = vim.g.neovide and "solid" or "rounded",
        })
        vim.wo.signcolumn = "no"
        local finish = function()
            _G.hide_cursor(function() end)
            vim.schedule(M.refresh_telescope_git_status)
        end
        vim.api.nvim_create_autocmd("WinClosed", {
            once = true,
            pattern = tostring(winid),
            callback = finish,
        })
    else
        vim.api.nvim_open_win(buf, true, {
            height = 12,
            split = "below",
        })
    end
end

function M.close_win()
    if vim.g.scrollback == true then
        vim.cmd("qa!")
    end
    if vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "" then
        FeedKeys("q", "n")
        return
    end
    if M.has_namespace("gitsigns_preview_inline") then
        api.nvim_exec_autocmds("User", {
            pattern = "ESC",
        })
        return
    end
    if M.has_filetype("gitcommit") then
        vim.cmd("close")
        return
    end
    if M.has_filetype("help") then
        vim.api.nvim_win_close(M.filetype_windowid("help"), true)
        return
    end
    if M.has_filetype("qf") then
        vim.cmd("cclose")
        return
    end
    if M.has_filetype("noice") then -- close :messages window
        local winid = M.filetype_windowid("noice")
        if api.nvim_win_get_config(winid).zindex == nil then
            api.nvim_win_close(winid, true)
            return
        end
    end
    if M.has_filetype("toggleterm") then
        FeedKeys("<f16>", "m")
        return
    end
    if M.has_filetype("trouble") and M.close_any_trouble_window() then
        return
    end
    if require("config.utils").has_filetype("gitsigns.blame") then
        FeedKeys("<Tab>q<d-1>", "m")
        return
    end
    if M.has_namespace("gitsigns_signs_staged", "highlight") or M.has_namespace("gitsigns_signs_", "highlight") then
        FeedKeys("<leader>si", "m")
        return
    end
    local nvimtree_present = false
    for _, win_id in ipairs(api.nvim_list_wins()) do
        local buf_id = api.nvim_win_get_buf(win_id)
        local buf_name = api.nvim_buf_get_name(buf_id)
        if string.find(buf_name, "NvimTree") then
            nvimtree_present = true
            break
        end
    end
    local win_amount = M.get_non_float_win_count()
    if win_amount == 1 or (nvimtree_present and win_amount == 2) then
        vim.cmd("BufDel")
    else
        local windows = api.nvim_list_wins()
        local is_split = false

        for _, win in ipairs(windows) do
            local success, win_config = pcall(api.nvim_win_get_config, win)
            if success then
                if win_config.relative ~= "" then
                    goto continue
                end
            end
            local win_height = api.nvim_win_get_height(win)
            ---@diagnostic disable-next-line: deprecated
            local screen_height = api.nvim_get_option("lines")
            if win_height + 1 < screen_height then
                is_split = true
                break
            end
            ::continue::
        end

        if is_split then
            vim.cmd("set laststatus=0")
        end
        _G.hide_cursor(function()
            if M.check_splits() then
                vim.cmd("close")
            else
                vim.cmd("BufDel")
            end
        end)
    end
end

function M.noice_incsearch_at_start()
    local noice = require("noice.ui.cmdline")
    local cursor = noice.position.cursor
    return cursor
end

function M.cursor_char()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local x = vim.api.nvim_buf_get_text(0, row - 1, col, row - 1, col + 1, {})
    return x[1]
end

function M.try_wrap()
    if require("multicursor-nvim").numCursors() > 1 then
        local cursor_char = require("config.utils").cursor_char()
        for _, v in ipairs({ "(", "{", "[", "<", '"', "'", ")", "}", ">", "]" }) do
            if cursor_char == v then
                require("clasp").wrap("next")
                return true
            end
        end
    end
    return false
end

function M.fold_method_diff()
    local tabnum = vim.fn.tabpagenr()
    if tabnum ~= 1 then
        return true
    end
    local win = vim.api.nvim_get_current_win()
    if not vim.api.nvim_win_is_valid(win) then
        return true
    end
    local fdm = vim.wo[win].foldmethod
    if fdm == "diff" then
        return true
    end
    return false
end

function M.get_non_float_win_count()
    local window_count = #api.nvim_list_wins()
    for _, win in pairs(api.nvim_list_wins()) do
        local success, win_config = pcall(api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                window_count = window_count - 1
            end
        end
    end
    return window_count
end

local has_map = false
local original_keymaps = {}

function M.insert_C_R()
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local ns = api.nvim_create_namespace("<c-r>paste")
    api.nvim_buf_set_extmark(0, ns, row - 1, col, {
        virt_text = {
            { '"', "PasteHint" },
        },
        virt_text_pos = "inline",
        strict = false,
    })
    local key_ns = api.nvim_create_namespace("on_key")
    local count = 0
    vim.on_key(function(key)
        count = count + 1
        if count == 3 then
            if key == "\27" then
                vim.cmd("stopinsert")
            end
            api.nvim_buf_clear_namespace(0, ns, 0, -1)
            vim.on_key(nil, key_ns)
        end
    end, key_ns)
end

function M.insert_paste()
    if not M.mini_snippets_active() then
        vim.o.eventignore = "TextChangedI"
    end
    _G.no_animation(_G.CI)
    local cur_line = api.nvim_get_current_line()
    local _, first_char = cur_line:find("^%s*")
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local s = api.nvim_buf_get_text(0, row - 1, 0, row - 1, col, {})[1]
    local e = api.nvim_buf_get_text(0, row - 1, col, row - 1, #cur_line, {})[1]
    local is_empty = first_char == col
    local body = vim.fn.getreg('"')
    local lines = vim.split(body, "\n", { plain = false, trimempty = true })
    if lines == nil or lines[#lines] == nil then
        return
    end
    if #lines == 1 then
        FeedKeys(vim.trim(body), "n")
    else
        local last_col = #lines[#lines]
        if not is_empty then
            lines[1] = s .. lines[1]
        end
        lines[#lines] = lines[#lines] .. e
        vim.cmd('norm! "_dd')
        api.nvim_win_set_cursor(0, { row == 1 and 1 or row - 1, 0 })
        if row == 1 then
            api.nvim_put(lines, "l", false, true)
        else
            api.nvim_put(lines, "l", true, true)
        end
        api.nvim_win_set_cursor(0, { row + #lines - 1, last_col })
    end
    _G.indent_update()
    vim.schedule(function()
        vim.o.eventignore = ""
    end)
end

function M.insert_mode_space()
    _G.no_animation()
    if has_map or api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return
    end
    -- stylua: ignore
    local changed_keys = { ["<Esc>"] = "<esc>", ["<C-A>"] = "a", ["<C-B>"] = "b", ["<C-C>"] = "c", ["<C-D>"] = "d", ["<C-E>"] = "e", ["<C-F>"] = "f", ["<C-G>"] = "g", ["<C-H>"] = "h", ["<C-I>"] = "i", ["<C-J>"] = "j", ["<C-K>"] = "k", ["<C-L>"] = "l", ["<C-M>"] = "m", ["<C-N>"] = "n", ["<C-O>"] = "o", ["<C-P>"] = "p", ["<C-Q>"] = "q", ["<C-R>"] = "r", ["<C-S>"] = "s", ["<C-T>"] = "t", ["<C-U>"] = "u", ["<C-V>"] = "v", ["<C-W>"] = "w", ["<C-X>"] = "x", ["<C-Y>"] = "y", ["<C-Z>"] = "z" }

    original_keymaps = vim.api.nvim_get_keymap("i")

    for k, v in pairs(changed_keys) do
        vim.keymap.set("i", k, function()
            if v == "<esc>" then
                local key_comb = "."
                FeedKeys("<bs>" .. key_comb, "n")
            else
                local key_comb = "." .. v
                FeedKeys("<bs>" .. key_comb, "n")
            end
        end, { desc = "dot" })
    end

    has_map = true

    local allowed_fields = {
        noremap = true,
        nowait = true,
        silent = true,
        script = true,
        expr = true,
        unique = true,
        callback = true,
        desc = true,
        replace_keycodes = true,
    }

    local function remove_extra_fields(tbl)
        for key in pairs(tbl) do
            if not allowed_fields[key] then
                tbl[key] = nil
            end
        end
    end

    vim.defer_fn(function()
        for _, m in ipairs(api.nvim_get_keymap("i")) do
            if m.desc == "dot" then
                vim.keymap.del("i", m.lhs)
            end
        end

        for _, map in pairs(original_keymaps) do
            for k in pairs(changed_keys) do
                if map.lhs == k then
                    local rhs = tostring(map.rhs)
                    local should_map = map.rhs ~= map.lhs
                    remove_extra_fields(map)
                    if should_map then
                        api.nvim_set_keymap("i", k, rhs, map)
                    end
                    break
                end
            end
        end
        has_map = false
    end, 150)
    vim.defer_fn(function()
        local cmp = require("cmp")
        vim.keymap.set("i", "<esc>", function()
            if cmp.visible() then
                vim.schedule(function()
                    cmp.close()
                end)
            end
            return "<esc>"
        end, { expr = true })
    end, 200)
end

function M.mini_snippets_active()
    if vim.g.snippet_expand == true then
        return true
    end
    local cursor = vim.api.nvim_win_get_cursor(0)
    local extmarks =
        vim.api.nvim_buf_get_extmarks(0, vim.api.nvim_create_namespace("MiniSnippetsNodes"), 0, -1, { details = true })
    for _, mark in ipairs(extmarks) do
        local detail = mark[4]
        if detail.hl_group == "MiniSnippetsCurrentReplace" and mark[3] == cursor[2] and mark[2] + 1 == cursor[1] then
            return true
        end
    end
    return false
end

function M.has_namespace(name_space, type)
    local ns = api.nvim_create_namespace(name_space)
    local extmark
    if type then
        extmark = api.nvim_buf_get_extmarks(0, ns, { 0, 0 }, { -1, -1 }, { type = type })
    else
        extmark = api.nvim_buf_get_extmarks(0, ns, { 0, 0 }, { -1, -1 }, {})
    end
    return extmark ~= nil and #extmark ~= 0
end

function M.normal_tab()
    local flag = false
    local window_count = M.get_non_float_win_count()
    local current_win = api.nvim_get_current_win()
    for _, win in pairs(api.nvim_list_wins()) do
        local success, win_config = pcall(api.nvim_win_get_config, win)
        if success then
            -- if this win is float_win and is focusable
            if win_config.relative ~= "" and win_config.focusable then
                -- if this win isn't current_win
                if
                    current_win ~= win
                    and win_config.zindex ~= 20
                    and win_config.zindex ~= 60
                    and win_config.width ~= 1
                    and win_config.zindex ~= 51
                    and win_config.zindex ~= 52
                then
                    -- change flag to indicate that we have change current_win, so no need to cycle
                    flag = true
                    api.nvim_set_current_win(win)
                    return
                end
            end
        end
    end
    if flag == false and window_count ~= 2 then
        local cur = api.nvim_get_current_win()
        local ok = true
        while ok do
            vim.cmd("wincmd w")
            local buf = api.nvim_get_current_buf()
            local new_win = api.nvim_get_current_win()
            if new_win == cur then
                break
            end
            local ft = vim.bo[buf].filetype
            if ft == "NvimTree" then
                ok = true
            else
                ok = false
            end
        end
    elseif flag == false then
        vim.cmd("wincmd w")
    end
end

function M.onTypeFormatting()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    local c = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})
    local params = {
        textDocument = {
            uri = vim.uri_from_bufnr(0), -- Use the current buffer's URI
        },
        position = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(0)).position, -- Get the current cursor position
        ch = c[1], -- Example trigger character that triggers the formatting
        options = {
            tabSize = 4,
            insertSpaces = true, -- Use spaces instead of tabs
        },
    }
    vim.lsp.buf_request(0, "textDocument/onTypeFormatting", params, function(err, result)
        if err then
            print("Error formatting: " .. err.message)
        else
            if result then
                for _, edit in ipairs(result) do
                    if (edit.newText == ">" or edit.newText == ";") and edit.range.start.line == row - 1 then
                        local distance = edit.range.start.character - col
                        FeedKeys(
                            string.rep("<c-g>U<right>", distance)
                                .. edit.newText
                                .. string.rep("<c-g>U<left>", distance + 1),
                            "n"
                        )
                    else
                        vim.lsp.util.apply_text_edits({ edit }, api.nvim_get_current_buf(), "utf-8")
                    end
                end
            end
        end
    end)
end

function M.once(callback)
    local done = false
    if done then
        return
    end
    done = true
    callback()
end

function M.commented()
    -- This is the commentstring in the current buffer, e.g. "# %s" for shell scripts
    local comment_str = vim.bo.commentstring
    -- If comment_str = "# %s", the marker is "#"
    -- If comment_str = "// %s", the marker is "//"

    -- We need to extract the part before '%s'
    local marker = comment_str:match("^(.*)%%s")
    if not marker or marker == "" then
        -- We might not have a well-defined commentstring, or it might be something multi-line like "/* %s */"
        return false
    end

    local line = vim.api.nvim_get_current_line()
    local trimmed = line:match("^%s*(.-)$")

    -- Check if line starts with the marker
    return trimmed:match("^" .. vim.pesc(marker)) ~= nil
end

function M.search(mode)
    vim.defer_fn(function()
        local id
        id = api.nvim_create_autocmd("CmdlineChanged", {
            once = true,
            callback = function()
                vim.o.scrolloff = 999
            end,
        })
        vim.api.nvim_create_autocmd("CmdlineLeave", {
            once = true,
            callback = function()
                pcall(function()
                    vim.api.nvim_del_autocmd(id)
                end)
            end,
        })
    end, 10)
    pcall(function()
        vim.cmd("Noice disable")
    end)
    _G.parent_winid = vim.api.nvim_get_current_win()
    _G.parent_bufnr = vim.api.nvim_get_current_buf()
    _G.searchmode = mode
    return mode .. [[\V]], "n"
end

function M.is_big_file(bufnr)
    if not api.nvim_buf_is_valid(bufnr) then
        return true
    end
    local big_file = vim.b[bufnr].bigfile_detected
    if big_file ~= nil and big_file == 1 then
        return true
    end
end

function M.insert_mode_tab()
    _G.no_animation(_G.CI)
    local col = vim.fn.col(".") - 1
    ---@diagnostic disable-next-line: param-type-mismatch
    local line = vim.fn.getline(".")
    local line_len = #line
    if col == line_len then
        FeedKeys("<Tab>", "n")
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    if col == 0 or vim.fn.getline("."):sub(1, col):match("^%s*$") then
        FeedKeys("<Tab>", "n")
    else
        FeedKeys("<c-g>U<right>", "n")
    end
end

local denied_filetype_winbar = { "undotree", "diff" }
_G.set_winbar = function(winbar, winid)
    pcall(function()
        local tabpage = api.nvim_get_current_tabpage()
        if tabpage ~= 1 then
            return
        end
        local buf = winid and api.nvim_win_get_buf(winid) or 0
        winid = winid or api.nvim_get_current_win()
        local winconfig = api.nvim_win_get_config(winid)
        if winconfig.relative ~= "" and winconfig.zindex == 11 then -- disable in arrow marks
            return
        end
        if vim.tbl_contains(denied_filetype_winbar, vim.bo[buf].filetype) then
            return
        end
        vim.wo[winid].winbar = winbar
    end)
end

M.prev_match_win = nil
function M.get_visual()
    if not vim.fn.mode():find("[vV\x16]") then
        return
    end
    local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
    if vim.fn.mode() == "\x16" and #text > 1 then
        return
    end
    return table.concat(text, "\n")
end

function M.clear()
    if not M.prev_match_win then
        return
    end
    for k, v in pairs(M.prev_match_win) do
        pcall(vim.fn.matchdelete, v, k)
    end
    M.prev_match_win = nil
end

function M.do_highlight(buf)
    if api.nvim_get_current_buf() ~= buf or require("multicursor-nvim").numCursors() > 1 then
        return
    end
    local count = vim.api.nvim_buf_line_count(buf)
    if count > 10000 then
        return
    end
    M.clear()
    local text = M.get_visual()
    if not text or vim.trim(text) == "" or #text < 2 then
        return
    end
    if vim.fn.type(text) == 10 then
        return
    end
    M.prev_match_win = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local id = vim.fn.matchadd(
            "LighterVisual",
            "\\M" .. vim.trim(text:gsub("\\", "\\\\"):gsub("\n", "\\n")),
            100,
            -1,
            { window = win }
        )
        M.prev_match_win[win] = id
    end
end

M.speedup_newline = function(animation)
    TST = vim.uv.hrtime()
    _G.set_cursor_animation(animation)
    vim.g.type_o = true
    vim.o.eventignore = "TextChanged,TextChangedI"
    vim.schedule(function()
        vim.o.eventignore = ""
        vim.g.type_o = false
        local ok, async = pcall(require, "gitsigns.async")
        if ok then
            local manager = require("gitsigns.manager")
            local debounce_trailing = require("gitsigns.debounce").debounce_trailing
            debounce_trailing(1, async.create(1, manager.update))(api.nvim_get_current_buf())
        end
        pcall(_G.indent_update)
        pcall(_G.mini_indent_auto_draw)
    end)
    vim.defer_fn(function()
        _G.set_cursor_animation(_G.CI)
    end, 20)
end

M.smart_newline = function(animation, direction)
    M.speedup_newline(animation)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local above = api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    local below = api.nvim_buf_get_lines(0, row, row + 1, false)[1]
    if direction == "O" then
        above = api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1]
        below = api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    end
    if above == nil or below == nil then
        return direction
    end
    local ae, be = above:sub(#above, #above), below:sub(#below, #below)
    if vim.bo.filetype == "lua" and (ae == "," or ae == "{") and (be == "," or be == "{") then
        if require("multicursor-nvim").numCursors() > 1 then
            return direction .. ",<c-g>U<left><esc>a"
        else
            return direction .. ",<c-g>U<left>"
        end
    else
        return vim.fn.getreginfo('"').regtype == "v" and direction .. " <BS>" or direction
    end
end

function M.try_update_visual_coloum()
    local mode = vim.api.nvim_get_mode().mode
    if vim.wo.signcolumn ~= "yes" then
        return
    end
    if mode == "v" or mode == "V" then
        local s, e = vim.fn.line("."), vim.fn.line("v")
        local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
        local t
        if s > e then
            t = s
            s = e
            e = t
        end
        local ns = api.nvim_create_namespace("visual_range")
        api.nvim_buf_clear_namespace(0, ns, 0, -1)
        for i = s, e do
            if vim.startswith(vim.fn.getline(i), text[i - s + 1]) then
                api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
                    end_row = i,
                    strict = false,
                    virt_text = { { "", "Hl" } },
                    priority = 1,
                })
            end
        end
    end
    _G.indent_update()
end

function M.record_winbar_enter()
    vim.g.winbar_macro_beginstate = vim.wo.winbar

    local typed_sequnce = ""
    local function winbar_macro(typed)
        typed_sequnce = typed_sequnce .. typed
        local winbar = vim.g.winbar_macro_beginstate
        local index = string.find(winbar, [[%=]], nil, true)
        local new_winbar
        local name = " %#MacroWinabr# " .. "%#FlashPrompt#" .. typed_sequnce .. "%#Normal#" .. " "
        if index == nil then
            new_winbar = winbar .. name
        else
            new_winbar = winbar:sub(1, index - 1) .. name .. winbar:sub(index)
        end
        _G.set_winbar(new_winbar)
    end

    local function string_to_bytes(str)
        local bytes = {}
        for i = 1, #str do
            table.insert(bytes, string.byte(str, i))
        end
        return bytes
    end

    local function translate_raw_key(typed)
        local bytes = string_to_bytes(typed)
        if bytes[1] == 128 and bytes[2] == 252 and bytes[3] == 4 then
            typed = "^" .. string.char(bytes[4])
        end
        if bytes[1] == 128 and bytes[2] == 252 and bytes[3] == 128 then
            typed = "<D-" .. string.char(bytes[4]) .. ">"
        end
        if bytes[1] == 128 and bytes[2] == 107 then
            if bytes[3] == 108 then
                typed = "<left>"
            elseif bytes[3] == 114 then
                typed = "<right>"
            elseif bytes[3] == 117 then
                typed = "<up>"
            elseif bytes[3] == 100 then
                typed = "<down>"
            end
        end
        if bytes[1] == 27 then
            typed = "<esc>"
        end
        return typed
    end

    winbar_macro("")
    vim.on_key(function(_, typed)
        typed = translate_raw_key(typed)
        if api.nvim_buf_get_option(0, "buftype") ~= "prompt" then
            winbar_macro(typed)
        end
    end, api.nvim_create_namespace("winbar_macro"))
end

function M.checkSplitAndSetLaststatus()
    local windows = api.nvim_list_wins()
    local is_split = false
    for _, win in ipairs(windows) do
        local success, win_config = pcall(api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                goto continue
            end
        end
        local win_height = api.nvim_win_get_height(win)
        ---@diagnostic disable-next-line: deprecated
        local screen_height = api.nvim_get_option("lines")
        if win_height + 1 < screen_height then
            is_split = true
            break
        end
        ::continue::
    end

    if is_split then
        vim.cmd("set laststatus=3")
    else
        vim.cmd("set laststatus=0")
    end
end

function M.setUndotreeWinSize()
    local api = api
    local winList = api.nvim_list_wins()
    for _, winHandle in ipairs(winList) do
        if
            api.nvim_win_is_valid(winHandle)
            ---@diagnostic disable-next-line: deprecated
            and api.nvim_buf_get_option(api.nvim_win_get_buf(winHandle), "filetype") == "undotree"
        then
            api.nvim_win_set_width(winHandle, 33)
        end
    end
end

function M.update_preview_state(bufnr, winid)
    local times = { 0, 10, 20, 30, 50 }
    for _, timeout in ipairs(times) do
        vim.defer_fn(function()
            pcall(function()
                require("treesitter-context").context_force_update(bufnr, winid)
                pcall(_G.indent_update, winid)
            end)
        end, timeout)
    end
end

function M.delete_z()
    local modes = { "n", "x" }
    for _, mode in ipairs(modes) do
        local keymaps = vim.api.nvim_get_keymap(mode)
        for _, map in ipairs(keymaps) do
            if map.lhs:sub(1, 1) == "z" and string.len(map.lhs) > 1 then
                vim.keymap.del(mode, map.lhs)
            end
        end
    end
end

function M.set_glance_keymap()
    local winconfig = api.nvim_win_get_config(0)
    local bufnr = api.nvim_get_current_buf()
    if winconfig.relative ~= "" and winconfig.zindex == 10 then
        if _G.glance_buffer[bufnr] ~= nil then
            return
        end

        local function glance_close()
            pcall(satellite_close, api.nvim_get_current_win())
            pcall(require("treesitter-context").close_stored_win, api.nvim_get_current_win())
            Close_with_q()
            vim.defer_fn(function()
                pcall(_G.indent_update)
                pcall(_G.mini_indent_auto_draw)
            end, 100)
        end

        _G.glance_buffer[bufnr] = true

        vim.keymap.set("n", "q", function()
            glance_close()
        end, { buffer = bufnr })
        vim.keymap.set("n", "<CR>", function()
            _G.set_cursor_animation(0.0)
            pcall(satellite_close, api.nvim_get_current_win())
            pcall(require("treesitter-context").close_stored_win, api.nvim_get_current_win())
            Open()
            M.adjust_view(0, 4)
        end, { buffer = bufnr })
    end
end

function EditFromLazygit(file_path)
    local path = vim.fn.expand("%:p")
    if path == file_path then
        return
    else
        vim.cmd("e " .. file_path)
    end
end

function ChangeDirYazi(file_path)
    local dir = vim.fs.dirname(file_path)
    vim.cmd("cd " .. dir)
end

function CloseFromLazygit()
    if vim.bo.filetype == "toggleterm" then
        FeedKeys("<c-c>", "n")
        return
    end
    vim.cmd("close")
    if
        _G.lazygit_previous_win ~= nil
        and api.nvim_win_is_valid(_G.lazygit_previous_win)
        and api.nvim_get_current_win() ~= _G.lazygit_previous_win
    then
        api.nvim_set_current_win(_G.lazygit_previous_win)
    end
    vim.defer_fn(function()
        M.refresh_last_commit()
        M.update_diff_file_count()
        M.refresh_nvim_tree_git()
        vim.cmd("checktime")
    end, 10)
end

function M.gF()
    local name = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if name ~= nil then
        FeedKeys("gFz", "m")
        return
    end
    -- Get the word under the cursor
    local cword = vim.fn.expand("<cWORD>")

    -- Find the start and end of the pattern that matches `\f+:\d+`
    local st = vim.fn.match(cword, "\\v\\f+:\\d+")
    local end_pos = vim.fn.matchend(cword, "\\v\\f+:\\d+")

    -- If the pattern was found, extract it
    if end_pos ~= -1 then
        cword = string.sub(cword, st + 1, end_pos)
    end

    -- Split the cword by ':' to get the file and line parts
    local bits = vim.split(cword, ":", { plain = true })

    FeedKeys("<Tab>", "m")
    vim.defer_fn(function()
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_call(win, function()
            vim.cmd("edit " .. bits[1])
            -- If there's a line number, go to that line
            if bits[2] then
                vim.cmd(bits[2])
            end
        end)
        FeedKeys("z", "m")
    end, 10)
end

function M.refresh_nvim_tree_git()
    require("nvim-tree.actions.reloaders").reload_explorer()
end

function M.set_cr(bufnr, winid)
    if winid ~= api.nvim_get_current_win() then
        return
    end

    if not api.nvim_buf_is_valid(bufnr) then
        return
    end
    local winbar = vim.wo.winbar
    if vim.startswith(winbar, " WORKING TREE") then
        local pathes = vim.split(winbar, "-")
        local path = vim.trim(pathes[2])
        local filename = vim.fn.getcwd() .. "/" .. path
        vim.keymap.set("n", "<cr>", function()
            local row, col = unpack(api.nvim_win_get_cursor(0))
            vim.cmd("tabnext")
            vim.cmd(string.format("lua EditLineFromLazygit('%s','%s','%s')", filename, tostring(row), tostring(col)))
            vim.keymap.set("n", "<CR>", function()
                vim.cmd([[:lua require("nvim-treesitter.incremental_selection").init_selection()]])
            end, { buffer = true })
        end, { buffer = true })
    end
end

function EditLineFromLazygit(file_path, line, col)
    local path = vim.fn.expand("%:p")
    if path == file_path then
        if col == nil then
            vim.cmd(tostring(line))
        else
            api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) })
        end
        M.adjust_view(0, 4)
    else
        vim.cmd("e " .. file_path)
        if col == nil then
            vim.cmd(tostring(line))
        else
            api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) })
        end
        M.adjust_view(0, 4)
    end
end

function M.signature_help(_, result, ctx, config)
    local util = require("vim.lsp.util")
    config = config or {}
    config.focus_id = ctx.method
    if api.nvim_get_current_buf() ~= ctx.bufnr then
        -- Ignore result since buffer changed. This happens for slow language servers.
        return
    end
    -- When use `autocmd CompleteDone <silent><buffer> lua vim.lsp.buf.signature_help()` to call signatureHelp handler
    -- If the completion item doesn't have signatures It will make noise. Change to use `print` that can use `<silent>` to ignore
    if not (result and result.signatures and result.signatures[1]) then
        if config.silent ~= true then
            print("No signature help available")
        end
        return
    end
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    local triggers = vim.tbl_get(client.server_capabilities, "signatureHelpProvider", "triggerCharacters")
    local ft = vim.bo[ctx.bufnr].filetype
    local lines, hl = util.convert_signature_help_to_markdown_lines(result, ft, triggers)
    if not lines or vim.tbl_isempty(lines) then
        if config.silent ~= true then
            print("No signature help available")
        end
        return
    end
    config.max_height = 10
    config.max_width = 50
    local fbuf, fwin = util.open_floating_preview(lines, "markdown", config)
    if vim.startswith(lines[1], "```") then
        vim.api.nvim_create_autocmd("WinScrolled", {
            buffer = fbuf,
            callback = function()
                local topline = vim.fn.getwininfo(fwin)[1].topline
                if topline == 1 then
                    vim.api.nvim_win_call(fwin, function()
                        vim.fn.winrestview({ topline = 2 })
                    end)
                end
            end,
        })
        vim.api.nvim_win_call(fwin, function()
            vim.fn.winrestview({ topline = 2 })
        end)
    end
    if hl then
        -- Highlight the second line if the signature is wrapped in a Markdown code block.
        local line = vim.startswith(lines[1], "```") and 1 or 0
        api.nvim_buf_add_highlight(fbuf, -1, "LspSignatureActiveParameter", line, unpack(hl))
    end
    return fbuf, fwin
end

function M.check_dup_autocmds()
    local function check_duplicate_autocmds()
        -- Get all autocmd groups
        local autocmd_groups = vim.api.nvim_exec("autocmd", true)
        -- local autocmd_lines = vim.split(autocmd_groups, "\n")
        local autocmd_lines = vim.split(autocmd_groups, "\n")

        -- Table to track duplicates by filename and line number
        local callback_registry = {}
        local title
        for _, line in ipairs(autocmd_lines) do
            if line == nil then
                goto continue
            end
            if line:sub(1, 1) ~= " " then
                title = line
            end
            -- Extract the Lua callback part
            local lua_callback = line:match("<Lua%s+%d+:%s+([^>]+)>")
            if lua_callback then
                -- Check for duplicates
                if callback_registry[lua_callback .. "   " .. title] then
                    if
                        string.find(title, "Cmdline", nil, true) == nil
                        and string.find(title, "Option", nil, true) == nil
                        and string.find(title, "FileType", nil, true) == nil
                        and string.find(title, "BufWipeout", nil, true) == nil
                        and string.find(title, "NvimTree  User", nil, true) == nil
                    then
                        print("Duplicate callback found:", lua_callback .. "   " .. title)
                    end
                else
                    callback_registry[lua_callback .. "   " .. title] = true
                end
            end
            ::continue::
        end
    end

    -- Example usage:
    check_duplicate_autocmds()
end

function M.adjust_view(buf, size, force)
    vim.cmd("norm! zz")
    local topline = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].topline
    if force or (topline > size and buf ~= vim.api.nvim_get_current_buf()) then
        vim.fn.winrestview({ topline = topline + size })
        vim.schedule(function()
            vim.fn.winrestview({ topline = topline + size })
        end)
    end
end

function M.context_win_height()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) and api.nvim_win_get_config(win).zindex == 31 then
            return api.nvim_win_get_config(win).height
        end
    end
    return 0
end

function M.restore_mc_view(visual)
    local mc = require("multicursor-nvim")
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local view = vim.fn.winsaveview()
    local bo_line = vim.fn.line("w$")
    local stage = 0
    local id
    id = vim.api.nvim_create_autocmd("SafeState", {
        callback = function()
            if stage == 0 then
                row, col = unpack(vim.api.nvim_win_get_cursor(0))
            end
            if stage == 1 then
                vim.api.nvim_del_autocmd(id)
                local ctx_height = require("config.utils").context_win_height()
                if require("multicursor-nvim").numCursors() > 1 then
                    local n_r = vim.api.nvim_win_get_cursor(0)[1]
                    if view.topline + ctx_height <= n_r and n_r <= bo_line then
                        vim.fn.winrestview({ topline = view.topline })
                    else
                        vim.cmd("norm! zz")
                    end
                    vim.keymap.set({ "n", "x" }, "<c-o>", function()
                        mc.action(function(ctx)
                            ctx:seekCursor({ row, col }, 1, true):select()
                        end)
                        if visual then
                            mc.prevCursor()
                        end
                        vim.fn.winrestview({ topline = view.topline })
                        vim.keymap.del({ "n", "x" }, "<c-o>", { buffer = true })
                    end, { buffer = true })
                    require("config.utils").mc_virt_count()
                else
                    api.nvim_exec_autocmds("User", {
                        pattern = "ESC",
                    })
                    vim.fn.winrestview({ topline = view.topline })
                end
                return
            end
            stage = stage + 1
        end,
    })
end

function M.mc_virt_count()
    local ns = api.nvim_create_namespace("cursor-mc-count")
    local sc = require("multicursor-nvim").numCursors()
    if sc <= 1 then
        return
    end
    local mc = require("multicursor-nvim")
    local cursors = {}
    mc.action(function(ctx)
        if ctx == nil then
            return
        end
        cursors = ctx:getCursors()
    end)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local current = -1
    for i, cursor in ipairs(cursors) do
        if cursor._pos[2] == row and cursor._pos[3] == col + 1 then
            current = i
            break
        end
    end
    if current == -1 then
        return
    end
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
        hl_group = "CursorLine",
        hl_eol = true,
        priority = 1,
        strict = false,
        end_row = vim.api.nvim_win_get_cursor(0)[1],
    })
    vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
        virt_text = {
            { "[" .. current, "illuminatedH" },
            { " of ", "illuminatedHItalic" },
            { sc .. "]", "illuminatedH" },
        },
        virt_text_pos = "eol",
    })
    vim.b.search_winbar = "%#HlSearchLensCountNoBg#"
        .. " ["
        .. current
        .. "%#HlSearchLensCountItalicNoBg#"
        .. " of "
        .. "%#HlSearchLensCountNoBg#"
        .. sc
        .. "]"
    M.refresh_search_winbar()
    M.refresh_satellite_search()

    vim.cmd("redraw")
end

function OilDir()
    local cwd = vim.fn.getcwd()
    local path = require("oil").get_current_dir()
    if vim.startswith(path, cwd) then
        path = string.sub(path, #cwd + 2)
        if path == "" then
            path = "."
        end
        return "  " .. path, "NvimTreeFolderName"
    else
        return "  " .. path, "LibPath"
    end
end

function M.set_oil_winbar()
    local path, hl = OilDir()
    local winbar_content = "%#" .. hl .. "#" .. path .. "%*"
    api.nvim_set_option_value("winbar", winbar_content, { scope = "local", win = 0 })

    vim.keymap.set("n", "q", function()
        local is_split = require("config.utils").check_splits()
        if is_split then
            vim.cmd("close")
        else
            require("oil").close()
        end
    end, { buffer = 0 })
end

function M.visualize_string_bytes(s)
    local function format_char(c)
        if c == " " then
            return "␣"
        elseif c == "\t" then
            return "→"
        elseif c == "\n" then
            return "↵"
        else
            return c:gsub("%c", "�")
        end
    end

    local chars = {}
    local pos = 1
    while pos <= #s do
        local byte = s:byte(pos)
        local char_len = 1

        if byte >= 0xC0 and byte < 0xE0 then
            char_len = 2
        elseif byte >= 0xE0 and byte < 0xF0 then
            char_len = 3
        elseif byte >= 0xF0 then
            char_len = 4
        end

        local char = s:sub(pos, pos + char_len - 1)
        local bytes = { string.byte(char, 1, -1) }

        local hex = table.concat({}, " ")
        local dec = table.concat({}, " ")
        for _, b in ipairs(bytes) do
            hex = hex .. string.format("%02X ", b)
            dec = dec .. string.format("%-3d ", b)
        end
        table.insert(chars, {
            display = format_char(char),
            hex = hex:sub(1, -2),
            dec = dec:sub(1, -2),
        })
        pos = pos + char_len
    end

    print("Index | Char      | Bytes (Hex)      | Bytes (Dec)")
    print("------|-----------|------------------|-------------")
    for i, entry in ipairs(chars) do
        print(string.format("%-5d | %-8s  | %-16s | %s", i, entry.display, entry.hex, entry.dec))
    end
end

function M.update_preview_match(ns, preview_buf)
    local action_state = require("telescope.actions.state")
    local prompt_bufnr = require("telescope.state").get_existing_prompt_bufnrs()[1]

    local picker = action_state.get_current_picker(prompt_bufnr)
    if picker == nil then
        return
    end
    local title = picker.layout.picker.prompt_title
    if title == "Live Grep" then
        local sel = picker:get_selection()
        if sel == nil then
            return
        end
        local submatches = sel.value.submatches[1]
        local s, e = submatches.start, submatches["end"]
        vim.api.nvim_buf_add_highlight(preview_buf, ns, "Search", sel.lnum - 1, s, e)
        vim.api.nvim_buf_set_extmark(preview_buf, ns, sel.lnum - 1, 0, {
            strict = false,
            hl_eol = true,
            hl_group = "TelescopeSelection",
            end_row = sel.lnum,
        })
    end
end

_G.last = nil
_G.first_time = false
function M.on_complete(bo_line, bo_line_side, origin_height)
    if not vim.g.neovide then
        bo_line = "╰" .. string.rep("─", #bo_line - 2) .. "╯"
        bo_line_side = "│" .. string.rep(" ", #bo_line_side - 2) .. "│"
    end
    vim.schedule(function()
        local action_state = require("telescope.actions.state")
        local prompt_bufnr = require("telescope.state").get_existing_prompt_bufnrs()[1]

        local picker = action_state.get_current_picker(prompt_bufnr)
        if picker == nil then
            return
        end
        if not api.nvim_buf_is_valid(picker.results_bufnr) then
            return
        end
        local count = api.nvim_buf_line_count(picker.results_bufnr)
        if count == 1 and vim.api.nvim_buf_get_lines(picker.results_bufnr, 0, -1, false)[1] == "" then
            local line = vim.api.nvim_buf_get_lines(picker.prompt_bufnr, 0, -1, false)[1]
            if line:find("'", nil, true) ~= nil then
                local new_line = line:gsub("'", " ")
                api.nvim_buf_set_lines(picker.prompt_bufnr, 0, -1, false, { new_line })
            end
        end
        local top_win = api.nvim_win_get_config(picker.results_win)
        local buttom_buf = api.nvim_win_get_buf(picker.results_win + 1)
        local bottom_win = api.nvim_win_get_config(picker.results_win + 1)
        top_win.height = math.max(count, 1)
        top_win.height = math.min(top_win.height, origin_height)
        bottom_win.height = math.max(count + 2, 3)
        bottom_win.height = math.min(bottom_win.height, origin_height + 2)
        api.nvim_win_set_config(picker.results_win + 1, bottom_win)
        api.nvim_win_set_config(picker.results_win, top_win)
        if _G.last ~= nil then
            api.nvim_buf_set_lines(buttom_buf, _G.last, _G.last + 1, false, { bo_line_side })
        end
        api.nvim_buf_set_lines(buttom_buf, math.max(count + 1, 2), math.max(count + 2, 3), false, { bo_line })
        _G.last = math.max(count + 1, 2)
    end)
end

function M.has_filetype(filetype)
    local windows = api.nvim_list_wins()
    for _, win in ipairs(windows) do
        local buf = api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == filetype then
            return true
        end
    end
    return false
end

function M.filetype_windowid(filetype)
    local windows = api.nvim_list_wins()
    for _, win in ipairs(windows) do
        local buf = api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == filetype then
            return win
        end
    end
    return 0
end

function M.writeFile(content)
    local file = io.open("path", "w")
    if file then
        file:write(content .. "\n")
        file:flush()
    else
        print("Failed to open the file!")
    end
end

function M.set_glance_winbar()
    local winconfig = api.nvim_win_get_config(0)
    if winconfig.relative ~= "" and winconfig.zindex == 9 then
        api.nvim_create_autocmd("User", {
            once = true,
            pattern = "GlanceListUpdate",
            callback = function()
                _G.set_winbar(
                    " %#Comment#"
                        .. string.format("%s (%d)", get_lsp_method_label(_G.glance_list_method), _G.glance_listnr)
                )
            end,
        })
    end
end

-- Only fire on BufWritePost, SessionLoadPost, Git commit, CloseFromLazygit
function M.refresh_last_commit()
    vim.system(
        { "git", "log", "-1", "--pretty=format:%H%n%B" },
        nil,
        vim.schedule_wrap(function(result)
            if result.code == 0 then
                local splits = vim.split(result.stdout, "\n")
                -- We use Last instead of Base here because Base_commit=="" has special meanings
                vim.g.Last_commit = splits[1]
                local commit_msg = splits[2]:gsub("\n", "")
                if #commit_msg > 30 then
                    local cut_pos = commit_msg:find(" ", 31)
                    if cut_pos then
                        commit_msg = commit_msg:sub(1, cut_pos - 1) .. "…"
                    else
                        commit_msg = commit_msg:sub(1, 30) .. "…"
                    end
                end
                vim.g.Last_commit_msg = commit_msg
            end
            M.set_git_winbar()
        end)
    )
    vim.system(
        { "git", "rev-parse", "--abbrev-ref", "HEAD" },
        nil,
        vim.schedule_wrap(function(result)
            if result.code == 0 then
                vim.g.BranchName = vim.split(result.stdout, "\n")[1]
                if vim.g.BranchName == "HEAD" then
                    local sub = vim.g.Last_commit:sub(1, 5)
                    vim.g.BranchName = "HEAD detached at " .. sub
                end
            end
            M.set_git_winbar()
        end)
    )
end

-- Only fire on BufWritePost, SessionLoadPost, Git commit, CloseFromLazygit, GitSignsChanged
function M.update_diff_file_count()
    local function update(result)
        if result.code == 0 then
            local diff_files = result.stdout or ""
            local file_count = 0
            for _ in string.gmatch(diff_files, "[^\n]+") do
                file_count = file_count + 1
            end
            vim.g.Diff_file_count = file_count
        else
            vim.g.Diff_file_count = 0
        end
        if vim.g.Diff_file_count == 0 and require("gitsigns.config").config.word_diff then
            local gs = package.loaded.gitsigns
            gs.toggle_word_diff()
            gs.toggle_deleted()
            gs.toggle_linehl()
        end
        M.set_git_winbar()
    end
    if vim.g.Base_commit ~= "" then
        vim.system({ "git", "diff", "--name-only", vim.g.Base_commit }, nil, vim.schedule_wrap(update))
    else
        vim.system({ "git", "diff", "--name-only", "HEAD" }, nil, vim.schedule_wrap(update))
    end
end

function M.info(msg, opts)
    require("trouble.util").notify(msg, vim.tbl_extend("keep", { level = vim.log.levels.INFO }, opts or {}))
end

function M.checkout(commit, success_fn)
    local result = vim.system({ "git", "checkout", commit }):wait()
    if result.code ~= 0 then
        vim.notify(result.stderr, vim.log.levels.WARN)
    end
    if result.code == 0 then
        if success_fn ~= nil then
            success_fn()
        end
        vim.cmd("checktime")
        vim.notify(result.stdout, vim.log.levels.INFO)
        M.refresh_last_commit()
        M.update_diff_file_count()
        M.refresh_nvim_tree_git()
    end
end

function M.map_checkout(key, map)
    local action_state = require("telescope.actions.state")
    local actions = require("telescope.actions")
    map({ "n" }, key, function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        M.checkout(selection.value, function()
            actions.close(prompt_bufnr)
            FeedKeys("<leader>cb", "m")
        end)
    end, { nowait = true, desc = "desc for which key" })
end

function M.refresh_satellite_search()
    local winid = vim.api.nvim_get_current_win()
    pcall(function()
        local bwinid = require("satellite.view").get_or_create_view(winid)
        for _, handler in ipairs(require("satellite.handlers").handlers) do
            if api.nvim_win_is_valid(winid) and api.nvim_win_is_valid(bwinid) then
                if handler.name == "search" then
                    handler:render(winid, bwinid)
                end
            end
        end
    end)
end

function M.clear_satellite_search()
    local winid = vim.api.nvim_get_current_win()
    pcall(function()
        local bwinid = require("satellite.view").get_or_create_view(winid)
        for _, handler in ipairs(require("satellite.handlers").handlers) do
            if api.nvim_win_is_valid(winid) and api.nvim_win_is_valid(bwinid) then
                if handler.name == "search" then
                    vim.g.search_pos = nil
                    handler:render(winid, bwinid)
                end
            end
        end
    end)
end

function M.refresh_term_title()
    local conf = vim.api.nvim_win_get_config(0)
    if conf.border ~= nil then
        local c = {}
        c.row = conf.row
        c.col = conf.col
        c.relative = conf.relative
        c.footer = vim.b.term_search_title
        c.footer_pos = "right"
        vim.api.nvim_win_set_config(0, c)
    end
end

function M.refresh_search_winbar()
    if vim.bo.filetype == "toggleterm" then
        return M.refresh_term_title()
    end
    if vim.wo.winbar == "" or vim.b.winbar_expr == nil then
        return
    end
    local expr = vim.b.search_winbar
    local diag_winbar = vim.b.diag_winbar or ""
    if api.nvim_get_mode().mode == "n" and expr ~= nil then
        if vim.b.git_winbar_expr ~= nil and vim.api.nvim_win_get_config(0).zindex ~= 10 then
            _G.set_winbar(vim.b.winbar_expr .. diag_winbar .. expr .. "%= " .. vim.b.git_winbar_expr)
        else
            _G.set_winbar(vim.b.winbar_expr .. diag_winbar .. expr)
        end
    end
end

function M.mini_snippet_expand(args)
    if require("multicursor-nvim").numCursors() > 1 then
        vim.snippet.expand(args.body)
        return
    end
    _G.no_animation(_G.CI)
    pcall(
        require("mini.snippets").default_insert,
        { body = args.body },
        { empty_tabstop = "", empty_tabstop_final = "" }
    )
end

function M.refresh_diagnostic_winbar()
    local expr = vim.b.diag_winbar
    local search = vim.b.search_winbar or ""
    if api.nvim_get_mode().mode == "n" and expr ~= nil then
        if vim.b.git_winbar_expr ~= nil and vim.api.nvim_win_get_config(0).zindex ~= 10 then
            _G.set_winbar(vim.b.winbar_expr .. expr .. search .. "%= " .. vim.b.git_winbar_expr)
        else
            _G.set_winbar(vim.b.winbar_expr .. expr .. search)
        end
    end
end

--- @generic F: function
--- @param f F
--- @param ms? number
--- @return F
function M.throttle(f, ms)
    ms = ms or 200
    local timer = vim.loop.new_timer()
    return function()
        if timer:is_active() then
            return
        end
        f()
        timer:start(ms, 0, function()
            timer:stop()
        end)
    end
end

function M.set_diagnostic_winbar()
    if
        vim.fn.reg_recording() ~= ""
        or vim.fn.reg_executing() ~= ""
        or vim.b.winbar_expr == nil
        or api.nvim_win_get_config(0).zindex == 10
    then
        return
    end
    if vim.b.winbar_expr == nil then
        return
    end

    local counts = vim.diagnostic.count(0, { severity = { min = vim.diagnostic.severity.WARN } })
    local num_errors = counts[vim.diagnostic.severity.ERROR] or 0
    local num_warnings = counts[vim.diagnostic.severity.WARN] or 0

    if num_errors > 0 then
        if not vim.g.show_diag then
            vim.b.diag_winbar = "%#diffRemoved#" .. "  " .. num_errors
        else
            vim.b.diag_winbar = "%#diffRemoved#" .. "  " .. num_errors
        end
    elseif num_warnings > 0 then
        if not vim.g.show_diag then
            vim.b.diag_winbar = "%#CmpGhostText#" .. "  " .. num_warnings
        else
            vim.b.diag_winbar = "%#CmpGhostText#" .. "  " .. num_warnings
        end
    else
        if not vim.g.show_diag then
            vim.b.diag_winbar = "%#CmpGhostText#" .. "  "
        else
            vim.b.diag_winbar = ""
        end
    end
    M.refresh_diagnostic_winbar()
end

function M.set_git_winbar()
    local icons = { "+", "-", "* " }
    local signs = vim.b.gitsigns_status_dict

    if
        vim.fn.reg_recording() ~= ""
        or vim.fn.reg_executing() ~= ""
        or vim.b.winbar_expr == nil
        or api.nvim_win_get_config(0).zindex == 10
    then
        return
    end
    local head = vim.g.BranchName
    local git_winbar_expr = ""
    if signs ~= nil and signs ~= "" then
        local hunks = require("gitsigns").get_hunks(api.nvim_get_current_buf())
        if hunks ~= nil and #hunks > 0 then
            if #hunks >= 1 then
                git_winbar_expr = git_winbar_expr .. "%#WinBarHunk#" .. "~" .. #hunks .. " "
            end
        end
        for index, icon in ipairs(icons) do
            local name
            if index == 1 then
                name = "added"
            elseif index == 2 then
                name = "removed"
            end
            if tonumber(signs[name]) and signs[name] > 0 then
                git_winbar_expr = git_winbar_expr .. "%#" .. "Diff" .. name .. "#" .. icon .. signs[name] .. " "
            end
        end
    end
    if head ~= nil then
        git_winbar_expr = git_winbar_expr .. "%#BranchName#" .. "[" .. head .. "] "
    end
    if vim.g.Base_commit_msg ~= "" then
        if vim.g.Diff_file_count ~= 0 then
            git_winbar_expr = git_winbar_expr .. "%#CommitHasDiffNCWinbar#" .. vim.trim(vim.g.Base_commit_msg)
            git_winbar_expr = git_winbar_expr .. "%#Comment#" .. "(" .. vim.g.Diff_file_count .. ")"
        else
            git_winbar_expr = git_winbar_expr .. "%#CommitNCWinbar#" .. vim.trim(vim.g.Base_commit_msg)
            git_winbar_expr = git_winbar_expr .. "%#Comment#" .. " "
        end
    else
        if vim.g.Diff_file_count ~= 0 then
            git_winbar_expr = git_winbar_expr .. "%#CommitHasDiffWinbar#" .. vim.trim(vim.g.Last_commit_msg)
            git_winbar_expr = git_winbar_expr .. "%#Comment#" .. "(" .. vim.g.Diff_file_count .. ")"
        else
            git_winbar_expr = git_winbar_expr .. "%#CommitWinbar#" .. vim.trim(vim.g.Last_commit_msg or "")
            git_winbar_expr = git_winbar_expr .. "%#Comment#" .. " "
        end
    end
    vim.b.git_winbar_expr = git_winbar_expr
    local diagnostic_winbar = api.nvim_get_mode().mode == "n" and vim.b.diag_winbar or ""
    local search_winbar = vim.b.search_winbar or ""
    _G.set_winbar(vim.b.winbar_expr .. diagnostic_winbar .. search_winbar .. "%= " .. git_winbar_expr)
end

function M.visual_search(cmd)
    local chunks = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
    local esc_chunks = vim.iter(chunks)
        :map(function(v)
            return vim.fn.escape(v, cmd == "/" and [[/\]] or [[?\]])
        end)
        :totable()
    local esc_pat = table.concat(esc_chunks, [[\n]])
    local search_cmd = ([[%s\V%s%s]]):format(cmd, esc_pat, "\n")
    _G.searchmode = cmd
    return "oh<esc>" .. search_cmd .. "N"
end

function M.star_search(cmd, word)
    local chunks = { word }
    local esc_chunks = vim.iter(chunks)
        :map(function(v)
            return vim.fn.escape(v, cmd == "/" and [[/\]] or [[?\]])
        end)
        :totable()
    local esc_pat = table.concat(esc_chunks, [[\n]])
    local search_cmd = ([[%s\V%s%s]]):format(cmd, esc_pat, "\n")
    _G.searchmode = cmd
    return "h" .. search_cmd
end

function M.set_winbar(buf)
    if
        buf ~= api.nvim_get_current_buf()
        or vim.bo.filetype == "NvimTree"
        or vim.bo.filetype == "toggleterm"
        or vim.bo.filetype == "qf"
        or vim.bo.filetype == "DiffviewFiles"
        or vim.bo.buftype == "nofile"
    then
        return
    end
    local filename = vim.fn.expand("%:t")
    local extension = string.match(filename, "%a+$")
    local icon, iconHighlight
    if extension == "txt" then
        icon = "󰈙"
        iconHighlight = "TXT"
    else
        icon, iconHighlight = require("nvim-web-devicons").get_icon(filename, extension, { default = true })
    end
    local winid = api.nvim_get_current_win()
    local winconfig = api.nvim_win_get_config(winid)
    if winconfig.relative ~= "" and winconfig.zindex ~= 10 then
        return
    end
    local absolute_path = vim.fn.expand("%:p:h") -- 获取完整路径
    local path = vim.fn.expand("%:~:.:h")
    local cwd = vim.fn.getcwd()
    local path_color = vim.startswith(absolute_path, cwd) and "%#NvimTreeFolderName#" or "%#LibPath#"
    vim.b.path = vim.startswith(path, "~/") and "/Users/xzb/" .. path:sub(3, #path) .. "/" or path .. "/"
    vim.b.lib = path_color == "%#LibPath#"
    if path ~= "" and filename ~= "" then
        local winbar_expr = " "
            .. path_color
            .. path
            .. "%#Comment#"
            .. " => "
            .. "%#"
            .. iconHighlight
            .. "#"
            .. icon
            .. " %#WinbarFileName#"
            .. filename
            .. "%*"
        _G.set_winbar(winbar_expr, winid)
        vim.b.winbar_expr = winbar_expr
    elseif filename ~= "" then
        _G.set_winbar("%#WinbarFileName#" .. filename .. "%*")
    end
end

_G.Time = function(start, msg, notify)
    if notify == nil then
        notify = true
    end
    if start == nil then
        return
    end
    msg = msg or ""
    local duration = 0.000001 * (vim.loop.hrtime() - start)
    if not notify then
        return duration
    end
    if msg == "" then
        -- vim.schedule(function()
        print(vim.inspect(duration))
        -- end)
    else
        -- vim.schedule(function()
        print(msg .. ":", vim.inspect(duration))
        -- end)
    end
    return duration
end

function M.search_to_qf()
    vim.fn.setqflist({}, "r")
    vim.cmd("silent vimgrep //gj %")
end

function M.check_splits()
    local windows = api.nvim_list_wins()
    local real_file_count = 0

    for _, win_id in ipairs(windows) do
        local buf_id = api.nvim_win_get_buf(win_id)
        local file_path = api.nvim_buf_get_name(buf_id)

        if vim.bo[buf_id].filetype == "oil" or (file_path ~= "" and vim.loop.fs_stat(file_path)) then
            real_file_count = real_file_count + 1
        end
    end

    return real_file_count > 1
end

function M.real_col()
    local windows = api.nvim_list_wins()
    local buffers = {}
    local col = 0
    for _, win_id in ipairs(windows) do
        local buf_id = api.nvim_win_get_buf(win_id)
        if vim.bo[buf_id].filetype == "NvimTree" then
            local w = api.nvim_win_get_width(win_id)
            col = col + w + 1
            goto continue
        end
        local file_path = api.nvim_buf_get_name(buf_id)

        if file_path ~= "" and vim.loop.fs_stat(file_path) then
            local textoff = vim.fn.getwininfo(win_id)[1].textoff
            local left_col = api.nvim_win_call(win_id, function()
                return vim.fn.winsaveview().leftcol
            end)
            buffers[#buffers + 1] = {
                textoff = textoff,
                win_id = win_id,
                width = api.nvim_win_get_width(win_id),
                position = api.nvim_win_get_position(win_id),
                left_col = left_col,
            }
        end
        ::continue::
    end
    local row = api.nvim_win_get_cursor(0)[1]
    local cursor = api.nvim_win_get_cursor(0)[2] + 1
    -- Currently only go uses tab
    local has_tab = vim.bo.filetype == "go" and string.find(api.nvim_get_current_line(), "\t", nil, true)
    if #buffers == 1 then
        if has_tab then
            col = col + cursor + buffers[1].textoff - buffers[1].left_col + vim.fn.indent(row) * (3 / 4)
        else
            col = col + cursor + buffers[1].textoff - buffers[1].left_col
        end
    elseif #buffers == 2 then
        local f1 = buffers[1]
        local f2 = buffers[2]
        local cur = f1.win_id == api.nvim_get_current_win() and f1 or f2
        local other = cur == 1 and f2 or f1
        if cur.position[2] > other.position[2] then
            if has_tab then
                col = col + other.width + cursor + cur.textoff - cur.left_col + 1 + vim.fn.indent(row) * (3 / 4)
            else
                -- window width contains textoff
                col = col + other.width + cursor + cur.textoff - cur.left_col + 1
            end
        else
            if has_tab then
                col = col + cursor + cur.textoff - cur.left_col + vim.fn.indent(row) * (3 / 4)
            else
                col = col + cursor + cur.textoff - cur.left_col
            end
        end
    end

    return col
end

M.operator_mode_lh = function(direction)
    local line = api.nvim_get_current_line()
    local col = api.nvim_win_get_cursor(0)[2]
    local substring = ""
    if direction == "before" then
        substring = line:sub(0, col)
    else
        substring = line:sub(col + 1, #line)
    end
    local next = "("
    for i = 1, #substring do
        local char = substring:sub(i, i)
        if char == [["]] then
            next = "double"
            break
        end
        if char == [[']] then
            next = "single"
            break
        end
        if char == [[(]] then
            break
        end
        if char == [[)]] then
            next = ")"
            break
        end
        if char == "[" then
            next = "["
            break
        end
        if char == "]" then
            next = "["
            break
        end
        if char == "{" then
            next = "{"
            break
        end
        if char == "}" then
            next = "}"
            break
        end
    end
    if direction == "before" then
        if next == "(" then
            return "T("
        elseif next == ")" then
            return "T)"
        elseif next == "[" then
            return "T["
        elseif next == "]" then
            return "T]"
        elseif next == "}" then
            return [[T}]]
        elseif next == "double" then
            return [[T"]]
        elseif next == "single" then
            return [[T']]
        elseif next == "{" then
            return [[T{]]
        end
    else
        if next == "(" then
            return "t("
        elseif next == ")" then
            return "t)"
        elseif next == "[" then
            return "t["
        elseif next == "]" then
            return "t]"
        elseif next == "}" then
            return [[t}]]
        elseif next == "double" then
            return [[t"]]
        elseif next == "single" then
            return [[t']]
        elseif next == "{" then
            return [[t{]]
        end
    end
    return "l"
end

M.qf_populate = function(lines, opts)
    if not lines or #lines == 0 then
        return
    end

    opts = vim.tbl_deep_extend("force", {
        simple_list = false,
        mode = "r",
        title = nil,
        scroll_to_end = false,
    }, opts or {})

    vim.fn.setqflist(lines, opts.mode)

    local commands = table.concat({
        "horizontal copen",
        (opts.scroll_to_end and "normal! G") or "",
        "wincmd p",
    }, "\n")

    vim.cmd(commands)
end

function M.add_word_to_dir()
    local pos = vim.api.nvim_win_get_cursor(0)
    local row, col = pos[1] - 1, pos[2]
    -- stylua: ignore
    local params = { textDocument = vim.lsp.util.make_text_document_params(), range = { start = { line = row, character = col }, ["end"] = { line = row, character = col } }, context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics(), triggerKind = 1 } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for id, res in pairs(result or {}) do
        for _, action in pairs(res.result or {}) do
            if action.title ~= nil and action.title:find("Add .* to the global dictionary") ~= nil then
                local client = vim.lsp.get_client_by_id(id)
                client.request("workspace/executeCommand", {
                    command = action.command,
                    arguments = action.arguments,
                    workDoneToken = action.workDoneToken,
                }, nil, api.nvim_get_current_buf())
                return
            end
        end
    end
end

function M.gopls_extract_all()
    local mode = vim.api.nvim_get_mode().mode

    local row = vim.api.nvim_win_get_cursor(0)[1]
    if mode == "v" or mode == "V" then
        local range = vim.lsp.buf.range_from_selection(0, mode)
        local params = vim.lsp.util.make_given_range_params(range.start, range["end"], 0, "utf-8")
        params.context = { only = { "refactor.extract.variable-all" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
        for _, res in pairs(result or {}) do
            for _, action in pairs(res.result or {}) do
                if action.data and action.data.arguments then
                    -- Resolve the code action using gopls' expected structure
                    vim.lsp.buf_request(0, "codeAction/resolve", action, function(err, resolved_action)
                        if err then
                            vim.notify("Error resolving code action: " .. err.message, vim.log.levels.ERROR)
                            return
                        end
                        if resolved_action.edit then
                            vim.lsp.util.apply_workspace_edit(resolved_action.edit, "utf-8")
                            -- Find the first occurrence of newText edits
                            local edits = resolved_action.edit.changes or resolved_action.edit.documentChanges
                            local ranges = {}
                            for _, edit in ipairs(edits) do
                                for _, e in pairs(edit) do
                                    for _, item in ipairs(e) do
                                        table.insert(ranges, item.range)
                                    end
                                end
                            end
                            local minimal_distance = 1000000000
                            local which_one = {}
                            for _, rang in ipairs(ranges) do
                                local start_row, start_col = rang.start.line, rang.start.character
                                if
                                    start_row == row - 1
                                    and not (start_row == rang["end"].line and start_col == rang["end"].character)
                                then
                                    if start_col < minimal_distance then
                                        which_one = { row, start_col }
                                        minimal_distance = start_col
                                    end
                                end
                            end
                            FeedKeys("<esc>", "n")
                            vim.api.nvim_win_set_cursor(0, { which_one[1] + 1, which_one[2] })
                            FeedKeys("<leader>rn", "m")
                        end
                    end)
                end
            end
        end
    end
end

function M.f_search()
    vim.g.disable_flash = true
    local key_ns = vim.api.nvim_create_namespace("f_search")
    local miss_count = 0
    vim.on_key(function(key, typed)
        if miss_count > 1 then
            -- ignore keys by FeedKeys(";", "n")
            if typed == "" and key == ";" then
                return
            end
            if typed == ";" then
                FeedKeys(";", "n")
                return
            elseif key == "," then
                return
            else
                vim.on_key(nil, vim.api.nvim_create_namespace("f_search"))
                vim.g.disable_flash = false
                return
            end
        end
        miss_count = miss_count + 1
    end, key_ns)
end

_G.no_animation = function(length)
    length = length or 0
    _G.set_cursor_animation(0.0)
    vim.defer_fn(function()
        _G.set_cursor_animation(length)
    end, 100)
end

_G.Cursor = function(callback, length)
    length = length or 0
    return function(...)
        _G.set_cursor_animation(length)
        callback(...)
        vim.defer_fn(function()
            _G.set_cursor_animation(_G.CI)
        end, 100)
    end
end

return M
