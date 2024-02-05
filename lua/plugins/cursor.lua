return {
    "mg979/vim-visual-multi",
    init = function()
        vim.g.VM_maps = {
            ["Find Under"] = "",
        }
    end,
    config = function()
        vim.keymap.set("n", "<C-8>", "<Plug>(VM-Find-Under)")
        vim.keymap.set("n", "<M-k>", "<Plug>(VM-Find-Next)")
    end,
}
