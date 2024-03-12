return {
    lazy = false,
    keys = {
        { "<leader>un", "<cmd>Ut<CR>" },
    },
    "mbbill/undotree",
    config = function()
        vim.g.undotree_WindowLayout = 3
    end,
}
