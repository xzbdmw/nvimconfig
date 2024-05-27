return {
    "smjonas/inc-rename.nvim",
    event = "VeryLazy",
    keys = {
        { "<leader>cr", ":IncRename " },
        {
            "r",
            function()
                local cword = vim.fn.expand("<cword>")
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "x", true)
                vim.cmd("Noice disable")
                vim.api.nvim_create_autocmd("CmdlineLeave", {
                    once = true,
                    callback = function()
                        vim.defer_fn(function()
                            vim.cmd("Noice enable")
                        end, 10)
                    end,
                })
                return ":IncRename " .. cword
            end,
            expr = true,
            mode = { "x" },
        },
    },

    config = function()
        require("inc_rename").setup({
            -- input_buffer_type = "dressing",
            preview_empty_name = true,
            post_hook = function(result)
                if not result or not result.changes then
                    print(string.format("could not perform rename"))
                    return
                end

                local notification, entries = "", {}
                local num_files, num_updates = 0, 0
                for uri, edits in pairs(result.changes) do
                    num_files = num_files + 1
                    local bufnr = vim.uri_to_bufnr(uri)

                    for _, edit in ipairs(edits) do
                        local start_line = edit.range.start.line + 1
                        local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

                        num_updates = num_updates + 1
                        table.insert(entries, {
                            bufnr = bufnr,
                            lnum = start_line,
                            col = edit.range.start.character + 1,
                            text = line,
                        })
                    end

                    local short_uri = string.sub(vim.uri_to_fname(uri), #vim.fn.getcwd() + 2)
                    notification = notification .. string.format("made %d change(s) in %s\n", #edits, short_uri)
                end

                if num_files > 1 then
                    print(notification)
                    vim.fn.setqflist(entries, "r")
                    vim.cmd("Trouble qflist focus=false")
                end
            end,
            -- cmd_name = "Rename",
        })
    end,
}
