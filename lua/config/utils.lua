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

function M.close_win()
    local nvimtree_present = false
    -- 遍历所有窗口
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        local buf_name = vim.api.nvim_buf_get_name(buf_id)
        -- 检查是否存在 NvimTree
        if string.find(buf_name, "NvimTree") then
            nvimtree_present = true
            break
        end
    end
    -- 如果窗口数量为 1 或者任意窗口包含 NvimTree
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
        has_map = false
    end, 150)
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
        -- print(window_count)
        vim.cmd([[
        let w0 = winnr()
        let nok = 1
        while nok
          exe 'wincmd ' 'w'
          let w = winnr()
          let n = bufname('%')
        let nok = ( n=~'NVimTree' )   && (w != w0)
        endwhile
      ]])
        -- 当前有两个窗口的时候,可以切换到nvimtree
    elseif flag == false then
        vim.cmd([[
        let w0 = winnr()
        let nok = 1
        while nok
          exe 'wincmd ' 'w'
          let w = winnr()
          let n = bufname('%')
          let nok = (n=~'NVmTree') && (w != w0)
        endwhile
      ]])
    end
    local is_terminal = vim.opt.buftype:get() == "terminal"
    if is_terminal then
        _G.no_animation()
        vim.cmd(":startinsert")
    end
end
function M.insert_mode_tab()
    vim.g.neovide_cursor_animation_length = 0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 100)
    local col = vim.fn.col(".") - 1
    ---@diagnostic disable-next-line: param-type-mismatch
    local line = vim.fn.getline(".") -- 获取当前行的内容
    local line_len = #line
    if col == line_len then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
        return
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    if col == 0 or vim.fn.getline("."):sub(1, col):match("^%s*$") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
        return
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "t", true)
        return
    end
end

