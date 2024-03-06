return {
    "nvimdev/epo.nvim",
    enabled = false,
    config = function()
        require("epo").setup({
            -- fuzzy match
            fuzzy = true,
            -- increase this value can aviod trigger complete when delete character.
            debounce = 0,
            -- when completion confrim auto show a signature help floating window.
            signature = true,
            -- vscode style json snippet path
            snippet_path = nil,
            -- border for lsp signature popup, :h nvim_open_win
            signature_border = "none",
            -- lsp kind formatting, k is kind string "Field", "Struct", "Keyword" etc.
            kind_format = function(k)
                return k:lower():sub(1, 1)
            end,
        })

        -- nvim-autopair compatibility
        vim.keymap.set("i", "<cr>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-y>"
            end
            return require("nvim-autopairs").autopairs_cr()
        end, { expr = true, noremap = true })
        local capabilities =
            vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("epo").register_cap())
    end,
}
