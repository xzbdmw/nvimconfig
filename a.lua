local configs = require("nvim-treesitter.configs")

local M = {}

---@param config TSModule
---@param lang string
---@return boolean
local function should_enable_vim_regex(config, lang)
    local additional_hl = config.additional_vim_regex_highlighting
    local is_table = type(additional_hl) == "table"

    ---@diagnostic disable-next-line: param-type-mismatch
    return additional_hl and (not is_table or vim.tbl_contains(additional_hl, lang))
end
local function begin_ts_highlight(bufnr, lang)
    if ST ~= nil then
        Time(ST, "begin parse")
    end
    local config = configs.get_module("highlight")
    vim.treesitter.start(buf, lang)
    if config and should_enable_vim_regex(config, lang) then
        vim.bo[buf].syntax = "ON"
    end
    vim.defer_fn(function()
        local success, t = pcall(require, "treesitter-context")
        if success then
            pcall(t.context_force_update)
        end
    end, 10)
end
local timer = vim.loop.new_timer()
---@param bufnr integer
---@param lang string
function M.attach(bufnr, lang)
    vim.g.has_start = false
    if timer:is_active() then
        timer:close()
    else
        timer = vim.loop.new_timer()
        vim.g.has_start = false
    end
    local timout = function()
        if timer:is_active() then
            print("timer is still active")
            timer:close()
        end
        if vim.g.has_start then
            return
        end
        vim.g.has_start = true
        vim.g.gd = false
        begin_ts_highlight(bufnr, lang)
    end
    vim.defer_fn(function()
        timout()
    end, 100)
    vim.defer_fn(function()
        timout()
    end, 1000)
    vim.defer_fn(function()
        timout()
    end, 2000)
    local col = vim.fn.screencol()
    local row = vim.fn.screenrow()
    timer:start(5, 2, function()
        vim.schedule(function()
            if vim.g.has_start then
                if timer:is_active() then
                    timer:close()
                end
                return
            end
            local new_col = vim.fn.screencol()
            local new_row = vim.fn.screenrow()
            if new_row ~= row and new_col ~= col then
                if timer:is_active() then
                    timer:close()
                end
                vim.g.has_start = true
                vim.g.gd = false
                begin_ts_highlight(bufnr, lang)
            end
        end)
    end)
    -- vim.api.nvim_create_autocmd({ "WinScrolled", "CursorMoved" }, {
    --   once = true,
    --   callback = function(args)
    -- vim.defer_fn(function()
    --   local config = configs.get_module "highlight"
    --   pcall(vim.treesitter.start, bufnr, lang)
    --   if config and should_enable_vim_regex(config, lang) then
    --     vim.bo[bufnr].syntax = "ON"
    --   end
    --   vim.defer_fn(function()
    --     local success, t = pcall(require, "treesitter-context")
    --     if success then
    --       pcall(t.context_force_update)
    --     end
    --   end, 10)
    -- end, 10)
    -- vim.schedule(function()
    --   local success, noice = pcall(require, "noice.message.router")
    --   if success then
    --     noice.update(true)
    --   end
    --   local config = configs.get_module "highlight"
    --   pcall(vim.treesitter.start, bufnr, lang)
    --   if config and should_enable_vim_regex(config, lang) then
    --     vim.bo[bufnr].syntax = "ON"
    --   end
    --   vim.defer_fn(function()
    --     local success, t = pcall(require, "treesitter-context")
    --     if success then
    --       pcall(t.context_force_update)
    --     end
    --   end, 20)
    -- end)
    --   end,
    -- })
end

---@param bufnr integer
function M.detach(bufnr)
    vim.treesitter.stop(bufnr)
end

---@deprecated
function M.start(...)
    vim.notify(
        "`nvim-treesitter.highlight.start` is deprecated: use `nvim-treesitter.highlight.attach` or `vim.treesitter.start`",
        vim.log.levels.WARN
    )
    M.attach(...)
end

---@deprecated
function M.stop(...)
    vim.notify(
        "`nvim-treesitter.highlight.stop` is deprecated: use `nvim-treesitter.highlight.detach` or `vim.treesitter.stop`",
        vim.log.levels.WARN
    )
    M.detach(...)
end

return M
