return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    enabled = false,
    keys = {
        {
            "<leader>uf",
            function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zm", true, false, true), "t", true)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zr", true, false, true), "t", true)
            end,
        },
        {
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
        },
        {
            "zm",
            function()
                require("ufo").closeAllFolds()
            end,
        },
        {
            "zr",
            function()
                require("ufo").openFoldsExceptKinds()
            end,
        },
        {
            "zM",
            function()
                require("ufo").closeFoldsWith()
            end,
        },
        {
            "zp",
            function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    -- choose one of coc.nvim and nvim lsp
                    vim.fn.CocActionAsync("definitionHover") -- coc.nvim
                    vim.lsp.buf.hover()
                end
            end,
        },
    },
    event = "BufRead",
    config = function()
        vim.o.fillchars = [[eob: ,fold: ,foldsep: ,foldclose:>]]
        vim.o.foldcolumn = "1" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (" 󰁂 %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            return newVirtText
        end

        require("ufo").setup({
            -- close_fold_kinds = { "comment" },
            close_fold_kinds = {},
            fold_virt_text_handler = handler,
            preview = {
                win_config = {
                    border = "none",
                    winblend = 12,
                    winhighlight = "Normal:Ufo,CursorLine:FloatCursorLine",
                    maxheight = 20,
                    maxwidth = 40,
                },
            },
        })
    end,
}
