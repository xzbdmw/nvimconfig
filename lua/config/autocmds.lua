-- Autocmds are automatically loaded on the VeryLazy event
vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")
vim.api.nvim_del_augroup_by_name("lazyvim_close_with_q")

-- vim.api.nvim_create_autocmd("BufLeave", {
--     callback = function()
--         local t = {
--             file = vim.fn.expand("<afile>"),
--             buf = vim.fn.expand("<abuf>"),
--             math = vim.fn.expand("<amatch>"),
--         }
--         print(vim.inspect(t))
--     end,
-- })
--[[ local start_time = nil
local end_time = nil
-- 注册BufLeave事件，在离开当前buffer时记录时间
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
}) ]]
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
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-d>", [[<C-w>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

--[[local bufenter = true
 vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if bufenter then
            print("hello")
            vim.cmd("NvimTreeToggle")
            -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "t", true)
            bufenter = false
        end
    end,
}) ]]

-- walkaroud for incremental selection
vim.api.nvim_create_augroup("cmdwin_treesitter", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
    pattern = "*",
    command = "TSBufDisable incremental_selection",
    group = "cmdwin_treesitter",
    desc = "Disable treesitter's incremental selection in Command-line window",
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "txt",
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
        "vim",
        "neotest-output-panel",
        "toggleterm",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "s:i",
    callback = function()
        -- vim.defer_fn(function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-9>", true, false, true), "m", true)
        -- end, 10)
    end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = { "*:V", "*:no" },
    callback = function()
        vim.opt.relativenumber = true
    end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = { "no:*", "V:*" },
    callback = function()
        vim.opt.relativenumber = false
    end,
})

_G.glancebuffer = {}
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        local winconfig = vim.api.nvim_win_get_config(0)
        local bufnr = vim.api.nvim_get_current_buf() -- 获取当前缓冲区编号
        if winconfig.relative ~= "" and winconfig.zindex == 10 then
            if _G.glancebuffer[bufnr] ~= nil then
                return
            end
            _G.glancebuffer[bufnr] = true
            vim.keymap.set("n", "<Esc>", function()
                Close_with_q()
            end, { buffer = bufnr })

            vim.keymap.set("n", "q", function()
                Close_with_q()
            end, { buffer = bufnr })

            vim.keymap.set("n", "<CR>", function()
                OpenAndKeepHighlight()
            end, { buffer = bufnr })
        end
    end,
})

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

vim.api.nvim_create_autocmd("WinResized", {
    pattern = "*",
    callback = function()
        checkSplitAndSetLaststatus()
        -- vim.cmd("FocusAutoresize")
    end,
})
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")
vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = {
        "/Users/xzb/.rustup/toolchains/**/*.rs",
        "/Users/xzb/.cargo/**/*.rs",
        "/opt/homebrew/Cellar/**/*.go",
    },
    command = "setlocal nomodifiable",
})

local api = vim.api
local function setUndotreeWinSize()
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

api.nvim_create_user_command("Ut", function()
    ---@diagnostic disable-next-line: param-type-mismatch
    api.nvim_cmd(api.nvim_parse_cmd("UndotreeToggle", {}), {})
    setUndotreeWinSize()
end, { desc = "load undotree" })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            -- Don't save while there's any 'nofile' buffer open.
            if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
                return
            end
        end
        require("session_manager").save_current_session()
    end,
})
