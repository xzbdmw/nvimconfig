vim.cmd([[
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s
]])
vim.b.did_ftplugin = 1

local function make_position(bufnr, position_encoding)
    local row, col = unpack(api.nvim_win_get_cursor(0))
    return {
        line = row - 1,
        character = vim.lsp.util.character_offset(bufnr, row - 1, col, position_encoding),
    }
end

local function make_visual_range(bufnr, mode, position_encoding)
    local start = vim.fn.getpos("v")
    local finish = vim.fn.getpos(".")
    local start_row = start[2] - 1
    local start_col = start[3] - 1
    local end_row = finish[2] - 1
    local end_col = finish[3] - 1

    if start_row > end_row or (start_row == end_row and start_col > end_col) then
        start_row, end_row = end_row, start_row
        start_col, end_col = end_col, start_col
    end

    if mode == "V" then
        start_col = 0
        local line = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, true)[1] or ""
        end_col = #line
    elseif vim.o.selection ~= "exclusive" then
        end_col = end_col + 1
    end

    return {
        ["start"] = {
            line = start_row,
            character = vim.lsp.util.character_offset(bufnr, start_row, start_col, position_encoding),
        },
        ["end"] = {
            line = end_row,
            character = vim.lsp.util.character_offset(bufnr, end_row, end_col, position_encoding),
        },
    }
end

local function handler(_, result, ctx)
    if result ~= nil then
        if result.contents ~= nil then
            local content = result.contents.value
            if content ~= nil then
                content = content:gsub("\\([\\`*_{}%[%]()#+%.!%-])", "%1")
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

vim.keymap.set("v", "<Tab>", function()
    local mode = api.nvim_get_mode().mode
    if mode == "v" or mode == "V" then
        local client = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })[1]
        local position_encoding = client and client.offset_encoding or "utf-16"
        local param = {
            textDocument = { uri = vim.uri_from_bufnr(0) },
            position = make_position(0, position_encoding),
            range = make_visual_range(0, mode, position_encoding),
        }
        vim.lsp.buf_request(0, "textDocument/hover", param, handler)
    end
end, { buffer = true })
