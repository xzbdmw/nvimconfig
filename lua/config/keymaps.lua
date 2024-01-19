-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
function Is_neotree_visible()
    local neotree_visible = false
    local windows = vim.api.nvim_tabpage_list_wins(0)
    for _, win in pairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if string.find(buf_name, "neo%-tree") and vim.api.nvim_win_is_valid(win) then
            local win_info = vim.api.nvim_win_get_position(win)
            if win_info[1] >= 0 and win_info[2] >= 0 then
                neotree_visible = true
                break
            end
        end
    end
    return neotree_visible
end

function Toggle_neotree()
    if Is_neotree_visible() then
        -- 如果 Neo-tree 已经可见，那么隐藏它
        vim.cmd("Neotree toggle=true")
    else
        -- 如果 Neo-tree 不可见，那么显示它
        vim.cmd("Neotree filesystem reveal left")
    end
end

-- 检查当前激活的窗口是否是 Neotree 窗口
local function is_current_win_neotree()
    local current_buf = vim.api.nvim_win_get_buf(0)
    local current_buf_name = vim.api.nvim_buf_get_name(current_buf)
    return string.find(current_buf_name, "neo%-tree") ~= nil
end

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
keymap({ "n", "i" }, "<M-p>", function()
    require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "toggle signature" })
keymap("n", "J", "3j", opts)
keymap("n", "K", "3k", opts)
keymap({ "n", "i" }, "<C-6>", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", opts)
keymap("n", "<space>fa", ":Telescope file_browser<CR>", opts)
keymap("n", "<leader>uz", "<Cmd>Telescope frecency<CR>")
keymap("c", "<D-CR>", "<CR>", opts)
keymap({ "n", "i" }, "<D-e>", function()
    require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
        path_display = require("custom/path_display").filenameFirst,
        layout_strategy = "horizontal",
        previewer = false,
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        layout_config = {
            horizontal = {
                width = 0.35,
                height = 0.7,
            },
            preview_cutoff = 0,
            mirror = false,
        },
    }))
end, { noremap = true, silent = true, desc = "find files in cwd" })

keymap("n", "gs", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "go to sticky scroll" })
-- Keep the yanked term
keymap("v", "p", '"_dP', opts)
-- keymap("x", "<leader>p", '"_dP', opts)
-- Moving a block of code that you've highlighted
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)
keymap("x", "J", ":m '>+1<CR>gv=gv", opts)
keymap("x", "K", ":m '<-2<CR>gv=gv", opts)
keymap("n", "<D-s>", ":w<CR>", opts)
keymap("n", "<C-a>", "<C-w>", opts)

keymap("i", "<D-s>", "<Esc>:w<CR>a", opts)
keymap({ "n", "v", "i" }, "<D-c>", "y", opts)
keymap("n", "<D-v>", "hp", opts)
keymap("i", "<D-v>", "<Esc>pa", opts)
keymap({ "n", "i" }, "<D-w>", ":BufDel<CR>", opts)
keymap({ "n", "i" }, "<D-z>", "u", opts)
keymap({ "n", "i" }, "<D-1>", ":Neotree filesystem reveal left<CR>", opts)
keymap({ "n", "i" }, "<D-1>", ":NvimTreeToggle<CR>", opts)
keymap("n", "<C-f>", ":NvimTreeFocus<CR>", opts)
keymap("n", "<leader>j", "<C-o>", opts)

keymap("n", "<f11>", "<C-o>", opts)
keymap("n", "<leader>k", "<C-i>", opts)
keymap("n", "<f18>", "<C-i>", opts)
keymap("n", "<leader>d", require("definition-or-references").definition_or_references, opts)
keymap({ "s", "i", "n" }, "<C-7>", function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            print(vim.inspect(win_config))
            if win_config.relative ~= "" then
                vim.api.nvim_win_close(win, true)
            end
        end
    end
end, opts)

keymap({ "s", "i", "n" }, "<esc>", function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            print(vim.inspect(win_config))
            if win_config.relative ~= "" then
                vim.api.nvim_win_close(win, true)
            end
        end
    end
    return "<esc>"
end, { expr = true })
