local M = {}
_G.FeedKeys = function(keymap, mode)
    api.nvim_feedkeys(api.nvim_replace_termcodes(keymap, true, false, true), mode, true)
end

local function get_normal_bg_color()
    local normal_hl = api.nvim_get_hl_by_name("Normal", true)
    local bg_color = string.format("#%06x", normal_hl.background)
    return bg_color
end

function M.load_appropriate_theme()
    local bg_color = get_normal_bg_color()
    if bg_color == "#24273a" then
        require("theme.dark")
    else
        require("theme.light")
    end
end

function _G.hide_cursor(callback, timeout)
    local hl = api.nvim_get_hl_by_name("Cursor", true)
    hl.blend = 100
    timeout = timeout or 0
    ---@diagnostic disable-next-line: undefined-field
    vim.opt.guicursor:append("a:Cursor/lCursor")
    pcall(api.nvim_set_hl, 0, "Cursor", hl)

    callback()

    local old_hl = hl
    old_hl.blend = 0
    vim.defer_fn(function()
        ---@diagnostic disable-next-line: undefined-field
        vim.opt.guicursor:remove("a:Cursor/lCursor")
        pcall(api.nvim_set_hl, 0, "Cursor", old_hl)
    end, timeout)
end

local function check_trouble()
    local ret = false
    if require("trouble").is_open("qflist") then
        vim.cmd("Trouble qflist toggle focus=false")
        _G.pre_gitsigns_qf_operation = ""
        ret = true
    elseif require("trouble").is_open("mydiags") then
        vim.cmd("Trouble mydiags toggle filter.buf=0 focus=false")
        _G.pre_gitsigns_qf_operation = ""
        ret = true
    end
    return ret
end

function M.close_win()
    if M.has_filetype("gitcommit") then
        vim.cmd("close")
        return
    end
    if M.has_filetype("toggleterm") then
        FeedKeys("<f16>", "m")
        return
    end
    if M.has_filetype("trouble") and check_trouble() then
        return
    end
    if require("config.utils").has_filetype("gitsigns.blame") then
        FeedKeys("<Tab>q<d-1><tab>", "m")
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

function M.insert_mode_space()
    _G.no_animation()
    FeedKeys("<Space>", "n")
    if has_map or api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return
    end
    local changed_keys = {
        ["<Esc>"] = "<esc>",
        ["<C-A>"] = "a",
        ["<C-B>"] = "b",
        ["<C-C>"] = "c",
        ["<C-D>"] = "d",
        ["<C-E>"] = "e",
        ["<C-F>"] = "f",
        ["<C-G>"] = "g",
        ["<C-H>"] = "h",
        ["<C-I>"] = "i",
        ["<C-J>"] = "j",
        ["<C-K>"] = "k",
        ["<C-L>"] = "l",
        ["<C-M>"] = "m",
        ["<C-N>"] = "n",
        ["<C-O>"] = "o",
        ["<C-P>"] = "p",
        ["<C-Q>"] = "q",
        ["<C-R>"] = "r",
        ["<C-S>"] = "s",
        ["<C-T>"] = "t",
        ["<C-U>"] = "u",
        ["<C-V>"] = "v",
        ["<C-W>"] = "w",
        ["<C-X>"] = "x",
        ["<C-Y>"] = "y",
        ["<C-Z>"] = "z",
    }

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
                ---@diagnostic disable-next-line: undefined-field
                vim.keymap.del("i", m.lhs)
            end
        end

        for _, map in pairs(original_keymaps) do
            for k in pairs(changed_keys) do
                ---@diagnostic disable-next-line: undefined-field
                if map.lhs == k then
                    ---@diagnostic disable-next-line: undefined-field
                    local rhs = tostring(map.rhs)
                    ---@diagnostic disable-next-line: undefined-field
                    local should_map = map.rhs ~= map.lhs
                    remove_extra_fields(map)
                    if should_map then
                        vim.api.nvim_set_keymap("i", k, rhs, map)
                    end
                    break
                end
            end
        end
        has_map = false
    end, 150)
end

