return {
    "yioneko/nvim-type-fmt",
    enabled = false,
    ft = "rust",
    config = function()
        require("type-fmt").setup({
            -- In case if you only want to enable this for limited buffers
            -- We already filter it by checking capabilities of attached lsp client
            buf_filter = function(bufnr)
                return vim.bo.filetype == "rust"
            end,
        })
    end,
}
