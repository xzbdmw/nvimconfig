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
    keymap("n", "J", "3j", opts("return to origin buffer"))
    keymap("n", "K", "3k", opts("return to origin buffer"))
    keymap("n", "Y", api.fs.copy.absolute_path, opts("return to origin buffer"))
    keymap("n", "p", api.node.navigate.parent, opts("return to origin buffer"))
    keymap("n", "l", api.node.navigate.sibling.last, opts("return to origin buffer"))
    keymap("n", "h", api.node.navigate.sibling.first, opts("return to origin buffer"))
    keymap("n", "K", "3k", opts("return to origin buffer"))
    keymap("n", "<down>", "j", opts("return to origin buffer"))
    keymap("n", "P", function()
        api.node.open.preview()
    end, opts("preview file"))
    keymap("n", "<C-f>", "<cmd>NvimTreeFocus<CR>")
    local function toggle_arrow_filter()
        local is_arrow_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_arrow
        local is_buffer_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_buffer
        local is_git_filter_activated = require("nvim-tree.explorer.filters").config.filter_git_clean
        if is_buffer_filter_activated then
            api.tree.toggle_no_buffer_filter()
        end
        if is_git_filter_activated then
            api.tree.toggle_git_clean_filter()
        end
        if not is_arrow_filter_activated then
            api.tree.expand_all()
        end
        api.tree.toggle_no_arrow_filter()
        require("nvim-tree.actions").tree.find_file.fn()
    end
    keymap("n", "A", toggle_arrow_filter, opts("toggle arrow filter"))
    keymap("n", "<leader>A", toggle_arrow_filter)
    local function toggle_buffer_filter()
        local is_arrow_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_arrow
        local is_buffer_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_buffer
        local is_git_filter_activated = require("nvim-tree.explorer.filters").config.filter_git_clean
        if is_arrow_filter_activated then
            api.tree.toggle_no_arrow_filter()
        end
        if is_git_filter_activated then
            api.tree.toggle_git_clean_filter()
        end
        if not is_buffer_filter_activated then
            api.tree.expand_all()
        end
        api.tree.toggle_no_buffer_filter()
        require("nvim-tree.actions").tree.find_file.fn()
    end
    keymap("n", "B", toggle_buffer_filter, opts("toggle arrow filter"))
    keymap("n", "<leader>B", toggle_buffer_filter)
    local function toggle_status_filter()
        local is_arrow_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_arrow
        local is_buffer_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_buffer
        local is_git_filter_activated = require("nvim-tree.explorer.filters").config.filter_git_clean
        if is_arrow_filter_activated then
            api.tree.toggle_no_arrow_filter()
        end
        if is_buffer_filter_activated then
            api.tree.toggle_no_buffer_filter()
        end
        if not is_git_filter_activated then
            api.tree.expand_all()
        end
        api.tree.toggle_git_clean_filter()
        require("nvim-tree.actions").tree.find_file.fn()
    end
    keymap("n", "S", toggle_status_filter, opts("toggle arrow filter"))
    keymap("n", "<leader>S", toggle_status_filter)
    keymap("n", "S", toggle_status_filter)
    local function toggle_all_filter()
        local is_arrow_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_arrow
        local is_buffer_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_buffer
        local is_git_filter_activated = require("nvim-tree.explorer.filters").config.filter_git_clean
        if is_buffer_filter_activated then
            api.tree.toggle_no_buffer_filter()
        end
        if is_git_filter_activated then
            api.tree.toggle_git_clean_filter()
        end
        if is_arrow_filter_activated then
            api.tree.toggle_no_arrow_filter()
        end
        require("nvim-tree.actions").tree.find_file.fn()
    end
    keymap("n", "F", toggle_all_filter, opts("toggle arrow filter"))
    keymap("n", "<leader>F", toggle_all_filter)
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
                enable = true,
                show_on_dirs = false,
                show_on_open_dirs = false,
                disable_for_dirs = {},
                timeout = 1000,
                cygwin_support = false,
            },
            filesystem_watchers = {
                enable = false,
                debounce_delay = 50,
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
                expand_all = {
                    max_folder_discovery = 50,
                    exclude = {},
                },
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
                custom = { [[\.git]], "go.sum", [[\.vscode]], [[\.idea]], [[\.DS_Store]] },
                exclude = {},
            },
            on_attach = my_on_attach,
            view = {
                signcolumn = "yes",
                width = math.floor(0.2 * width),
                preserve_window_proportions = true,
            },
            renderer = {
                highlight_git = "none",
                highlight_bookmarks = "all",
                highlight_opened_files = "name",
                special_files = {},
                group_empty = true,
                icons = {
                    git_placement = "after",
                    bookmarks_placement = "after",
                    web_devicons = {
                        file = { color = true, enable = true },
                        folder = {
                            color = false,
                        },
                    },
                    show = {
                        git = true,
                        modified = false,
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
                        git = {
                            unstaged = "M",
                            staged = "M",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
            },
        })
    end,
}
