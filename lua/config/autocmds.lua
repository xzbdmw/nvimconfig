-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- auto close
--
vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        vim.cmd("syntax off")
    end,
})
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
                table.insert(invalid_win, w)
            end
        end
        if #invalid_win == #wins - 1 then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(invalid_win) do
                vim.api.nvim_win_close(w, true)
            end
        end
    end,
})

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("jk", true, false, true), "t", true)
    end, opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
local bufenter = true
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if bufenter then
            vim.cmd("NvimTreeToggle")
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "t", true)
            bufenter = false
        end
    end,
})
-- walkaroud for incremental selection
vim.api.nvim_create_augroup("_cmd_win", { clear = true })
vim.api.nvim_create_autocmd("CmdWinEnter", {
    callback = function()
        vim.keymap.del("n", "<CR>", { buffer = true })
    end,
    group = "_cmd_win",
})

local function checkSplitAndReSetLaststatus()
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
        -- vim.schedule()
        print("set statue = 0")
        vim.cmd("set laststatus=0")
    end
end

local function checkSplitAndSetLaststatus()
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
        -- print("set statue = 3")
        -- vim.schedule()
        vim.cmd("set laststatus=3")
    end
end

vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",

    callback = function()
        if vim.bo.filetype == "noice" then
            return
        else
            checkSplitAndSetLaststatus()
        end
    end,
})

local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_del_augroup_by_name("lazyvim_close_with_q")
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q_and_status"),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", function()
            local windows = vim.api.nvim_list_wins()
            local is_split = false

            for i, win in ipairs(windows) do
                local success, win_config = pcall(vim.api.nvim_win_get_config, win)
                if success then
                    if win_config.relative ~= "" then
                        goto continue
                    end
                end
                local win_height = vim.api.nvim_win_get_height(win)
                local screen_height = vim.api.nvim_get_option("lines")
                print("round:")
                print(i)
                print("win_height")
                print(win_height)
                print("screen_height")
                print(screen_height)
                if win_height + 1 < screen_height then
                    is_split = true
                    break
                end
                ::continue::
            end

            if is_split then
                -- print("hello")
                -- vim.schedule()
                vim.cmd("set laststatus=0")
            end
            vim.cmd("close")
        end, { buffer = event.buf, silent = true })
    end,
})
-- vim.api.nvim_create_autocmd("WinClosed", {
--     pattern = "*",
--
--     callback = function()
--         if vim.bo.filetype == "noice" then
--             return
--         else
--             checkSplitAndReSetLaststatus()
--         end
--     end,
-- })
