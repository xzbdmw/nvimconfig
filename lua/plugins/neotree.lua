function Escape_neotree_to_last_buffer()
    vim.cmd("wincmd p")
end
return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
        close_if_last_window = true,
        enable_git_status = false,
        follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        group_empty_dirs = true,
        window = {
            width = 25,
            mappings = {
                ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
                ["<esc>"] = {
                    Escape_neotree_to_last_buffer,
                },
            },
        },
        source_selector = {
            show_scrolled_off_parent_node = true,
        },
    },
    keys = {
        -- change a keymap
        {
            "<C-f>",
            function()
                vim.cmd("Neotree filesystem reveal toggle=false left")
            end,
            desc = "Find Files",
        },
    },
}
