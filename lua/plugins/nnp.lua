local open = 0
return {
    keys = {
        {
            "<leader>zz",
            function()
                if open == 0 then
                    -- vim.cmd("FocusDisable")
                    vim.o.number = false
                    open = 1
                else
                    -- vim.cmd("FocusEnable")
                    vim.o.number = true
                    open = 0
                end
                vim.cmd("NoNeckPain")
            end,
        },
    },
    "shortcuts/no-neck-pain.nvim",
    lazy = false,
    enabled = false,
    config = function()
        require("no-neck-pain").setup({
            width = 110,
            mappings = {
                enabled = true,
                -- widthUp = "<Leader>n=",
                -- Sets a global mapping to Neovim, which allows you to decrease the width (-5) of the main window.
                -- When `false`, the mapping is not created.
                --- @type string | { mapping: string, value: number }
                -- widthDown = "<Leader>n-",
            },
        })
    end,
}
