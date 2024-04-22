require("config.lazy")
FeedKeys = function(keymap, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keymap, true, false, true), mode, true)
end
local function regexEscape(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

--[[ local start_time = nil
local end_time = nil
-- 注册BufLeave事件，在离开当前buffer时记录时间
vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        start_time = os.clock()
    end,
})
vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
end)
-- 注册BufEnter事件，在进入新的buffer时记录时间
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        end_time = os.clock()
        if start_time then
            local elapsed_time = end_time - start_time
            print("Buffer切换完成，耗时: " .. elapsed_time .. " 秒")
        end
    end,
}) ]]
vim.keymap.set("n", "<C-;>", function()
    local start_time = nil
    local end_time = nil
    start_time = os.clock()
    vim.cmd("e /Users/xzb/.config/nvim/lua/plugins/cmp.lua")
    end_time = os.clock()
    local elapsed_time = end_time - start_time
    print("Buffer切换完成，耗时: " .. elapsed_time .. " 秒")
end)

vim.api.nvim_create_augroup("LeapIlluminate", {})
_G.leapjump = false
vim.api.nvim_create_autocmd("User", {
    pattern = "LeapSelectPre",
    callback = function()
        _G.leapjump = true
        local buf = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        require("illuminate.engine").refresh_references(buf, win)
    end,
    group = "LeapIlluminate",
})

--[[ vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}) ]]

vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        vim.cmd([[silent! mkview!]])
    end,
})

-- nvim-cmp
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    pattern = "*:n",
    callback = function()
        _G.has_moved_up = false
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

-- walkaroud for incremental selection
vim.api.nvim_create_augroup("cmdwin_treesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "qf",
    },
    command = "TSBufDisable incremental_selection",
})
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

-- cmp completion
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "s:i",
    callback = function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-9>", true, false, true), "m", true)
    end,
})
Start = 0

--[[ vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "n:i",
    callback = function()
        local eend = os.clock()
        local elapsed_time = eend - Start
        print("Buffer切换完成，耗时: " .. elapsed_time .. " 秒")
    end,
}) ]]

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
                Open()
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

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        --[[ for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            -- Don't save while there's any 'nofile' buffer open.
            if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
                return
            end
        end ]]
        require("session_manager").save_current_session()
    end,
})
---@diagnostic disable: undefined-global
-- bootstrap lazy.nvim, LazyVim and your plugins
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(_)
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
        end
    end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function(args)
        local telescopeUtilities = require("telescope.utils")
        local icon, iconHighlight = telescopeUtilities.get_devicons(vim.bo.filetype)
        if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "toggleterm" then
            return
        end
        local winid = vim.api.nvim_get_current_win()
        local winconfig = vim.api.nvim_win_get_config(winid)
        if winconfig.relative ~= "" then
            return
        end
        local absolute_path = vim.fn.expand("%:p:h") -- 获取完整路径
        local path = vim.fn.expand("%:~:.:h")
        local cwd = vim.fn.getcwd()
        local filename = vim.fn.expand("%:t")
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
        local winconfig = vim.api.nvim_win_get_config(winid)
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
    end,
})

-- fold
--[[ vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.defer_fn(function()
            vim.cmd("set foldmethod=manual")
            -- vim.cmd("set foldlevel=999")
        end, 1000)
    end,
}) ]]

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
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
    end,
})
local config_group = vim.api.nvim_create_augroup("MyConfigGroup", {}) -- A global group for all your config autocommands
--
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "fzf" then
            if
                _G.fzf_win ~= nil
                and _G.fzf_view ~= nil
                and _G.fzf_buf ~= nil
                and vim.api.nvim_win_is_valid(_G.fzf_win)
                and _G.fzf_view ~= nil
                and vim.api.nvim_buf_is_valid(_G.fzf_buf)
            then
                local ns = vim.api.nvim_create_namespace("symbol_highlight")
                vim.api.nvim_buf_clear_namespace(_G.fzf_buf, ns, 0, -1)
                vim.api.nvim_win_call(_G.fzf_win, function()
                    vim.fn.winrestview(_G.fzf_view)
                end)
                return
            end
        else
            vim.cmd([[silent! mkview!]])
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "fzf" then
            return
        else
            vim.cmd([[silent! loadview]])
        end
    end,
})
vim.cmd([[set viewoptions-=curdir]])

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionLoadPost",
    group = config_group,
    callback = function()
        require("nvim-tree.api").tree.toggle({ focus = false })
        vim.cmd([[silent! loadview]])
    end,
})

--[[ local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
    require("profile").instrument_autocmds()
    if should_profile:lower():match("^start") then
        require("profile").start("*")
    else
        require("profile").instrument("*")
    end
end

local function toggle_profile()
    local prof = require("profile")
    if prof.is_recording() then
        prof.stop()
        vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
                prof.export(filename)
                vim.notify(string.format("Wrote %s", filename))
            end
        end)
    else
        prof.start("*")
    end
end
vim.keymap.set("", "<leader>pr", toggle_profile) ]]
