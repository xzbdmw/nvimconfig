-- -- Keymaps are automatically loaded on the VeryLazy event
-- -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local del = vim.keymap.del
local keymap = vim.keymap.set
local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.hover = "gh"
del("n", "<leader>w-")
del("n", "<leader>ww")
del("n", "<leader>wd")
del("t", "<esc><esc>")
del("n", "<leader>w|")
del({ "n", "x" }, "<space>wÞ")
-- del({ "n", "x" }, "gsÞ")

-- dap
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

keymap("i", "<Tab>", function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(1, col):match("^%s*$") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "t", true)
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
                    if current_win ~= win and win_config.zindex ~= 20 and win_config.zindex ~= 60 then
                        -- change flag to indicate that we have change current_win, so no need to cycle
                        flag = true
                        vim.api.nvim_set_current_win(win)
                    end
                    break
                end
            end
        end
        if flag == false and window_count ~= 2 then
            vim.cmd([[
  let w0 = winnr()
  let nok = 1
  while nok
    exe 'wincmd ' 'w'
    let w = winnr()
    let n = bufname('%')
    let nok = (n=~'NVimTree') && (w != w0)
  endwhile
]])
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
end)

keymap("", "<D-a>", "ggVG", opts)
keymap({ "n", "i" }, "<D-w>", function()
    local win_amount = #vim.api.nvim_tabpage_list_wins(0)
    if win_amount == 1 then
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
keymap("n", "<leader>vr", "<cmd>vsp<CR>")
keymap("n", "<leader>vd", "<cmd>sp<CR>")
keymap("n", "<leader><leader>h", "<C-w>H", opts)
keymap("n", "<leader><leader>j", "<C-w>J", opts)
keymap("n", "<leader><leader>k", "<C-w>K", opts)
keymap("n", "<leader><leader>l", "<C-w>L", opts)

keymap({ "n", "v" }, "J", "4j", opts)
keymap({ "n", "v" }, "K", "4k", opts)
keymap("n", "<C-b>", "<C-v>", opts)
keymap({ "n", "i" }, "<D-s>", function()
    if vim.bo.modified then
        vim.cmd("write")
    end
end, opts)
keymap("i", "<D-v>", '<C-r>"', opts)
keymap("c", "<D-v>", "<C-r>+<CR>", opts)
keymap("n", "<D-z>", "u", opts)
keymap("i", "<D-z>", "<Esc>u", opts)
keymap("n", "<leader>j", "<C-o>", opts)
keymap({ "n", "i" }, "<f11>", "<C-o>", opts)
keymap("n", "<leader>k", "<C-i>", opts)
keymap({ "n", "i" }, "<f18>", "<C-i>", opts)
keymap({ "s", "i", "n" }, "<C-7>", function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            -- print(vim.inspect(win_config))
            if win_config.relative ~= "" then
                vim.api.nvim_win_close(win, true)
            end
        end
    end
end, opts)
