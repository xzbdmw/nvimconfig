local M = {}
_G.FeedKeys = function(keymap, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keymap, true, false, true), mode, true)
end

local function get_normal_bg_color()
    local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)
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
    local hl = vim.api.nvim_get_hl_by_name("Cursor", true)
    hl.blend = 100
    timeout = timeout or 0
    ---@diagnostic disable-next-line: undefined-field
    vim.opt.guicursor:append("a:Cursor/lCursor")
    pcall(vim.api.nvim_set_hl, 0, "Cursor", hl)

    callback()

    local old_hl = hl
    old_hl.blend = 0
    vim.defer_fn(function()
        ---@diagnostic disable-next-line: undefined-field
        vim.opt.guicursor:remove("a:Cursor/lCursor")
        pcall(vim.api.nvim_set_hl, 0, "Cursor", old_hl)
    end, timeout)
end

local function check_trouble()
    local ret = false
    if require("trouble").is_open("before_qflist") then
        vim.cmd("Trouble before_qflist toggle focus=false")
        ret = true
    elseif require("trouble").is_open("mydiags") then
        vim.cmd("Trouble mydiags toggle filter.buf=0 focus=false")
        ret = true
    end
    return ret
end

function M.close_win()
    if check_trouble() then
        return
    end
    local nvimtree_present = false
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        local buf_name = vim.api.nvim_buf_get_name(buf_id)
        if string.find(buf_name, "NvimTree") then
            nvimtree_present = true
            break
        end
    end
    local win_amount = M.get_non_float_win_count()
    if win_amount == 1 or (nvimtree_present and win_amount == 2) then
        vim.cmd("BufDel")
    else
        local windows = vim.api.nvim_list_wins()
        local is_split = false

        for _, win in ipairs(windows) do
            local success, win_config = pcall(vim.api.nvim_win_get_config, win)
            if success then
                if win_config.relative ~= "" then
                    goto continue
                end
            end
            local win_height = vim.api.nvim_win_get_height(win)
            ---@diagnostic disable-next-line: deprecated
            local screen_height = vim.api.nvim_get_option("lines")
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
    local window_count = #vim.api.nvim_list_wins()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                window_count = window_count - 1
            end
        end
    end
    return window_count
end

local has_map = false
function M.insert_mode_space()
    _G.no_animation()
    FeedKeys("<Space>", "n")
    if has_map or vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return
    end
    local changed_keys = {
        ["<esc>"] = "<esc>",
        ["<C-a>"] = "a",
        ["<C-b>"] = "b",
        ["<C-c>"] = "c",
        ["<C-d>"] = "d",
        ["<C-e>"] = "e",
        ["<C-f>"] = "f",
        ["<C-g>"] = "g",
        ["<C-h>"] = "h",
        ["<C-i>"] = "i",
        ["<C-j>"] = "j",
        ["<C-k>"] = "k",
        ["<C-l>"] = "l",
        ["<C-m>"] = "m",
        ["<C-n>"] = "n",
        ["<C-o>"] = "o",
        ["<C-p>"] = "p",
        ["<C-q>"] = "q",
        ["<C-r>"] = "r",
        ["<C-s>"] = "s",
        ["<C-t>"] = "t",
        ["<C-u>"] = "u",
        ["<C-v>"] = "v",
        ["<C-w>"] = "w",
        ["<C-x>"] = "x",
        ["<C-y>"] = "y",
        ["<C-z>"] = "z",
    }
    for k, v in pairs(changed_keys) do
        vim.keymap.set("i", k, function()
            if v == "<esc>" then
                local key_comb = "."
                FeedKeys("<bs>" .. key_comb, "n")
            else
                local key_comb = "." .. v
                FeedKeys("<bs>" .. key_comb, "n")
            end
        end, { buffer = 0, desc = "dot" })
    end
    has_map = true
    vim.defer_fn(function()
        local map = vim.api.nvim_buf_get_keymap(0, "i")
        for _, m in ipairs(map) do
            if m.desc == "dot" then
                ---@diagnostic disable-next-line: undefined-field
                vim.keymap.del("i", m.lhs, { buffer = 0 })
            end
        end
        if M.if_multicursor() then
            vim.keymap.set("i", "<C-d>", function()
                require("multicursors.insert_mode").C_w_method()
            end, { buffer = true })
        end
        has_map = false
    end, 150)
