local function handler(_, result, ctx)
    if result ~= nil then
        if result.contents ~= nil then
            local content = result.contents.value
            if content ~= nil then
                if not vim.startswith(content, "```go") then
                    content = "```go\n" .. content .. "```"
                end
                local mode = api.nvim_get_mode().mode
                if mode == "v" or mode == "V" then
                    FeedKeys("<Esc>", "n")
                end
                local bufnr, winid = vim.lsp.util.open_floating_preview({ content }, "markdown")
                api.nvim_set_current_win(winid)
            end
        end
    end
end

-- vim.keymap.set("v", "<Tab>", function()
--     local mode = api.nvim_get_mode().mode
--     if mode == "v" or mode == "V" then
--         local o_range = require("vim.lsp.buf").range_from_selection(0, mode)
--         local param = vim.lsp.util.make_position_params(0, nil)
--         local range = {}
--         range["end"] = {}
--         range["start"] = {}
--         range["end"].line = o_range["end"][1] - 1
--         range["end"].character = o_range["end"][2]
--         range["start"].line = o_range["start"][1] - 1
--         range["start"].character = o_range["start"][2]
--         param.range = range
--         vim.lsp.buf_request(0, "textDocument/hover", param, handler)
--     end
-- end, { buffer = true })
