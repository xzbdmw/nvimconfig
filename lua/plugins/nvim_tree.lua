local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")
    api.events.subscribe(api.events.Event.FileCreated, function(file)
        vim.cmd("edit " .. file.fname)
    end)
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
    keymap({ "n", "i" }, "<D-n>", function()
        api.fs.create()
    end, { desc = "create new file" })
end
return {
    -- "nvim-tree/nvim-tree.lua",
    version = false,
    dir = "/Users/xzb/.local/share/nvim/lazy/nvim-tree",
    -- event = "VeryLazy",
    lazy = false,
    -- enabled = false,
    keys = {
        { "<D-1>", "<cmd>NvimTreeToggle<CR>", mode = { "n", "c" } },
        { "<D-1>", "<cmd>NvimTreeToggle<CR>", mode = { "i", "t" } },
        { "<C-9>", "<cmd>NvimTreeToggle<CR>", mode = { "n", "c" } },
        { "<C-9>", "<cmd>NvimTreeToggle<CR>", mode = { "i", "t" } },
    },
    config = function()
        local width = vim.api.nvim_get_option("columns")
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
                file_popup = {
                    open_win_config = {
                        width = 60,
                        col = 10,
                        row = 4,
                        relative = "cursor",
                        border = "rounded",
                        -- style = "minimal",
                    },
                },
                -- change_dir = {
                --     global = true,
                -- },
            },
            disable_netrw = true,
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                -- cause cwd to change
                -- update_cwd = true,
                exclude = function(arg)
                    local buf = arg.buf
                    if api.nvim_buf_is_valid(buf) then
                        local name = vim.api.nvim_buf_get_name(buf)
                        return string.find(name, "COMMIT_EDITMSG", nil, true) ~= nil
                    else
                        return true
                    end
                end,
            },
            filters = {
                git_ignored = true,
                dotfiles = false,
                git_clean = false,
                no_buffer = false,
                no_bookmark = false,
                custom = { "go.sum", ".vscode", ".idea", ".DS_Store", "root/*" },
                exclude = {},
            },
            on_attach = my_on_attach,
            view = {
                signcolumn = "yes",
                width = math.floor(0.2 * width),
                preserve_window_proportions = true,
            },
            renderer = {
                highlight_bookmarks = "all",
                highlight_opened_files = "name",
                special_files = {},
                group_empty = true,
                icons = {
                    bookmarks_placement = "after",
                    web_devicons = {
                        file = { color = true, enable = true },
                        folder = {
                            color = false,
                        },
                    },
                    show = {
                        git = false,
                        modified = true,
                        bookmarks = true,
                    },
                    glyphs = {
                        default = "",
                        bookmark = "B",

                        modified = "●",
                        folder = {
                            arrow_closed = "󱦰",
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