end

function M.if_multicursor()
    local ns = vim.api.nvim_create_namespace("multicursors")
    local extmark = vim.api.nvim_buf_get_extmarks(0, ns, { 0, 0 }, { -1, -1 }, {})
    if extmark ~= nil and #extmark ~= 0 then
        return true
    end
    return false
end

---@diagnostic disable-next-line: lowercase-global
function M.normal_tab()
    local flag = false
    local window_count = M.get_non_float_win_count()
    local current_win = vim.api.nvim_get_current_win()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
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
                    vim.api.nvim_set_current_win(win)
                end
                break
            end
        end
    end
    if flag == false and window_count ~= 2 then
        local cur = vim.api.nvim_get_current_win()
        local ok = true
        while ok do
            vim.cmd("wincmd w")
            local buf = vim.api.nvim_get_current_buf()
            local new_win = vim.api.nvim_get_current_win()
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

function M.insert_mode_tab()
    vim.g.neovide_cursor_animation_length = 0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 100)
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
        FeedKeys("<right>", "t")
        return
    end
end

_G.no_delay = function(animation)
    TST = vim.uv.hrtime()
    vim.g.type_o = true
    vim.g.enter = true
    vim.g.neovide_cursor_animation_length = animation
    vim.schedule(function()
        -- Time(TYO, "no_delay: ")
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local ts_indent = require("nvim-treesitter.indent")
        local success, indent_number = pcall(ts_indent.get_indent, row)
        vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_create_namespace("illuminate.highlight"), 0, -1)
        if not success or col >= indent_number then
            return
        end
        local indent = string.rep(" ", indent_number)
        local line = vim.trim(vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1])
        vim.api.nvim_buf_set_lines(0, row - 1, row, false, { indent .. line })
        success = pcall(vim.api.nvim_win_set_cursor, 0, { row, indent_number })
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
        vim.g.type_o = false
        vim.g.enter = false
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 50)
end

function M.checkSplitAndSetLaststatus()
    local windows = vim.api.nvim_list_wins()
    local is_split = false
    for _, win in ipairs(windows) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                goto continue
            end
        end
        local win_height = vim.api.nvim_win_get_height(win)
        ---@diagnostic disable-next-line: deprecated
        local screen_height = vim.api.nvim_get_option("lines")
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
    local api = vim.api
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

function M.set_glance_keymap()
    local winconfig = vim.api.nvim_win_get_config(0)
    local bufnr = vim.api.nvim_get_current_buf()
    if winconfig.relative ~= "" and winconfig.zindex == 10 then
        if _G.glance_buffer[bufnr] ~= nil then
            return
        end

        local function glance_close()
            ---@diagnostic disable-next-line: undefined-global
            pcall(satellite_close, vim.api.nvim_get_current_win())
            ---@diagnostic disable-next-line: undefined-global
            pcall(close_stored_win, vim.api.nvim_get_current_win())
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
            pcall(satellite_close, vim.api.nvim_get_current_win())
            ---@diagnostic disable-next-line: undefined-global
            pcall(close_stored_win, vim.api.nvim_get_current_win())
            vim.defer_fn(function()
                Open()
            end, 5)
        end, { buffer = bufnr })
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
    if vim.bo[ev.buf].filetype == "oil" and vim.api.nvim_get_current_buf() == ev.buf then
        local path, hl = OilDir()
        local winbar_content = "%#" .. hl .. "#" .. path .. "%*"
        vim.api.nvim_set_option_value("winbar", winbar_content, { scope = "local", win = 0 })

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

