return {
    "bloznelis/before.nvim",
    lazy = false,
    enbaled = false,
    config = function()
        local before = require("before")
        before.setup()

        -- Jump to previous entry in the edit history
        vim.keymap.set("n", "<C-;>", before.jump_to_last_edit, {})

        -- Jump to next entry in the edit history
        vim.keymap.set("n", "<C-'>", before.jump_to_next_edit, {})

        -- Look for previous edits in quickfix list
        vim.keymap.set("n", "<leader><C-;>", function()
            before.show_edits_in_quickfix()
        end, {})

        vim.keymap.set("n", "<leader>se", "<cmd>Telescope before<CR>")

        require("telescope").load_extension("before")
    end,
}
