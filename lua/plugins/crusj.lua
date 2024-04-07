return {
    "crusj/bookmarks.nvim",
    enabled = false,
    config = function()
        require("bookmarks").setup({
            mappings_enabled = true, -- If the value is false, only valid for global keymaps: toggle、add、delete_on_virt、show_desc
            storage_dir = "", -- Default path: vim.fn.stdpath("data").."/bookmarks,  if not the default directory, should be absolute path",
            keymap = {
                toggle = "mo", -- Toggle bookmarks(global keymap)
                close = "q", -- close bookmarks (buf keymap)
                add = "mm", -- Add bookmarks(global keymap)
                add_global = "\\g", -- Add global bookmarks(global keymap), global bookmarks will appear in all projects. Identified with the symbol '󰯾'
                jump = "<CR>", -- Jump from bookmarks(buf keymap)
                delete = "dd", -- Delete bookmarks(buf keymap)
                order = "<space><space>", -- Order bookmarks by frequency or updated_time(buf keymap)
                delete_on_virt = "\\dd", -- Delete bookmark at virt text line(global keymap)
                show_desc = "\\sd", -- show bookmark desc(global keymap)
                focus_tags = "<c-j>", -- focus tags window
                focus_bookmarks = "<c-k>", -- focus bookmarks window
                toogle_focus = "<S-Tab>", -- toggle window focus (tags-window <-> bookmarks-window)
            },
            width = 0.8, -- Bookmarks window width:  (0, 1]
            height = 0.7, -- Bookmarks window height: (0, 1]
            preview_ratio = 0.45, -- Bookmarks preview window ratio (0, 1]
            tags_ratio = 0.1, -- Bookmarks tags window ratio
            fix_enable = true, -- If true, when saving the current file, if the bookmark line number of the current file changes, try to fix it.

            virt_text = "", -- Show virt text at the end of bookmarked lines, if it is empty, use the description of bookmarks instead.
            sign_icon = "󰃃", -- if it is not empty, show icon in signColumn.
            virt_pattern = { "*.go", "*.lua", "*.sh", "*.php", "*.rs" }, -- Show virt text only on matched pattern
            virt_ignore_pattern = {}, -- Ignore showing virt text on matched pattern, this works after virt_pattern
            border_style = "single", -- border style: "single", "double", "rounded"
            hl = {
                border = "TelescopeBorder", -- border highlight
                cursorline = "guibg=Gray guifg=White", -- cursorline highlight
            },
        })
    end,
}