function M.set_glance_winbar()
    local winconfig = vim.api.nvim_win_get_config(0)
    if winconfig.relative ~= "" and winconfig.zindex == 9 then
        local function checkGlobalVarAndSetWinBar()
            -- 检查全局变量是否设置
            if _G.glance_listnr ~= nil then
                -- 如果已设置，执行 vim.wo 操作
                vim.wo.winbar = " %#Comment#"
                    .. string.format("%s (%d)", get_lsp_method_label(_G.glance_list_method), _G.glance_listnr)
            else
                -- 如果未设置，10 毫秒后再次检查
                vim.defer_fn(checkGlobalVarAndSetWinBar, 1)
            end
        end

        -- 开始轮询
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
function M.set_winbar()
    if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "toggleterm" or vim.bo.filetype == "DiffviewFiles" then
        return
    end
    local filename = vim.fn.expand("%:t")
    local devicons = require("nvim-web-devicons")
    local icon, iconHighlight = devicons.get_icon(filename, string.match(filename, "%a+$"), { default = true })
    local winid = vim.api.nvim_get_current_win()
    local winconfig = vim.api.nvim_win_get_config(winid)
    if winconfig.relative ~= "" then
        return
    end
    local absolute_path = vim.fn.expand("%:p:h") -- 获取完整路径
    local path = vim.fn.expand("%:~:.:h")
    local cwd = vim.fn.getcwd()
    if filename:match("%.rs$") then
        iconHighlight = "RustIcon"
        icon = "󱘗"
    end
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
                vim.wo[winid].winbar = " "
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
            else
                vim.wo[winid].winbar = " "
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
    local word = vim.fn.expand("<cword>")
    vim.fn.setqflist({}, "r")
    vim.cmd("silent vimgrep /" .. word .. "/ %")
end

function M.check_splits()
    local windows = vim.api.nvim_list_wins()
    local real_file_count = 0

    for _, win_id in ipairs(windows) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        local file_path = vim.api.nvim_buf_get_name(buf_id)

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
        vim.g.neovide_cursor_animation_length = length
    end, 100)
end

_G.Cursor = function(callback, length)
    length = length or 0
    return function(...)
        vim.g.neovide_cursor_animation_length = length
        callback(...)
        vim.defer_fn(function()
            vim.g.neovide_cursor_animation_length = _G.CI
        end, 100)
    end
end

-- vim.keymap.set("n", "<leader>zz", function()
--     local start_time = vim.loop.hrtime()
--     local buf = vim.api.nvim_create_buf(false, true)
--     local str = "&a ;int a "
--     -- local str = 's:="adsasds"'
--     local filetype = "cpp"
--     vim.api.nvim_buf_set_lines(buf, 0, -1, false, { str })
--     local win = vim.api.nvim_open_win(buf, true, { relative = "editor", row = 0, col = 0, height = 10, width = 40 })
--     local query = vim.treesitter.query.get(filetype, "highlights")
--     local parser = vim.treesitter.get_string_parser(str, filetype)
--     local tree = parser:parse(false)[1]
--     local root = tree:root()
--     if query == nil then
--         return
--     end
--     for id, node in query:iter_captures(root, str, 0, -1) do
--         local name = "@" .. query.captures[id] .. "." .. filetype
--         local priority = 200
--         if name == "@interface.name" then
--             priority = 1000
--         end
--         local hl = vim.api.nvim_get_hl_id_by_name(name)
--         -- __AUTO_GENERATED_PRINT_VAR_START__
--         -- print([==[function#for name:]==], vim.inspect(name)) -- __AUTO_GENERATED_PRINT_VAR_END__
--         local range = { node:range() }
--         -- __AUTO_GENERATED_PRINT_VAR_START__
--         -- print([==[function#for range:]==], vim.inspect(range)) -- __AUTO_GENERATED_PRINT_VAR_END__
--         local nsrow, nscol, nerow, necol = range[1], range[2], range[3], range[4]
--         local ns_id = vim.api.nvim_create_namespace("cmp")
--         -- __AUTO_GENERATED_PRINT_VAR_START__
--         -- print([==[function#for nscol:]==], vim.inspect(nscol)) -- __AUTO_GENERATED_PRINT_VAR_END__
--         -- __AUTO_GENERATED_PRINT_VAR_START__
--         -- print([==[function#for nsrow:]==], vim.inspect(nsrow)) -- __AUTO_GENERATED_PRINT_VAR_END__
--         vim.api.nvim_buf_set_extmark(buf, ns_id, nsrow, nscol, {
--             end_col = necol,
--             priority = priority,
--             hl_group = hl,
--         })
--         -- end
--     end
--     if start_time then
--         local duration = 0.000001 * (vim.loop.hrtime() - start_time)
--         -- __AUTO_GENERATED_PRINT_VAR_START__
--         print([==[function duration:]==], vim.inspect(duration)) -- __AUTO_GENERATED_PRINT_VAR_END__
--     end
-- end)
return M
