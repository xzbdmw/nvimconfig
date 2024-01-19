local function lsp_references_with_jump()
    -- 在当前位置设置一个标记
    vim.cmd("normal! m'")

    -- 调用 Telescope lsp_references
    vim.cmd("Telescope lsp_references")
end
return {
    {
        "neovim/nvim-lspconfig",
        init = function()
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            -- disable a keymap
            keys[#keys + 1] = { "K", false }
            -- change a keymap
            keys[#keys + 1] = { "gr", lsp_references_with_jump }
        end,
    }
    -- {
    --     "hrsh7th/cmp-cmdline",
    -- },
}
