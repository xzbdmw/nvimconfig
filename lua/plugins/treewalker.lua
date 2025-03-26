return {
    "aaronik/treewalker.nvim",
    keys = {
        {
            "<left>",
            mode = { "n", "x" },
        },
        {
            "<leader>ak",
        },
        {
            "<leader>aj",
        },
    },
    -- The setup function is optional, defaults are meant to be sane
    -- and setup does not need to be called
    config = function()
        require("treewalker").setup({
            -- Whether to briefly highlight the node after jumping to it
            highlight = true,

            -- How long should above highlight last (in ms)
            highlight_duration = 250,

            -- The color of the above highlight. Must be a valid vim highlight group.
            -- (see :h highlight-group for options)
            highlight_group = "CursorLine",
        })
        -- movement
        vim.keymap.set({ "n", "v" }, "<left>", "<cmd>Treewalker Left<cr>", { remap = true, silent = true })

        -- swapping
        vim.keymap.set("n", "<leader>ak", "<cmd>Treewalker SwapUp<cr>", { remap = true, silent = true })
        vim.keymap.set("n", "<leader>aj", "<cmd>Treewalker SwapDown<cr>", { remap = true, silent = true })
    end,
}
