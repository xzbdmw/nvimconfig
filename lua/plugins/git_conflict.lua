return {
    "akinsho/git-conflict.nvim",
    version = "*",
    lazy = false,
    keys = {
        {
            "<leader>cq",
            function()
                vim.fn.setqflist({}, "r")
                api.nvim_exec_autocmds("User", {
                    pattern = "SatelliteRedresh",
                })
                return "<cmd>GitConflictListQf<CR>"
            end,
            desc = "GitConflictListQf",
            expr = true,
        },
    },
    config = function()
        require("git-conflict").setup({
            default_mappings = {
                ours = "co",
                theirs = "ct",
                none = "cn",
                both = "cb",
                next = "n",
                prev = "N",
            },
            disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
            list_opener = "Trouble qflist toggle focus=false", -- command or function to open the conflicts list
            highlights = { -- They must have background color, otherwise the default color will be used
                incoming = "DiffAdd",
                current = "Normal",
            },
        })
    end,
}