function M.if_multicursor()
    local ns = api.nvim_create_namespace("multicursors")
    local extmark = api.nvim_buf_get_extmarks(0, ns, { 0, 0 }, { -1, -1 }, {})
    if extmark ~= nil and #extmark ~= 0 then
        return true
    end
    return false
end

---@diagnostic disable-next-line: lowercase-global
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
                end
                break
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

function M.once(callback)
    local done = false
    if done then
        return
    end
    done = true
    callback()
end

function M.search(mode)
    api.nvim_create_autocmd("CmdlineChanged", {
        once = true,
        callback = function()
            vim.o.scrolloff = 999
        end,
    })
    api.nvim_create_autocmd("CmdlineLeave", {
        once = true,
        callback = function()
            require("treesitter-context").close_all()
        end,
    })
    vim.cmd("Noice disable")
    _G.parent_winid = vim.api.nvim_get_current_win()
    _G.parent_bufnr = vim.api.nvim_get_current_buf()
    _G.searchmode = mode
    FeedKeys(mode, "n")
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
        return
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    if col == 0 or vim.fn.getline("."):sub(1, col):match("^%s*$") then
        FeedKeys("<Tab>", "n")
        return
    else
        FeedKeys("<right>", "n")
        return
    end
end

_G.no_delay = function(animation)
    TST = vim.uv.hrtime()
    vim.g.type_o = true
    vim.g.neovide_cursor_animation_length = animation
    vim.schedule(function()
        vim.g.type_o = false
        local ok, async = pcall(require, "gitsigns.async")
        if ok then
            local manager = require("gitsigns.manager")
            local debounce_trailing = require("gitsigns.debounce").debounce_trailing
            debounce_trailing(1, async.create(1, manager.update))(api.nvim_get_current_buf())
        end
        -- Time(TST, "no_delay: ")
        local row, col = unpack(api.nvim_win_get_cursor(0))
        local ts_indent = require("nvim-treesitter.indent")
        local success, indent_number = pcall(ts_indent.get_indent, row)
        api.nvim_buf_clear_namespace(0, api.nvim_create_namespace("illuminate.highlight"), 0, -1)
        if not success or col >= indent_number then
            return
        end
        local indent = string.rep(" ", indent_number)
        local line = vim.trim(api.nvim_buf_get_lines(0, row - 1, row, false)[1])
        api.nvim_buf_set_lines(0, row - 1, row, false, { indent .. line })
        success = pcall(api.nvim_win_set_cursor, 0, { row, indent_number })
        if not success then
            -- __AUTO_GENERATED_PRINT_VAR_START__
            print([==[indent fail: ts indent_number: ]==], vim.inspect(indent_number)) -- __AUTO_GENERATED_PRINT_VAR_END__
        end
    end)
    vim.defer_fn(function()
        ---@diagnostic disable-next-line: undefined-field
        pcall(_G.update_indent, true)
        ---@diagnostic disable-next-line: undefined-field
        pcall(_G.mini_indent_auto_draw)
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 50)
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
    vim.defer_fn(function()
        pcall(function()
            require("treesitter-context").context_force_update(bufnr, winid)
            ---@diagnostic disable-next-line: undefined-field
            pcall(_G.indent_update, winid)
        end)
    end, 5)
end

