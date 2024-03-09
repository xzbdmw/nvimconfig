-- -- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--
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
