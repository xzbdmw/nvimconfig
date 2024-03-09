-- -- Keymaps are automatically loaded on the VeryLazy event-- -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.hover = "gh"
local del = vim.keymap.del
-- del("n", "<leader>w-")
-- del("n", "<leader>ww")
-- del("n", "<leader>wd")
-- del("t", "<esc><esc>")
-- del("n", "<leader>fn")
-- del("n", "<leader>w|")
-- del("n", "<leader>qq")
-- del({ "n", "x" }, "<space>qÞ")
--[[ del({ "n", "x" }, "<space>wÞ")
keymap({ "v", "i" }, "<C-5>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, false, true), "n", true)
    -- require("luasnip").jump(1)

    -- return "<C-n>"
end) ]]
keymap("n", "D", "d$", opts)
keymap("n", "<C-i>", "<C-i>", opts)
keymap("n", "Q", "qa", opts)
keymap({ "n", "v" }, "L", "$", opts)
keymap({ "n", "v" }, "H", "^", opts)

-- keymap("n", "q", "<Nop>", opts)
keymap({ "n", "v" }, "<D-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
keymap({ "n", "v" }, "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
keymap({ "n", "v" }, "<D-0>", "<cmd>lua vim.g.neovide_scale_factor = 1<CR>")

--[[ keymap("n", "<down>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap("n", "<up>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap("i", "<down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap("v", "<down>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<up>", ":m '<-2<cr>gv=gv", { desc = "Move up" }) ]]

keymap("n", "U", "<C-r>", opts)
keymap("n", "Y", "y$", opts)
keymap("n", "<leader>q", "<cmd>qall!<CR>", opts)
keymap({ "n", "v" }, "c", '"_c', opts)
keymap("v", "<down>", "", opts)
keymap("n", "[p", '"0p', opts)
keymap("v", "<up>", ":MoveBlock(-1)<CR>", opts)
keymap("v", "<down>", ":MoveBlock(1)<CR>", opts)
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
keymap("v", "<leader>gb", "gcgbkgb", opts)
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

local start_time = nil
local end_time = nil
-- 注册BufLeave事件，在离开当前buffer时记录时间
vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        start_time = os.clock()
        print("开始切换Buffer")
    end,
})
vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
end)
-- 注册BufEnter事件，在进入新的buffer时记录时间
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        print("asdasdasd")
        end_time = os.clock()
        if start_time then
            local elapsed_time = end_time - start_time
            print("Buffer切换完成，耗时: " .. elapsed_time .. " 秒")
        end
    end,
})
keymap("n", "<Tab>", function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0) -- 获取当前窗口的光标位置
    local line_num = cursor_pos[1] -- 光标所在的行号
    local fold_start = vim.fn.foldclosed(line_num)
    if fold_start == -1 then
        local flag = false
        local window_count = get_non_float_win_count()
        local current_win = vim.api.nvim_get_current_win()
        for _, win in pairs(vim.api.nvim_list_wins()) do
            local success, win_config = pcall(vim.api.nvim_win_get_config, win)
            -- print(vim.inspect(win_config))
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
        -- if window_count == 1 then
        --     return
        -- end
        -- 当前有两个以上窗口的时候 忽略nvimtree
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
    else
        require("ufo").peekFoldedLinesUnderCursor()
    end
end, { desc = "swicth window" })

-- keymap("i", "<CR>", function()
--     local col = vim.fn.col(".") - 1 -- 获取光标当前列的位置
--     ---@diagnostic disable-next-line: param-type-mismatch
--     local char = vim.fn.getline("."):sub(col, col)
--     if col > 0 and (char == "{" or char == "(") then
--         return "<C-g>u<CR><C-c>O" -- 如果光标前的字符是 '{'，则执行 <CR> 后在上一行插入新行
--     else
--         return "<C-g>u<CR>" -- 否则，只执行普通的 <CR>
--     end
-- end, { expr = true })

--[[ keymap("i", "<bs>", function()
    local pairs = {
        ['"'] = '"',
        ["'"] = "'",
        ["["] = "]",
        ["{"] = "}",
        ["("] = ")",
        ["<"] = ">",
    }
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1 -- Lua中的索引从1开始，而API使用的是从0开始的索引
    local line = vim.api.nvim_get_current_line()
    local before = line:sub(col, col) -- 获取光标前的字符
    local after = line:sub(col + 1, col + 1) -- 获取光标后的字符
    if pairs[before] and pairs[before] == after then -- 检查前后是否为双引号
        return "<right><C-g>u<bs><bs>"
    else
        return "<C-g>u<bs>"
    end
end, { expr = true }) ]]
keymap("c", "<C-d>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "t", true)
end, opts)
keymap("i", "<C-d>", "<C-g>u<C-w>", opts)
keymap("i", "<C-u>", "<C-g>u<C-u>", opts)
keymap("i", ".", "<C-g>u.", opts)
keymap("i", ",", "<C-g>u,", opts)
keymap("i", "<space>", "<C-g>u<space>", opts)
keymap("i", "<C-r>", "<C-g>u<C-r>", opts)

keymap("i", "<C-CR>", "<CR>", opts)
keymap("i", "<C-e>", "<esc>A", opts)
-- keymap("i", "<C-CR>", "<CR>", opts)
keymap({ "n", "i" }, "<C-e>", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
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
keymap({ "n" }, "<leader>w", function()
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
keymap({ "n", "i" }, "<D-s>", function()
    -- if vim.bo.modified then
    vim.cmd("write")
    -- end
end, opts)
keymap("i", "<D-v>", "<C-g>u<C-r>1", opts)
keymap("c", "<D-v>", "<C-r>+<CR>", opts)
keymap("n", "<D-z>", "u", opts)
keymap("i", "<D-z>", "<C-o>u", opts)
keymap("n", "<leader>j", "<C-o>", opts)
keymap({ "n", "i" }, "<f11>", "<C-o>", opts)
keymap("n", "<M-w>", "<c-w>", opts)
keymap("n", "<leader>k", "<C-i>", opts)

keymap({ "n", "i" }, "<f18>", "<C-i>", opts)
--nvimtree workaround
keymap("n", "<C-f>", "<cmd>NvimTreeFocus<CR>")
keymap({ "n" }, "<leader>fn", '<cmd>lua require("nvim-tree.api").fs.create()<CR>', { desc = "create new file" })

keymap({ "s", "i", "n" }, "<C-7>", function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                print(vim.inspect(win_config))
                print(win_config.zindex)
                vim.api.nvim_win_close(win, true)
            end
        end
    end
end, opts)

keymap("x", "<bs>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("holo", true, false, true), "t", false)
end, opts)

keymap("n", "<leader>d", function()
    local def_or_ref = require("custom.definitions")
    -- -- local def_or_ref = require("custom.definition-or-references.main")
    def_or_ref.definition_or_references()
    -- vim.lsp.buf.definition()
end)
keymap({ "s", "i", "n" }, "<esc>", function()
    local flag = true
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            -- print(vim.inspect(win_config))
            if
                win_config.relative ~= "" and win_config.zindex == 45
                or win_config.zindex == 44
                or win_config.zindex == 46
                or win_config.zindex == 47
                or win_config.zindex == 50
                or win_config.zindex == 80
            then
                flag = false
                vim.api.nvim_win_close(win, true)
            elseif win_config.zindex == 10 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
        end
    end
    if flag then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        vim.cmd("noh")
    end
end)
