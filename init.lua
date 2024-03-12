FeedKeys = function(keymap, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keymap, true, false, true), mode, true)
end
---@diagnostic disable: undefined-global
-- -- bootstrap lazy.nvim, LazyVim and your plugins
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(_)
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
        end
    end,
})

-- 定义全局变量来缓存 winbar 的固定内容
local winbar_cache = ""
local pre_filename = ""
-- 更新固定内容的函数
local function update_winbar_cache()
    if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "toggleterm" or vim.bo.filetype == "aerial" then
        return
    end
    local telescopeUtilities = require("telescope.utils")
    local icon, iconHighlight = telescopeUtilities.get_devicons(vim.bo.filetype)
    local path = vim.fn.expand("%:~:.:h")

    local absolute_path = vim.fn.expand("%:p:h") -- 获取完整路径
    local filename = vim.fn.expand("%:t")

    local cwd = vim.fn.getcwd()
    pre_filename = filename
    if path == nil or filename == nil then
        return
    end
    if filename:match("%.rs$") then
        iconHighlight = "RustIcon"
        icon = "󱘗"
    end
    if not vim.startswith(absolute_path, cwd) then
        winbar_cache = " "
            .. " "
            .. "%#LibPath#"
            .. path
            .. "%#Comment#"
            .. " => "
            .. "%#"
            .. iconHighlight
            .. "#"
            .. icon
            .. " %#WinbarFileName#"
            .. filename
            .. "%*"
    else
        -- 在当前工作目录下，使用默认颜色
        winbar_cache = " "
            .. "%#NvimTreeFolderName#"
            .. " "
            .. path
            .. " => "
            .. "%#"
            .. iconHighlight
            .. "#"
            .. icon
            .. " %#WinbarFileName#"
            .. filename
            .. "%*"
    end
end

-- 更新 winbar 内容，仅添加动态变化的百分比部分
local function update_winbar_with_percentage()
    local win_config = vim.api.nvim_win_get_config(0)
    if win_config.relative ~= "" then
        return
    end
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local percentage = math.floor((current_line / total_lines) * 100)
    if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "toggleterm" or vim.bo.filetype == "aerial" then
        return
    end
    -- if winbar_cache == nil or winbar_cache == "" then
    if vim.fn.expand("%:t") ~= pre_filename then
        update_winbar_cache()
    end
    -- end
    vim.wo.winbar = winbar_cache .. "%#Comment#" .. " - " .. percentage .. "%%"
end

-- 注册 BufEnter 事件来更新缓存
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = update_winbar_cache,
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
            pre_filename = filename
            if path == nil or filename == nil then
                return
            end
            if filename:match("%.rs$") then
                iconHighlight = "RustIcon"
                icon = "󱘗"
            end

            local current_line = vim.fn.line(".")
            local total_lines = vim.fn.line("$")
            local percentage = math.floor((current_line / total_lines) * 100)
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
                    .. "%#GlanceWinbarFolderName#"
                    .. path
            end
            -- update_winbar_with_percentage()
        end
    end,
})

-- 注册 CursorMoved 事件来仅更新动态变化的部分
vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*",
    callback = update_winbar_with_percentage,
})
local config_group = vim.api.nvim_create_augroup("MyConfigGroup", {}) -- A global group for all your config autocommands

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "fzf" then
            return
        else
            vim.cmd.mkview({ mods = { emsg_silent = true } })
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "fzf" then
            return
        else
            vim.cmd.loadview({ mods = { emsg_silent = true } })
        end
    end,
})

vim.cmd([[set viewoptions-=curdir]])

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionLoadPost",
    group = config_group,
    callback = function()
        require("nvim-tree.api").tree.toggle({ focus = false })
    end,
})
require("config.lazy")
