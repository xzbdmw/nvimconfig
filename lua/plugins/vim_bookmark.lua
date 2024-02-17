return {
    "MattesGroeger/vim-bookmarks",
    config = function()
        vim.g.bookmark_sign = ""
        vim.g.bookmark_save_per_working_dir = 1
        vim.g.bookmark_manage_per_buffer = 1
        vim.g.bookmark_highlight_lines = 1
        vim.g.bookmark_center = 1
        -- vim.cmd("nmap ml <Plug>BookmarkShowAll")
    end,
}
