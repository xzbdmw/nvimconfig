-- bootstrap lazy.nvim, LazyVim and your plugins
-- require("config.lazy")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(_)
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
        end
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        local telescopeUtilities = require("telescope.utils")
        local icon, iconHighlight = telescopeUtilities.get_devicons(vim.bo.filetype)
        if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "toggleterm" then
            return
        end
        if vim.api.nvim_win_get_config(0).relative ~= "" then
            return
        end
        local path = vim.fn.expand("%:~:.:h")
        local filename = vim.fn.expand("%:t")
        if path ~= "" and filename ~= "" then
            -- vim.wo.winbar = "  %#WinbarFolder#" .. path .. "%#WinbarFolder#/" .. "%#WinbarFileName#" .. filename .. "%*"
            vim.wo.winbar = " "
                .. "%#NvimTreeFolderName#"
                .. " "
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
        elseif filename ~= "" then
            vim.wo.winbar = "%#WinbarFileName#" .. filename .. "%*"
        else
            vim.wo.winbar = ""
        end
    end,
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
