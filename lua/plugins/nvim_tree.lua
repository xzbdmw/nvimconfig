local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set("n", "<esc>", "<C-w>l", opts("return to origin buffer"))
end
return {
    "nvim-tree/nvim-tree.lua",
    version = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
        require("nvim-tree").setup({
            log = {
                enable = true,
                truncate = false,
                types = {
                    all = false,
                    config = false,
                    copy_paste = false,
                    dev = false,
                    diagnostics = false,
                    git = false,
                    profile = true,
                    watcher = false,
                },
            },
            git = {
                enable = false,
            },
            filesystem_watchers = {
                enable = false,
                debounce_delay = 0,
                ignore_dirs = {},
            },
            actions = {
                open_file = {
                    quit_on_open = false,
                },
                change_dir = {
                    global = true,
                },
            },
            disable_netrw = true,
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true,
                ignore_list = {},
            },
            on_attach = my_on_attach,
            view = {
                width = 25,
                preserve_window_proportions = true,
            },
            renderer = {
                special_files = {},
                group_empty = true,
                icons = {
                    web_devicons = {
                        file = { color = false, enable = false },
                        folder = {
                            color = false,
                        },
                    },
                    show = {
                        git = false,
                        modified = false,
                        bookmarks = false,
                    },
                    glyphs = {
                        default = "",
                        folder = {
                            arrow_closed = ">",
                            arrow_open = "󱞩",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                    },
                },
            },
        })
    end,
}