_G.no_delay = function(animation)
    TYO = vim.uv.hrtime()
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
-- _G.rust_query = vim.treesitter.query.parse(
--     "rust",
--     [[
-- (type_identifier) @type
-- (primitive_type) @type.builtin
-- (self) @variable.special
-- (field_identifier) @property
--
-- (call_expression
--   function: [
--     (identifier) @function
--     (scoped_identifier
--       nameb: (identifier) @function)
--     (field_expression
--       field: (field_identifier) @function.method)
--   ])
--
-- (generic_function
--   function: [
--         (identifier) @function
--     (scoped_identifier
--       name: (identifier) @function)
--     (field_expression
--       field: (field_identifier) @function.method)
--   ])
--
-- (function_item name: (identifier) @function.definition)
-- (function_signature_item name: (identifier) @function.definition)
--
-- (macro_invocation
--   macro: [
--     (identifier) @function.special
--     (scoped_identifier
--       name: (identifier) @function.special)
--   ])
--
-- (macro_definition
--   name: (identifier) @function.special.definition)
--
-- ; Identifier conventions
--
-- ; Assume uppercase names are types/enum-constructors
-- ((identifier) @type
--  (#match? @type "^[A-Z]"))
--
-- ; Assume all-caps names are constants
-- ((identifier) @constant
--  (#match? @constant "^_*[A-Z][A-Z\\d_]*$"))
--
-- [
--   "("
--   ")"
--   "{"
--   "}"
--   "["
--   "]"
-- ] @punctuation.bracket.special
--
-- (_
--   .
--   "<" @punctuation.bracket.special
--   ">" @punctuation.bracket.special)
--
-- [
--   "as"
--   "async"
--   "await"
--   "break"
--   "const"
--   "continue"
--   "default"
--   "dyn"
--   "else"
--   "enum"
--   "extern"
--   "fn"
--   "for"
--   "if"
--   "impl"
--   "in"
--   "let"
--   "loop"
--   "macro_rules!"
--   "match"
--   "mod"
--   "move"
--   "pub"
--   "ref"
--   "return"
--   "static"
--   "struct"
--   "trait"
--   "type"
--   "union"
--   "unsafe"
--   "use"
--   "where"
--   "while"
--   "yield"
--   (crate)
--   (mutable_specifier)
--   (super)
-- ] @keyword
--
-- [
--   (string_literal)
--   (raw_string_literal)
--   (char_literal)
-- ] @string
--
-- [
--   (integer_literal)
--   (float_literal)
-- ] @number
--
-- (boolean_literal) @constant
--
-- [
--   (line_comment)
--   (block_comment)
-- ] @comment]]
-- )
-- function M.parseEntry(entryStr)
--     ::POS::
--     local s, e, betweenParentheses = entryStr:find("%((.-)%)")
--     local sub = string.sub(entryStr, s, e)
--     if string.find(sub, "%:") == nil then
--         entryStr = string.sub(e, string.len(entryStr))
--         goto POS
--     end
--     if betweenParentheses then
--         local parts = {}
--         for part in betweenParentheses:gmatch("[^:]+") do
--             table.insert(parts, tonumber(part))
--         end
--
--         if #parts == 2 then
--             return parts[1], parts[2]
--         else
--             return nil, nil
--         end
--     else
--         return nil, nil
--     end
-- end
-- function M.WriteToFile(content)
--     local filename = "/Users/xzb/.local/share/nvim/lazy/multicursors.nvim/demo.txt"
--     local file = io.open(filename, "a")
--     if file then
--         file:write(content)
--
--         file:flush()
--     else
--     end
-- end
-- function M.get_visual_selection_text()
--     local _, srow, scol = unpack(vim.fn.getpos("v"))
--     local _, erow, ecol = unpack(vim.fn.getpos("."))
--
--     -- visual line mode
--     if vim.fn.mode() == "V" then
--         if srow > erow then
--             return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
--         else
--             return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
--         end
--     end
--
--     -- regular visual mode
--     if vim.fn.mode() == "v" then
--         if srow < erow or (srow == erow and scol <= ecol) then
--             return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
--         else
--             return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
--         end
--     end
--
--     -- visual block mode
--     if vim.fn.mode() == "\22" then
--         local lines = {}
--         if srow > erow then
--             srow, erow = erow, srow
--         end
--         if scol > ecol then
--             scol, ecol = ecol, scol
--         end
--         for i = srow, erow do
--             table.insert(
--                 lines,
--                 vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
--             )
--         end
--         return lines
--     end
-- end
-- local function qf_rename()
--     local what = 1
--     what = 4
--     what = 5
--     local new_name = vim.fn.expand("<cword>")
--     vim.cmd("undo!")
--     local position_param = vim.lsp.util.make_position_params()
--     position_param.oldName = vim.fn.expand("<cword>")
--     position_param.newName = new_name
--     -- __AUTO_GENERATED_PRINT_VAR_START__
--     print([==[qf_rename tesdt.oldName:]==], vim.inspect(position_param.oldName)) -- __AUTO_GENERATED_PRINT_VAR_END__
--     vim.lsp.buf_request(0, "textDocument/rename", position_param, function(err, result, ...)
--         if not result or not result.changes then
--             print(string.format("could not perform rename"))
--             return
--         end
--
--         vim.lsp.handlers["textDocument/rename"](err, result, ...)
--
--         local notification, entries = "", {}
--         local num_files, num_updates = 0, 0
--         for uri, edits in pairs(result.changes) do
--             num_files = num_files + 1
--             local bufnr = vim.uri_to_bufnr(uri)
--
--             for _, edit in ipairs(edits) do
--                 local start_line = edit.range.start.line + 1
--                 local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]
--
--                 num_updates = num_updates + 1
--                 table.insert(entries, {
--                     bufnr = bufnr,
--                     lnum = start_line,
--                     col = edit.range.start.character + 1,
--                     text = line,
--                 })
--                 local ns = vim.api.nvim_create_namespace("rename-highlights")
--                 local start = entries[#entries].col - 1
--                 if bufnr == vim.api.nvim_get_current_buf() then
--                     pcall(function()
--                         vim.api.nvim_buf_set_extmark(bufnr, ns, start_line - 1, start, {
--                             end_row = start_line - 1,
--                             end_col = start + #position_param.newName,
--                             hl_group = "Search",
--                         })
--                     end)
--                 end
--                 vim.defer_fn(function()
--                     vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
--                 end, 1000)
--             end
--
--             local short_uri = string.sub(vim.uri_to_fname(uri), #vim.fn.getcwd() + 2)
--             notification = notification .. string.format("made %d change(s) in %s\n", #edits, short_uri)
--         end
--
--         if num_files > 1 then
--             print(notification)
--             vim.fn.setqflist(entries, "r")
--             vim.cmd("Trouble qflist focus=false")
--         else
--             vim.notify(
--                 string.format(
--                     "[lsp] rename %s -> %s in %s place",
--                     position_param.oldName,
--                     position_param.newName,
--                     num_updates
--                 ),
--                 vim.log.levels.INFO
--             )
--         end
--     end)
-- end

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

-- kymap({ "n", "i" }, "<D-w>", function()
--     local nvimtree_present = false
--     local aerial_present = false
--     local term_present = false
--     -- 遍历所有窗口
--     for _, win_id in ipairs(vim.api.nvim_list_wins()) do
--         ---@diagnostic disable-next-line: deprecated
--         local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), "filetype")
--         -- 检查是否存在 NvimTree
--         if filetype == "NvimTree" then
--             nvimtree_present = true
--         end
--
--         if filetype == "aerial" then
--             aerial_present = true
--         end
--
--         if filetype == "toggleterm" then
--             term_present = true
--         end
--
--         if nvimtree_present and aerial_present and term_present then
--             break
--         end
--     end
--
--     -- 如果窗口数量为 1 或者任意窗口包含 NvimTree
--     local win_amount = utils.get_non_float_win_count()
--     if
--         win_amount == 1
--         or (win_amount == 2 and nvimtree_present)
--         or (win_amount == 2 and aerial_present)
--         or (win_amount == 2 and term_present)
--         or (win_amount == 3 and nvimtree_present and aerial_present)
--         or (win_amount == 3 and nvimtree_present and term_present)
--         or (win_amount == 3 and aerial_present and term_present)
--         or (win_amount == 4 and nvimtree_present and aerial_present and term_present)
--     then
--         vim.cmd("BufDel")
--     else
--         local windows = vim.api.nvim_list_wins()
--         local is_split = false
--         for _, win in ipairs(windows) do
--             local success, win_config = pcall(vim.api.nvim_win_get_config, win)
--             if success then
--                 if win_config.relative ~= "" then
--                     goto continue
--                 end
--             end
--             local win_height = vim.api.nvim_win_get_height(win)
--             ---@diagnostic disable-next-line: deprecated
--             local screen_height = vim.api.nvim_get_option("lines")
--             if win_height + 1 < screen_height then
--                 is_split = true
--                 break
--             end
--             ::continue::
--         end
--
--         if is_split then
--             vim.cmd("set laststatus=0")
--         end
--         vim.cmd("close")
--     end
-- end)
return M
