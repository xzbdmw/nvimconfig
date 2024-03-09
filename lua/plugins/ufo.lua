return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    lazy = false,
    init = function()
        -- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
        -- auto-closing them after leaving insert mode, however ufo does not seem to
        -- have equivalents for zr and zm because there is no saved fold level.
        -- Consequently, the vim-internal fold levels need to be disabled by setting
        -- them to 99
        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
    end,
    keys = {

        {
            "zm",
            function()
                require("ufo").closeAllFolds()
            end,
            desc = " 󱃄 Close All Folds",
        },
        {
            "zk",
            function()
                require("ufo").goPreviousClosedFold()
            end,
            desc = " 󱃄 Goto Prev Fold",
        },
        {
            "zj",
            function()
                require("ufo").goNextClosedFold()
            end,
            desc = " 󱃄 Goto Next Fold",
        },
        -- {
        --     "<leader>o",
        --     function()
        --         require("ufo").openFoldsExceptKinds({ "comment", "imports" })
        --     end,
        --     desc = " 󱃄 Open All Regular Folds",
        -- },
        {
            "<leader>o",
            function()
                require("ufo").openFoldsExceptKinds({})
            end,
            desc = " 󱃄 Open All Folds",
        },
        {
            "z1",
            function()
                require("ufo").closeFoldsWith(1)
            end,
            desc = " 󱃄 Close L1 Folds",
        },
        {
            "z2",
            function()
                require("ufo").closeFoldsWith(2)
            end,
            desc = " 󱃄 Close L2 Folds",
        },
        {
            "z3",
            function()
                require("ufo").closeFoldsWith(3)
            end,
            desc = " 󱃄 Close L3 Folds",
        },
        {
            "z4",
            function()
                require("ufo").closeFoldsWith(4)
            end,
            desc = " 󱃄 Close L4 Folds",
        },
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
        vim.o.foldcolumn = "0" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
        vim.keymap.set("n", "zR", require("ufo").openAllFolds)
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
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
            close_fold_kinds = { "comment" },
            -- close_fold_kinds = {},
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
