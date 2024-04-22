FeedKeys = function(keymap, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keymap, true, false, true), mode, true)
end
local function regexEscape(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end
-- you can use return and set your own name if you do require() or dofile()

-- like this: str_replace = require("string-replace")
-- return function (str, this, that) -- modify the line below for the above to work
string.replace = function(str, this, that)
    return str:gsub(regexEscape(this), that:gsub("%%", "%%%%")) -- only % needs to be escaped for 'that'
end
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
            vim.cmd([[silent! mkview 1]])
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "fzf" then
            return
        else
            vim.cmd([[silent! loadview 1]])
        end
    end,
})
vim.cmd([[set viewoptions-=curdir]])

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionLoadPost",
    group = config_group,
    callback = function()
        require("nvim-tree.api").tree.toggle({ focus = false })
        -- vim.cmd([[silent! loadview 1]])
    end,
})
require("config.lazy")
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
