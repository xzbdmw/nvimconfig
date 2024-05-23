return {
    "echasnovski/mini.files",
    version = false,
    keys = {
        {
            "<leader>so",
            function()
                if vim.bo.filetype == "NvimTree" then
                    FeedKeys("<C-w><C-w>", "n")
                    vim.schedule(function()
                        MiniFiles.open(vim.api.nvim_buf_get_name(0))
                        -- MiniFiles.reveal_cwd()
                        MiniFiles.three_level()
                    end)
                else
                    MiniFiles.open(vim.api.nvim_buf_get_name(0))
                    -- MiniFiles.reveal_cwd()
                    MiniFiles.three_level()
                end
            end,
        },
    },
    config = function()
        local my_prefix = function(fs_entry)
            if fs_entry.fs_type == "directory" then
                -- NOTE: it is usually a good idea to use icon followed by space
                return " ", "MiniFilesDirectory"
            end
            return MiniFiles.default_prefix(fs_entry)
        end
        require("mini.files").setup({
            -- Customization of shown content
            content = {
                -- Predicate for which file system entries to show
                filter = nil,
                -- What prefix to show to the left of file system entry
                prefix = my_prefix,
                -- In which order to show file system entries
                sort = nil,
            },

            -- Module mappings created only inside explorer.
            -- Use `''` (empty string) to not create one.
            mappings = {
                close = "<ESC>",
                go_in = "=",
                go_in_plus = "<CR>",
                go_out = "-",
                go_out_plus = "<tab>",
                reset = "<BS>",
                reveal_cwd = "_",
                show_help = "g?",
                synchronize = "<D-s>",
                trim_left = "<",
                trim_right = ">",
            },

            -- General options
            options = {
                -- Whether to delete permanently or move into module-specific trash
                permanent_delete = true,
                -- Whether to use for editing directories
                use_as_default_explorer = true,
            },

            -- Customization of explorer windows
            windows = {
                -- Maximum number of windows to show side by side
                max_number = math.huge,
                -- Whether to show preview of file/directory under cursor
                preview = false,
                -- Width of focused window
                width_focus = 35,
                -- Width of non-focused window
                width_nofocus = 25,
                -- Width of preview window
                width_preview = 25,
            },
        })
    end,
}
