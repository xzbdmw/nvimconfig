local utils = require("config.utils")
local bufnr = api.nvim_get_current_buf()
local keymap = vim.keymap.set
-- keymap({ "n", "v" }, "gl", function()
--     vim.cmd.RustLsp({ "hover", "actions" })
--     vim.defer_fn(function()
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

-- vim.keymap.set({ "n", "i" }, "<d-y>", function()
--     local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--     local c = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})
--     local params = {
--         textDocument = {
--             uri = vim.uri_from_bufnr(0), -- Use the current buffer's URI
--         },
--         position = vim.lsp.util.make_position_params().position, -- Get the current cursor position
--         ch = c[1], -- Example trigger character that triggers the formatting
--         options = {
--             tabSize = 4,
--             insertSpaces = true, -- Use spaces instead of tabs
--         },
--     }
--     vim.lsp.buf_request(0, "textDocument/onTypeFormatting", params, function(err, result)
--         if err then
--             print("Error formatting: " .. err.message)
--         else
--             -- Apply the result (TextEdits) to the buffer
--             if result then
--                 for _, edit in ipairs(result) do
--                     vim.lsp.util.apply_text_edits({ edit }, api.nvim_get_current_buf(), "utf-8")
--                 end
--             end
--         end
--     end)
-- end)

keymap("n", "<leader>cp", function()
    vim.cmd.RustLsp("explainError")
end, { silent = true, buffer = bufnr, desc = "rust hover type info" })
keymap("n", "<C-e>", function()
    vim.cmd("RustLsp renderDiagnostic cycle")
end, { silent = true, buffer = bufnr, desc = "rust render diagnostics" })
keymap({ "x" }, "<Tab>", function()
    vim.cmd.RustLsp({ "hover", "range" })
    vim.defer_fn(function()
        FeedKeys("<esc>", "n")
        vim.cmd.RustLsp({ "hover", "range" })
    end, 100)
end, { silent = true, buffer = bufnr, desc = "rust hover range" })
keymap({ "n" }, "K", "6k", { silent = true, buffer = bufnr, desc = "K" })
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
