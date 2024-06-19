return {
    "akinsho/git-conflict.nvim",
    version = "*",
    lazy = false,
    keys = { {
        "<leader>cq",
        "<cmd>GitConflictListQf<CR>",
        desc = "GitConflictListQf",
    } },
    config = function()
        require("git-conflict").setup({
            default_mappings = {
                ours = "<leader>co",
                theirs = "<leader>ct",
                none = "<leader>cn",
                both = "<leader>cb",
                next = "n",
                prev = "N",
            },
            disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
            list_opener = "Trouble before_qflist toggle focus=false", -- command or function to open the conflicts list
            highlights = { -- They must have background color, otherwise the default color will be used
                incoming = "DiffAdd",
                current = "Normal",
            },
        })
    end,
}
