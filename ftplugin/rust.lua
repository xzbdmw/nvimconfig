vim.cmd([[
setlocal comments=s0:/*!,ex:*/,s1:/*,mb:*,ex:*/,:///,://!,://
setlocal commentstring=//\ %s
]])
vim.b.did_ftplugin = 1
vim.keymap.set("x", "<leader>sp", function()
    FeedKeys('<esc>"zyaq', "mx")
    local content = vim.fn.getreg(string.format("z"))
    FeedKeys("caq", "m")
    FeedKeys("string.format(" .. content .. ")<esc>", "n")
end)
local utils = require("config.utils")
local bufnr = api.nvim_get_current_buf()
local keymap = vim.keymap.set
-- keymap({ "n", "v" }, "gl", hello()
--     vim.cmd.RustLsp({ "hover", "actions" })
--     vim.defer_fn(hello()
--         FeedKeys("<esc>", "n")
--         vim.cmd.RustLsp({ "hover", "range" })
--     end, 100)
-- end, { silent = true, buffer = bufnr, desc = "lsp hover in rust" })

keymap({ "v", "n" }, "<leader>vp", function()
    local w = utils.get_cword()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local _, col = vim.api.nvim_get_current_line():find("^%s*")
    ---@diagnostic disable-next-line: param-type-mismatch
    local edits = string.rep(" ", col, "") .. string.format("dbg!(&%s);", w)
    vim.api.nvim_buf_set_lines(0, row, row, false, { edits })
end, { buffer = bufnr })

keymap("n", "<leader>cp", function()
    vim.cmd.RustLsp("explainError")
end, { silent = true, buffer = bufnr, desc = "rust hover type info" })
keymap("n", "<C-e>", function()
    if require("config.utils").try_wrap() then
        return
    end
    vim.cmd("RustLsp renderDiagnostic cycle")
end, { silent = true, buffer = bufnr, desc = "rust render diagnostics" })
keymap({ "x" }, "<Tab>", function()
    vim.cmd.RustLsp({ "hover", "range" })
    vim.defer_fn(function()
        FeedKeys("<esc>", "n")
        vim.cmd.RustLsp({ "hover", "range" })
    end, 100)
end, { silent = true, buffer = bufnr, desc = "rust hover range" })
keymap({ "n" }, "K", "5k", { silent = true, buffer = bufnr, desc = "K" })
keymap({ "n", "i" }, "<f4>", function()
    vim.cmd.RustLsp("runnables")
end, { silent = true, buffer = bufnr, desc = "rust runable" })
keymap({ "n", "i" }, "<f6>", function()
    vim.cmd.RustLsp("testables")
end, { silent = true, buffer = bufnr, desc = "rust testables" })
-- keymap({ "n", "i" }, "<C-a>", function()
--     vim.cmd.RustLsp("codeAction")
-- end, { silent = true, buffer = bufnr, desc = "code actions" })
--
-- keymap({ "n" }, "<leader>ca", function()
--     vim.cmd.RustLsp("codeAction")
-- end, { silent = true, buffer = bufnr, desc = "codeAction" })

-- keymap({ "n" }, "<leader>gr", function()
--     vim.cmd.RustLsp({ "runnables", bang = true })
-- end, { silent = true, buffer = bufnr, desc = "resume rust testables" })
-- keymap({ "n" }, "<leader>gt", function()
--     vim.cmd.RustLsp({ "testables", bang = true })
-- end, { silent = true, buffer = bufnr, desc = "resume rust testables" })
for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end
