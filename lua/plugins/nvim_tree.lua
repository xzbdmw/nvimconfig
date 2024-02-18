local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)
    local keymap = vim.keymap.set
    keymap("n", "<esc>", "<C-w>l", opts("return to origin buffer"))
    keymap("n", "<Tab>", "<C-w>l", opts("return to origin buffer"))
    keymap("n", "<up>", "k", opts("return to origin buffer"))
    keymap("n", "<down>", "j", opts("return to origin buffer"))
    keymap("n", "P", function()
        api.node.open.preview()
    end, opts("preview file"))
    keymap("n", "<C-f>", "<cmd>NvimTreeFocus<CR>")
end
return {
    "nvim-tree/nvim-tree.lua",
    version = false,
    -- dependencies = {
    --     "nvim-tree/nvim-web-devicons",
    -- },
    keys = {
        { "<D-1>", "<cmd>NvimTreeToggle<CR>", mode = { "n", "c" } },
        { "<D-1>", "<cmd>NvimTreeToggle<CR>", mode = { "i", "t" } },
    },
    lazy = false,
    config = function()
        require("nvim-tree").setup({
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
            filters = {
                git_ignored = true,
                dotfiles = false,
                git_clean = false,
                no_buffer = false,
                no_bookmark = false,
                custom = { ".gitignore", ".git", ".luarc.json" },
                exclude = {},
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
                        file = { color = true, enable = true },
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