function M.set_glance_keymap()
    local winconfig = api.nvim_win_get_config(0)
    local bufnr = api.nvim_get_current_buf()
    if winconfig.relative ~= "" and winconfig.zindex == 10 then
        if _G.glance_buffer[bufnr] ~= nil then
            return
        end

        local function glance_close()
            ---@diagnostic disable-next-line: undefined-global
            pcall(satellite_close, api.nvim_get_current_win())
            ---@diagnostic disable-next-line: undefined-global
            pcall(close_stored_win, api.nvim_get_current_win())
            Close_with_q()
            vim.defer_fn(function()
                ---@diagnostic disable-next-line: undefined-field
                pcall(_G.indent_update)
                ---@diagnostic disable-next-line: undefined-field
                pcall(_G.mini_indent_auto_draw)
            end, 100)
        end

        _G.glance_buffer[bufnr] = true
        vim.keymap.set("n", "<Esc>", function()
            glance_close()
        end, { buffer = bufnr })

        vim.keymap.set("n", "q", function()
            glance_close()
        end, { buffer = bufnr })
        vim.keymap.set("n", "<CR>", function()
            vim.g.neovide_cursor_animation_length = 0.0
            ---@diagnostic disable-next-line: undefined-global
            pcall(satellite_close, api.nvim_get_current_win())
            ---@diagnostic disable-next-line: undefined-global
            pcall(close_stored_win, api.nvim_get_current_win())
            vim.defer_fn(function()
                Open()
            end, 5)
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

function CloseFromLazygit()
    if
        _G.lazygit_previous_win ~= nil
        and api.nvim_win_is_valid(_G.lazygit_previous_win)
        and api.nvim_get_current_win() ~= _G.lazygit_previous_win
    then
        api.nvim_set_current_win(_G.lazygit_previous_win)
    end
    vim.defer_fn(function()
        M.refresh_last_commit()
        M.set_git_winbar()
    end, 10)
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
        return
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

function M.set_oil_winbar(ev)
    if vim.bo[ev.buf].filetype == "oil" and api.nvim_get_current_buf() == ev.buf then
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
end

_G.last = nil
_G.first_time = false
function M.on_complete(bo_line, bo_line_side, origin_height)
    vim.schedule(function()
        ---@diagnostic disable-next-line: undefined-field
        local obj = _G.telescope_picker
        if not api.nvim_buf_is_valid(obj.results_bufnr) then
            return
        end
        local count = api.nvim_buf_line_count(obj.results_bufnr)
        local top_win = api.nvim_win_get_config(obj.results_win)
        local buttom_buf = api.nvim_win_get_buf(obj.results_win + 1)
        local bottom_win = api.nvim_win_get_config(obj.results_win + 1)
        top_win.height = math.max(count, 1)
        top_win.height = math.min(top_win.height, origin_height)
        bottom_win.height = math.max(count + 2, 3)
        bottom_win.height = math.min(bottom_win.height, origin_height + 2)
        api.nvim_win_set_config(obj.results_win + 1, bottom_win)
        api.nvim_win_set_config(obj.results_win, top_win)
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

function M.real_enter(callback, filter, who)
    who = who or ""
    local timer = vim.loop.new_timer()
    vim.defer_fn(function()
        ---@diagnostic disable-next-line: need-check-nil
        local is_active = timer:is_active()
        if is_active then
            vim.notify(who .. "Timer haven't been closed!", vim.log.levels.ERROR)
        end
    end, 2000)
    local has_start = false
    local timout = function(opts)
        local force = opts.force
        if not filter() then
            ---@diagnostic disable-next-line: need-check-nil
            if timer:is_active() then
                ---@diagnostic disable-next-line: need-check-nil
                timer:close()
            end
            return
        end
        if (not force) and has_start then
            return
        end
        ---@diagnostic disable-next-line: need-check-nil
        if timer:is_active() then
            ---@diagnostic disable-next-line: need-check-nil
            timer:close()
            -- haven't start
            has_start = true
            callback()
        end
    end
    vim.defer_fn(function()
        timout({ force = false, time = 30 })
    end, 30)
    vim.defer_fn(function()
        timout({ force = true, time = 1000 })
    end, 1000)
    local col = vim.fn.screencol()
    local row = vim.fn.screenrow()
    ---@diagnostic disable-next-line: need-check-nil
    timer:start(2, 2, function()
        vim.schedule(function()
            if not filter() then
                ---@diagnostic disable-next-line: need-check-nil
                if timer:is_active() then
                    ---@diagnostic disable-next-line: need-check-nil
                    timer:close()
                end
                return
            end
            if has_start then
                return
            end
            local new_col = vim.fn.screencol()
            local new_row = vim.fn.screenrow()
            if new_row ~= row or new_col ~= col then
                ---@diagnostic disable-next-line: need-check-nil
                if timer:is_active() then
                    ---@diagnostic disable-next-line: need-check-nil
                    timer:close()
                    has_start = true
                    callback()
                end
            end
        end)
    end)
end

function M.set_glance_winbar()
    local winconfig = api.nvim_win_get_config(0)
    if winconfig.relative ~= "" and winconfig.zindex == 9 then
        local function checkGlobalVarAndSetWinBar()
            if _G.glance_listnr ~= nil then
                vim.wo.winbar = " %#Comment#"
                    .. string.format("%s (%d)", get_lsp_method_label(_G.glance_list_method), _G.glance_listnr)
            else
                vim.defer_fn(checkGlobalVarAndSetWinBar, 1)
            end
        end
        checkGlobalVarAndSetWinBar()
    end
    if winconfig.relative ~= "" and winconfig.zindex == 10 then
        local telescopeUtilities = require("telescope.utils")
        local icon, iconHighlight = telescopeUtilities.get_devicons(vim.bo.filetype)
        local path = vim.fn.expand("%:~:.:h")

        local absolute_path = vim.fn.expand("%:p:h") -- 获取完整路径
        local filename = vim.fn.expand("%:t")
        local cwd = vim.fn.getcwd()
        if path == nil or filename == nil then
            return
        end
        if filename:match("%.rs$") then
            iconHighlight = "RustIcon"
            icon = "󱘗"
        end
        if not vim.startswith(absolute_path, cwd) then
            vim.wo.winbar = " "
                .. "%#"
                .. iconHighlight
                .. "#"
                .. icon
                .. " %#GlanceWinbarFileName#"
                .. filename
                .. "%*"
                .. " "
                .. "%#LibPath#"
                .. path
        else
            -- 在当前工作目录下，使用默认颜色
            vim.wo.winbar = " "
                .. "%#"
                .. iconHighlight
                .. "#"
                .. icon
                .. " %#GlanceWinbarFileName#"
                .. filename
                .. "%*"
                .. " "
                .. "%#Comment#"
                .. path
        end
    end
end

-- Only fire on BufWritePost, SessionLoadPost, Git commit, CloseFromLazygit
function M.refresh_last_commit()
    if vim.g.Base_commit == "" then
        local result = vim.system({ "git", "log", "-1", "--pretty=format:%H%n%B" }):wait()
        if result.code == 0 then
            local splits = vim.split(result.stdout, "\n")
            vim.g.Last_commit = splits[1]
            vim.g.Last_commit_msg = splits[2]:gsub("\n", "")
        end
    end
end

function M.set_git_winbar()
    local icons = { " ", " ", " " }
    local signs = vim.b.gitsigns_status_dict
    if signs ~= nil and signs ~= "" then
        local head = vim.g.gitsigns_head
        if signs == nil then
            return
        end
        local expr = vim.b.winbar_expr
        expr = expr .. "%= "
        if expr ~= nil and expr ~= "" then
            local hunks = require("gitsigns").get_hunks(api.nvim_get_current_buf())
            if hunks ~= nil and #hunks > 0 then
                if #hunks > 1 then
                    expr = expr .. "%#WinBarHunk#" .. "[" .. #hunks .. " hunks" .. "] "
                else
                    expr = expr .. "%#WinBarHunk#" .. "[" .. #hunks .. " hunk" .. "] "
                end
            end
            for index, icon in ipairs(icons) do
                local name
                if index == 1 then
                    name = "removed"
                elseif index == 2 then
                    name = "added"
                else
                    name = "changed"
                end
                if tonumber(signs[name]) and signs[name] > 0 then
                    expr = expr .. "%#" .. "Diff" .. name .. "#" .. icon .. signs[name] .. " "
                end
            end
            if head ~= nil then
                expr = expr .. "%#BranchName#" .. "[" .. head .. "] "
            end
            if vim.g.Base_commit_msg ~= "" then
                expr = expr .. "%#CommitNCWinbar#" .. vim.trim(vim.g.Base_commit_msg)
                expr = expr .. "%#Comment#" .. " "
            else
                if vim.g.diff_file_count ~= 0 then
                    expr = expr .. "%#CommitHasDiffWinbar#" .. vim.trim(vim.g.Last_commit_msg)
                    expr = expr .. "%#diffAdded#" .. " (" .. vim.g.diff_file_count .. ") "
                else
                    expr = expr .. "%#CommitWinbar#" .. vim.trim(vim.g.Last_commit_msg)
                    expr = expr .. "%#Comment#" .. " "
                end
            end
            vim.wo.winbar = expr
        end
    end
end

function M.set_winbar()
    if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "toggleterm" or vim.bo.filetype == "DiffviewFiles" then
        return
    end
    local filename = vim.fn.expand("%:t")
    local devicons = require("nvim-web-devicons")
    local icon, iconHighlight = devicons.get_icon(filename, string.match(filename, "%a+$"), { default = true })
    local winid = api.nvim_get_current_win()
    local winconfig = api.nvim_win_get_config(winid)
    if winconfig.relative ~= "" then
        return
    end
    local absolute_path = vim.fn.expand("%:p:h") -- 获取完整路径
    local path = vim.fn.expand("%:~:.:h")
    local cwd = vim.fn.getcwd()
    local statusline = require("arrow.statusline")
    local arrow = statusline.text_for_statusline() -- Same, but with an bow and arrow icon ;D
    local arrow_icon = ""
    if arrow ~= "" then
        arrow_icon = "󰣉"
        icon = ""
        arrow = " (" .. arrow .. ")"
        iconHighlight = "ArrowIcon"
    end
    pcall(function()
        if path ~= "" and filename ~= "" then
            if not vim.startswith(absolute_path, cwd) then
                local winbar_expr = " "
                    .. " "
                    .. "%#LibPath#"
                    .. path
                    .. "%#Comment#"
                    .. " => "
                    .. "%#"
                    .. iconHighlight
                    .. "#"
                    .. arrow_icon
                    .. icon
                    .. " %#WinbarFileName#"
                    .. filename
                    .. "%#"
                    .. iconHighlight
                    .. "#"
                    .. arrow
                    .. "%*"
                    .. "%=%m %f"
                vim.wo[winid].winbar = winbar_expr
                vim.b.winbar_expr = winbar_expr
            else
                local winbar_expr = " "
                    .. "%#NvimTreeFolderName#"
                    .. " "
                    .. path
                    .. " => "
                    .. "%#"
                    .. iconHighlight
                    .. "#"
                    .. arrow_icon
                    .. icon
                    .. " %#WinbarFileName#"
                    .. filename
                    .. "%#"
                    .. iconHighlight
                    .. "#"
                    .. arrow
                    .. "%*"
                vim.wo[winid].winbar = winbar_expr
                vim.b.winbar_expr = winbar_expr
            end
        elseif filename ~= "" then
            vim.wo.winbar = "%#WinbarFileName#" .. filename .. "%*"
        else
            vim.wo.winbar = ""
        end
    end)
end

_G.Time = function(start, msg)
    msg = msg or ""
    local duration = 0.000001 * (vim.loop.hrtime() - start)
    if msg == "" then
        vim.schedule(function()
            print(vim.inspect(duration))
        end)
    else
        vim.schedule(function()
            print(msg .. ":", vim.inspect(duration))
        end)
    end
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

    -- ux
    local commands = table.concat({
        "horizontal copen",
        (opts.scroll_to_end and "normal! G") or "",
        "wincmd p",
    }, "\n")

    vim.cmd(commands)
end

_G.no_animation = function(length)
    length = length or 0
    vim.g.neovide_cursor_animation_length = 0
    vim.defer_fn(function()
        if vim.api.nvim_get_mode().mode ~= "i" then
            return
        end
        vim.g.neovide_cursor_animation_length = length
    end, 100)
end

_G.Cursor = function(callback, length)
    length = length or 0
    return function(...)
        vim.g.neovide_cursor_animation_length = length
        callback(...)
        vim.defer_fn(function()
            if vim.api.nvim_get_mode().mode ~= "i" then
                return
            end
            vim.g.neovide_cursor_animation_length = _G.CI
        end, 100)
    end
end

return M
