return {
    "ojroques/nvim-bufdel",
    config = function()
        local function isBufferInCwd(bufinfo)
            local filePath = vim.fn.expand("#" .. bufinfo.bufnr .. ":p")
            local cwd = vim.fn.getcwd() .. "/" -- 确保cwd以斜杠结尾
            return vim.startswith(filePath, cwd)
        end
        require("bufdel").setup({
            -- next = function()
            --     local buf = vim.fn.bufnr()
            --     local buffers, buf_index = {}, 1
            --     for i, bufinfo in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
            --         if isBufferInCwd(bufinfo) then
            --             if buf == bufinfo.bufnr then
            --                 buf_index = i
            --             end
            --             table.insert(buffers, bufinfo.bufnr)
            --         end
            --     end
            --     if buf_index == #buffers and #buffers > 1 then
            --         return buffers[#buffers - 1]
            --     end
            --     print(
            --         [==[get_next_buf buffers[buf_index % #buffers + 1]:]==],
            --         vim.inspect(buffers[buf_index % #buffers + 1])
            --     return buffers[buf_index % #buffers + 1]
            -- end,
            quit = false, -- quit Neovim when last buffer is closed
        })
        vim.keymap.set("n", "<leader>D", "<cmd>BufDelOthers<CR>")
    end,
}
