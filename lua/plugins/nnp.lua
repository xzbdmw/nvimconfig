local open = 0
return {
    keys = {
        {
            "<leader>gz",
            function()
                if open == 0 then
                    vim.cmd("FocusDisable")
                    vim.opt.number = false
                    open = 1
                else
                    vim.cmd("FocusEnable")
                    vim.opt.number = true
                    open = 0
                end
                vim.cmd("NoNeckPain")
            end,
        },
        {
            "<D-2>",
            function()
                if open == 0 then
                    vim.cmd("FocusDisable")
                    vim.opt.number = false
                    open = 1
                else
                    vim.cmd("FocusEnable")
                    vim.opt.number = true
                    open = 0
                end
                vim.cmd("NoNeckPain")
            end,
        },
    },
    "shortcuts/no-neck-pain.nvim",
    lazy = false,
    config = function()
        require("no-neck-pain").setup({
            width = 90,
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
