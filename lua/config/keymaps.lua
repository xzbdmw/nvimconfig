local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.hover = "gh"

keymap({ "n", "i" }, "<D-s>", function()
    vim.cmd("write")
end, opts)
keymap({ "n" }, "<leader>w", function()
    vim.cmd("write")
end, opts)

keymap("i", "<c-g>", function()
    require("cmp").complete({
        config = {
            sources = {
                {
                    name = "rg",
                },
            },
        },
    })
end)
keymap("n", "<leader>h", function()
    FeedKeys("0", "n")
    vim.fn.winrestview({ leftcol = 0 })
    vim.schedule(function()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
        if char == " " then
            FeedKeys("w", "n")
        end
    end)
end, opts)
keymap({ "n", "i" }, "<f16>", "<cmd>ToggleTerm<CR>", opts)

_G.no_delay = function(animation)
    -- TYO = vim.uv.hrtime()
    vim.g.type_o = true
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
        pcall(_G.update_indent, true)
        pcall(_G.mini_indent_auto_draw)
        vim.g.type_o = false
        vim.g.neovide_cursor_animation_length = 0.06
    end, 50)
end

keymap("n", "o", function()
    -- ST = vim.uv.hrtime()
    _G.no_delay(0)
    return "o"
end, { expr = true, remap = true })
keymap("i", "<C-d>", "<C-w>", opts)
keymap("n", "`", function()
    vim.g.gd = true
    vim.g.neovide_cursor_animation_length = 0
    vim.defer_fn(function()
        vim.g.gd = false
        vim.g.neovide_cursor_animation_length = 0.06
    end, 100)
    return "<cmd>e #<cr>"
end, { expr = true })
keymap("n", "O", function()
    _G.no_delay(0)
    return "O"
end, { expr = true })

