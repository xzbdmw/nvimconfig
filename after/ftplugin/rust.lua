local bufnr = vim.api.nvim_get_current_buf()
local keymap = vim.keymap.set
keymap({ "n", "v" }, "gl", function()
    vim.cmd.RustLsp({ "hover", "actions" })
    vim.defer_fn(function()
        FeedKeys("<esc>", "n")
        vim.cmd.RustLsp({ "hover", "range" })
    end, 100)
end, { silent = true, buffer = bufnr, desc = "lsp hover in rust" })

keymap("n", "<leader>cp", function()
    vim.cmd.RustLsp("explainError")
end, { silent = true, buffer = bufnr, desc = "rust hover type info" })
keymap("n", "<C-e>", function()
    vim.cmd.RustLsp("renderDiagnostic")
end, { silent = true, buffer = bufnr, desc = "rust render diagnostics" })
keymap({ "x" }, "<Tab>", function()
    vim.cmd.RustLsp({ "hover", "range" })
    vim.defer_fn(function()
        FeedKeys("<esc>", "n")
        vim.cmd.RustLsp({ "hover", "range" })
    end, 100)
end, { silent = true, buffer = bufnr, desc = "rust hover range" })
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

keymap({ "n" }, "<leader>gr", function()
    vim.cmd.RustLsp({ "runnables", bang = true })
end, { silent = true, buffer = bufnr, desc = "resume rust testables" })
keymap({ "n" }, "<leader>gt", function()
    vim.cmd.RustLsp({ "testables", bang = true })
end, { silent = true, buffer = bufnr, desc = "resume rust testables" })
