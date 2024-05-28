require("config.lazy")
vim.uv = vim.loop

vim.cmd("syntax off")
vim.api.nvim_create_augroup("LeapIlluminate", {})

-- sync system clipboard while yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        local v = vim.v.event
        local regcontents = v.regcontents
        vim.defer_fn(function()
            vim.fn.setreg("+", regcontents)
        end, 100)
    end,
})

-- sync system clipboard to vim clipboard
vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
        local loaded_content = vim.fn.getreg("+")
        if loaded_content ~= "" then
            vim.fn.setreg('"', loaded_content)
        end
    end,
})

-- Not needed because delete also trigger TextYankPost
-- vim.api.nvim_create_autocmd("TextChanged", {
--     callback = function()
--         if vim.system == nil then
--             return
--         end
--         vim.schedule(function()
--             local s = vim.fn.getreg('"')
--             vim.system({ "echo", s, "| pbcopy" })
--         end)
--     end,
-- })

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "TelescopePreviewerLoaded",
    callback = function(data)
        local winid = data.data.winid
        vim.wo[winid].number = true
        vim.defer_fn(function()
            pcall(function()
                require("treesitter-context").context_force_update(vim.api.nvim_win_get_buf(winid), winid)
                ---@diagnostic disable-next-line: undefined-field
                pcall(_G.indent_update, winid)
            end)
        end, 5)
    end,
})
_G.leapjump = false
vim.api.nvim_create_autocmd("User", {
    pattern = { "LeapSelectPre" },
    callback = function()
        _G.leapjump = true
        local buf = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        require("illuminate.engine").refresh_references(buf, win)
    end,
    group = "LeapIlluminate",
})

vim.api.nvim_create_autocmd("User", {
    pattern = { "ArrowUpdate" },
    callback = function()
        vim.cmd("NvimTreeRefresh")
    end,
})

vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        vim.cmd([[silent! mkview!]])
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help" },
    callback = function()
        -- vim.treesitter.stop()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "undotree", "diff" },
    callback = function()
        vim.cmd([[syntax on]])
    end,
})

-- nvim-cmp
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    pattern = "*:n",
    callback = function()
        _G.has_moved_up = false
    end,
})

vim.api.nvim_create_autocmd({ "TermEnter", "BufEnter" }, {
    callback = function()
        if vim.opt.buftype:get() == "terminal" then
            vim.cmd(":startinsert")
        end
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(args)
        local opts = { buffer = 0 }
        if vim.endswith(args.file, [[#1]]) then
            vim.keymap.set("t", "<Tab>", [[<C-\><C-n><Tab>]], { remap = true, buffer = 0 })
            vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        end
        vim.keymap.set("t", "<C-d>", [[<C-\><C-w>]], opts)
    end,
})

-- walkaroud for incremental selection
vim.api.nvim_create_augroup("cmdwin_treesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "qf",
    },
    command = "TSBufDisable incremental_selection",
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
        vim.keymap.set("n", "q", function()
            vim.g.neovide_cursor_animation_length = 0.0
            vim.defer_fn(function()
                vim.g.neovide_cursor_animation_length = 0.06
            end, 100)
            return "<cmd>close<cr>"
        end, { expr = true, buffer = event.buf, silent = true })
    end,
})

_G.glance_buffer = {}
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.defer_fn(function()
            vim.cmd("set foldmethod=manual")
        end, 100)
        local winconfig = vim.api.nvim_win_get_config(0)
        local bufnr = vim.api.nvim_get_current_buf() -- 获取当前缓冲区编号
        if winconfig.relative ~= "" and winconfig.zindex == 10 then
            if _G.glance_buffer[bufnr] ~= nil then
                return
            end

            local function glance_close()
                vim.g.neovide_cursor_animation_length = 0.0
                pcall(satellite_close, vim.api.nvim_get_current_win())
                pcall(close_stored_win, vim.api.nvim_get_current_win())
                Close_with_q()
                vim.defer_fn(function()
                    vim.g.neovide_cursor_animation_length = 0.06
                    pcall(_G.indent_update)
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
                pcall(satellite_close, vim.api.nvim_get_current_win())
                pcall(close_stored_win, vim.api.nvim_get_current_win())
                vim.defer_fn(function()
                    vim.g.neovide_cursor_animation_length = 0.06
                end, 100)
                vim.defer_fn(function()
                    Open()
                end, 5)
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
        vim.cmd([[silent! mkview!]])
        pcall(_G.indent_update)
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            -- Don't save while there's any 'nofile' buffer open.
            if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
                return
            end
        end
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
    callback = function()
        if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "toggleterm" then
            return
        end
        local filename = vim.fn.expand("%:t")
        local devicons = require("nvim-web-devicons")
        local icon, iconHighlight = devicons.get_icon(filename, vim.bo.filetype, { default = true })
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
        local winconfig = vim.api.nvim_win_get_config(winid)
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
    end,
})

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

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    pattern = "*",
    callback = function()
        vim.g.gd = true
        vim.defer_fn(function()
            vim.g.gd = false
        end, 100)
    end,
})

vim.cmd([[set viewoptions-=curdir]])

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionLoadPost",
    group = config_group,
    callback = function()
        local tree = require("nvim-tree.api").tree
        pcall(tree.toggle, { focus = false })
        vim.defer_fn(function()
            vim.g.neovide_cursor_animation_length = 0.06
            vim.cmd("NvimTreeRefresh")
            pcall(_G.indent_update)
        end, 100)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = {
        "MiniFilesActionCreate",
        "MiniFilesActionRename",
        "MiniFilesActionCopy",
        "MiniFilesActionMove",
    },
    callback = function()
        vim.cmd("NvimTreeRefresh")
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak keys to your liking
        vim.keymap.set("n", "q", function()
            MiniFiles.close()
        end, { buffer = buf_id })
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionDelete",
    callback = function(args)
        local from_path = args.data.from
        local bufnr = vim.fn.bufnr(from_path)
        if bufnr ~= -1 then
            vim.api.nvim_buf_delete(bufnr, {})
        end
        vim.cmd("NvimTreeRefresh")
    end,
})

vim.lsp.set_log_level("off")
local should_profile = os.getenv("NVIM_PROFILE")
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
vim.keymap.set({ "n", "i" }, "<D-i>", toggle_profile)

-- vim.api.nvim_create_autocmd("CursorMoved", {
--     callback = function()
--         if vim.g.gd then
--             if ST ~= nil then
--                 Time(ST, "CursorMoved")
--             end
--         end
--     end,
-- })

local origin = vim.lsp.util.jump_to_location
vim.lsp.util.jump_to_location = function(location, offset_encoding, reuse_win)
    ST = vim.uv.hrtime()
    vim.g.neovide_cursor_animation_length = 0.0
    origin(location, offset_encoding, reuse_win)
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = 0.06
    end, 100)
end