-- various textobjs
keymap({ "o", "x" }, "u", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>")
keymap({ "o", "x" }, "im", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>")
keymap({ "o", "x" }, "am", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>")
keymap({ "o", "x" }, "n", "$")

vim.keymap.set("n", "<leader>tt", function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local semantics = vim.inspect_pos()
    -- __AUTO_GENERATED_PRINT_VAR_START__
    print([==[function semantics:]==], vim.inspect(semantics)) -- __AUTO_GENERATED_PRINT_VAR_END__
end)
-- require("lspconfig").clangd.setup({})
keymap("n", "<leader>zz", function()
    local start_time = vim.loop.hrtime()
    local buf = vim.api.nvim_create_buf(false, true)
    local str = "for"
    -- local str = 's:="adsasds"'
    local filetype = "go"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { str })
    local win = vim.api.nvim_open_win(buf, true, { relative = "editor", row = 0, col = 0, height = 10, width = 40 })
    local query = vim.treesitter.query.get(filetype, "highlights")
    local parser = vim.treesitter.get_string_parser(str, filetype)
    local tree = parser:parse(false)[1]
    local root = tree:root()
    for _ = 1, 500 do
        for id, node in query:iter_captures(root, str, 0, -1) do
            local name = "@" .. query.captures[id] .. "." .. filetype
            local priority = 200
            if name == "@interface.name" then
                priority = 1000
            end
            local hl = vim.api.nvim_get_hl_id_by_name(name)
            -- __AUTO_GENERATED_PRINT_VAR_START__
            -- print([==[function#for name:]==], vim.inspect(name)) -- __AUTO_GENERATED_PRINT_VAR_END__
            local range = { node:range() }
            -- __AUTO_GENERATED_PRINT_VAR_START__
            -- print([==[function#for range:]==], vim.inspect(range)) -- __AUTO_GENERATED_PRINT_VAR_END__
            local nsrow, nscol, nerow, necol = range[1], range[2], range[3], range[4]
            local ns_id = vim.api.nvim_create_namespace("cmp")
            -- __AUTO_GENERATED_PRINT_VAR_START__
            -- print([==[function#for nscol:]==], vim.inspect(nscol)) -- __AUTO_GENERATED_PRINT_VAR_END__
            -- __AUTO_GENERATED_PRINT_VAR_START__
            -- print([==[function#for nsrow:]==], vim.inspect(nsrow)) -- __AUTO_GENERATED_PRINT_VAR_END__
            vim.api.nvim_buf_set_extmark(buf, ns_id, nsrow, nscol, {
                end_col = necol,
                priority = priority,
                hl_group = hl,
            })
        end
    end
    if start_time then
        local duration = 0.000001 * (vim.loop.hrtime() - start_time)
        -- __AUTO_GENERATED_PRINT_VAR_START__
        print([==[function duration:]==], vim.inspect(duration)) -- __AUTO_GENERATED_PRINT_VAR_END__
    end
end, opts)

keymap("n", "<leader>cm", "<cmd>messages clear<CR>", opts)
keymap("i", "<C-c>", function()
    vim.cmd("messages clear")
end, opts)
keymap({ "n" }, "<C-n>", function()
    vim.g.cmp_completion = false
    vim.cmd("MCstart")
end)
keymap("i", "h", function()
    -- require("plenary.profile").start("profilef.log", { flame = true })
    HK = vim.uv.hrtime()
    return "h"
end, { expr = true })

keymap({ "x" }, "<C-n>", function()
    vim.g.cmp_completion = false
    return "<cmd>MCstart<cr>"
end, { expr = true })

keymap("n", "D", "d$", opts)
keymap("n", "<C-i>", "<C-i>", opts)
keymap("n", "Q", "qa", opts)
keymap({ "n", "x" }, "L", "$", opts)

keymap("n", "<leader>zr", function()
    local fzf_lua = require("fzf-lua")
    local builtin = require("fzf-lua.previewer.builtin")

    local path = require("fzf-lua.path")
    -- Inherit from the "buffer_or_file" previewer
    local MyPreviewer = builtin.buffer_or_file:extend()

    function MyPreviewer:new(o, opts, fzf_win)
        MyPreviewer.super.new(self, o, opts, fzf_win)
        setmetatable(self, MyPreviewer)
        return self
    end

    local win = vim.api.nvim_get_current_win()
    local buffer = vim.api.nvim_get_current_buf()

    _G.fzf_win = win
    _G.fzf_view = vim.fn.winsaveview()
    _G.fzf_buf = buffer

    function MyPreviewer:parse_entry(entry_str)
        local s_line, e_line = require("config.utils").parseEntry(entry_str)
        local entry = path.entry_to_file(entry_str, self.opts)
        local ns = vim.api.nvim_create_namespace("symbol_highlight")
        vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)
        if s_line == e_line then
            vim.api.nvim_buf_set_extmark(buffer, ns, s_line - 1, 0, {
                line_hl_group = "SymbolHighlight",
            })
        else
            vim.api.nvim_buf_set_extmark(buffer, ns, s_line - 1, 0, {
                end_line = e_line - 1,
                end_col = 0,
                line_hl_group = "SymbolHighlight",
            })
        end
        vim.api.nvim_win_set_cursor(win, {
            entry.line,
            entry.col,
        })
        vim.api.nvim_win_call(win, function()
            vim.cmd("norm! zz")
            -- local invisible = e_line - vim.fn.line("w$") + 1
            -- if invisible > 0 then
            --     local view = vim.fn.winsaveview() --[[@as vim.fn.winrestview.dict]]
            --     view.topline = math.min(view.topline + invisible, math.max(1, s_line - vim.wo.scrolloff + 1))
            --     vim.fn.winrestview(view)
            -- end
        end)
        return entry
    end

    fzf_lua.lsp_document_symbols({
        winopts = {
            width = 0.4,
            height = 0.5,
            row = 0.35,
            col = 0.8,
        },
        previewer = MyPreviewer,
        prompt = "Select file> ",
    })
end, opts)
keymap({ "n", "v" }, "<D-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
keymap({ "n", "v" }, "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
keymap({ "n", "v" }, "<D-0>", "<cmd>lua vim.g.neovide_scale_factor = 1<CR>")
keymap("n", "U", "<C-r>", opts)
keymap("n", "<leader>q", "<cmd>qall!<CR>", opts)
keymap({ "n", "v" }, "c", '"_c', opts)
keymap("n", "Y", "y$", opts)
keymap("v", "<down>", "", opts)
keymap("n", "[p", '"0p', opts)
keymap("v", "<up>", ":MoveBlock(-1)<CR>", opts)
keymap("v", "<down>", ":MoveBlock(1)<CR>", opts)
keymap("n", "<up>", "<A-k>", { remap = true, desc = "Move Up" })
keymap("n", "<down>", "<A-j>", { remap = true, desc = "Move Down" })
keymap("v", "<up>", "<A-k>", { remap = true, desc = "Move Up" })
keymap("v", "<down>", "<A-j>", { remap = true, desc = "Move Down" })
keymap("n", "gs", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, opts)
keymap("n", "<leader>sd", function()
    vim.g.neovide_underline_stroke_scale = 0
    vim.cmd("DiffviewOpen")
end, opts)
keymap("n", "<leader>cd", function()
    vim.g.neovide_underline_stroke_scale = 2
    vim.cmd("DiffviewClose")
end, opts)
keymap("n", "<leader>ur", function()
    vim.o.relativenumber = vim.o.relativenumber == false and true or false
end, opts)
keymap("n", "za", "zfai", { remap = true })
keymap("n", "<leader><leader>s", function()
    vim.cmd("source %")
end, opts)
keymap("n", "<leader>sm", function()
    vim.cmd("messages")
end, opts)

local function get_normal_bg_color()
    local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)
    local bg_color = string.format("#%06x", normal_hl.background)
    return bg_color
end

local function load_appropriate_theme()
    local bg_color = get_normal_bg_color()
    if bg_color == "#24273a" then
        require("theme.dark")
    else
        require("theme.light")
    end
end
load_appropriate_theme()
--[[ keymap("n", "<leader>td", function()
    require("dapui").toggle()
end, { silent = true, noremap = true, desc = "toggle signature" })
keymap("n", "<F3>", function()
    require("dap").continue()
    require("dapui").toggle()
end)
keymap("n", "-", function()
    require("dap").step_over()
end)
keymap("n", "=", function()
    require("dap").step_into()
end)
keymap("n", "+", function()
    require("dap").step_out()
end)
keymap("n", "<Leader>bb", function()
    require("dap").toggle_breakpoint()
end)
keymap("n", "<Leader>B", function()
    require("dap").set_breakpoint()
end) ]]
keymap("n", "ge", "g;", opts)
keymap("v", "<leader>gb", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gcgvgb", true, false, true), "t", true)
end, opts)

keymap("i", "<Tab>", function()
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
end, opts)

local function get_non_float_win_count()
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

local function get_float_win_count()
    local window_count = #vim.api.nvim_list_wins()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if win_config.relative == "" then
                window_count = window_count - 1
            end
        end
    end
    return window_count
end

keymap("n", "<Tab>", function()
    local flag = false
    local window_count = get_non_float_win_count()
    local current_win = vim.api.nvim_get_current_win()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            -- if this win is float_win
            if win_config.relative ~= "" then
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
end, { desc = "swicth window" })

keymap("c", "<C-d>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "t", true)
end, opts)
keymap("x", "<C-r>", '"', opts)
-- keymap("i", "<C-r>", "<C-g>u<C-r>", opts)
keymap("n", "0", "^", opts)
keymap("i", "<C-e>", "<esc>A", opts)
-- keymap({ "n", "i" }, "<C-e>", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
keymap("n", "<D-a>", "ggVG", opts)
keymap({ "n", "i" }, "<D-w>", function()
    local nvimtree_present = false
    local aerial_present = false
    local term_present = false
    -- 遍历所有窗口
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        ---@diagnostic disable-next-line: deprecated
        local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), "filetype")
        -- 检查是否存在 NvimTree
        if filetype == "NvimTree" then
            nvimtree_present = true
        end

        if filetype == "aerial" then
            aerial_present = true
        end

        if filetype == "toggleterm" then
            term_present = true
        end

        if nvimtree_present and aerial_present and term_present then
            break
        end
    end

    -- 如果窗口数量为 1 或者任意窗口包含 NvimTree
    local win_amount = get_non_float_win_count()
    if
        win_amount == 1
        or (win_amount == 2 and nvimtree_present)
        or (win_amount == 2 and aerial_present)
        or (win_amount == 2 and term_present)
        or (win_amount == 3 and nvimtree_present and aerial_present)
        or (win_amount == 3 and nvimtree_present and term_present)
        or (win_amount == 3 and aerial_present and term_present)
        or (win_amount == 4 and nvimtree_present and aerial_present and term_present)
    then
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
        vim.cmd("close")
    end
end)
keymap({ "n" }, "q", function()
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
    local win_amount = get_non_float_win_count()
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
        vim.cmd("close")
    end
end)
keymap("c", "<C-p>", "<up>", opts)
keymap("c", "<C-n>", "<down>", opts)
keymap("n", "<leader>vr", "<cmd>vsp<CR>")
keymap("n", "<leader>vd", "<cmd>sp<CR>")
keymap("n", "<leader><leader>h", function()
    return "<C-w>H<cmd>FocusAutoresize<CR>"
end, { expr = true })
keymap("n", "<leader><leader>l", function()
    return "<C-w>L<cmd>FocusAutoresize<CR>"
end, { expr = true })
keymap("n", "<leader><leader>j", function()
    return "<C-w>J<cmd>FocusAutoresize<CR>"
end, { expr = true })
keymap("n", "<leader><leader>k", function()
    return "<C-w>K<cmd>FocusAutoresize<CR>"
end, { expr = true })
keymap({ "n", "v" }, "J", "4j", opts)
keymap({ "n", "v" }, "K", "4k", opts)
keymap("n", "<C-b>", "<C-v>", opts)

keymap("i", "<D-v>", function()
    return '<C-g>u<C-r><C-o>"'
end, { expr = true })

-- don't messy up indent
keymap("i", "<C-r>", "<C-r><C-o>", opts)

keymap("c", "<D-v>", "<C-r>+<CR>", opts)

keymap("n", "<D-z>", "u", opts)
keymap("i", "<D-z>", "<C-o>u", opts)

keymap("n", "<leader>j", function()
    vim.g.neovide_cursor_animation_length = 0.0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = 0.06
    end, 100)
    return "f{a<CR>"
end, { expr = true, remap = true })

keymap("n", "<f11>", function()
    vim.g.neovide_cursor_animation_length = 0.0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = 0.06
    end, 100)
    return "f{a<CR>"
end, { expr = true, remap = true })
keymap("n", "<M-w>", "<c-w>", opts)
keymap("n", "<leader>k", "<C-i>", opts)

keymap("t", "<D-v>", function()
    -- local next_char_code = vim.fn.getchar()
    local next_char_code = 48
    local next_char = vim.fn.nr2char(next_char_code)
    return '<C-\\><C-N>"' .. next_char .. "pi"
end, { expr = true })
keymap("x", "za", "zf", opts)
keymap("n", "zu", "zfu", { remap = true })
keymap({ "n", "i" }, "<f18>", "<C-i>", opts)
--nvimtree workaround
keymap("n", "<C-f>", "<cmd>NvimTreeFocus<CR>")
keymap({ "n" }, "<leader>fn", '<cmd>lua require("nvim-tree.api").fs.create()<CR>', { desc = "create new file" })

keymap("x", "<bs>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("holo", true, false, true), "t", false)
end, opts)

keymap({ "s", "i", "n" }, "<C-7>", function()
    print(get_float_win_count())
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                print(vim.inspect(win))
                print(vim.inspect(win_config))
                vim.api.nvim_win_close(win, true)
            end
        end
    end
end, opts)

keymap("x", "=", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("loho", true, false, true), "t", false)
end, opts)
keymap("n", "]q", function()
    vim.cmd("cnext")
end, opts)
keymap("n", "[q", function()
    vim.cmd("cprev")
end, opts)
keymap("n", "<leader>d", function()
    ST = vim.uv.hrtime()
    vim.g.gd = true
    vim.g.neovide_cursor_animation_length = 0.0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = 0.06
        vim.g.gd = false
    end, 100)
    vim.cmd("Glance definitions")
end)
keymap("n", "gd", function()
    vim.g.gd = true
    vim.g.neovide_cursor_animation_length = 0.0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = 0.06
        vim.g.gd = false
    end, 100)
    vim.lsp.buf.definition()
end)
local hl_enable = false
keymap("n", "<leader><right>", function()
    local hl = vim.api.nvim_set_hl
    if hl_enable then
        vim.cmd("DisableHL")
        hl(0, "MiniIndentscopeSymbol", { fg = "#E8E7E0" })
        hl_enable = false
    else
        vim.cmd("EnableHL")
        hl(0, "MiniIndentscopeSymbol", { fg = "#C0C0BE" })
        hl_enable = true
    end
end, opts)

local del = vim.keymap.del
del("n", "<leader>w-")
del("n", "<leader>ww")
del("n", "<leader>wd")
del("t", "<esc><esc>")
del("n", "<leader>fn")
del("n", "<leader>w|")
del("n", "<leader>qq")
-- del({ "n", "x" }, "<space>qÞ")
-- del({ "n", "x" }, "<space>wÞ")
del("n", "gsh")
del("n", "gshn")
del("n", "gshl")
