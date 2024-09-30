return {
    "akinsho/git-conflict.nvim",
    version = "*",
    keys = {
        {
            "<leader>uC",
            function()
                require("git-conflict").start_conflict_detect(api.nvim_get_current_buf())
            end,
            desc = "GitConflictListQf",
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
