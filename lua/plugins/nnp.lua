local open = 0
return {
    keys = {
        {
            "<leader>gz",
            function()
                vim.cmd("NoNeckPain")
                if open == 0 then
                    vim.opt.number = false
                    open = 1
                else
                    vim.opt.number = true
                    open = 0
                end
            end,
        },
        {
            "<D-2>",
            function()
                vim.cmd("NoNeckPain")
                if open == 0 then
                    vim.opt.number = false
                    open = 1
                else
                    vim.opt.number = true
                    open = 0
                end
            end,
        },
    },
    "shortcuts/no-neck-pain.nvim",
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
