local statusline = require("arrow.statusline")
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
    keymap("n", "s", function()
        vim.g.flash_winbar = vim.wo.winbar
        vim.cmd([[normal! m']])
        require("flash").jump()
    end, opts("flash"))
    keymap("n", "J", "6j", opts("return to origin buffer"))
    keymap("n", "K", "6k", opts("return to origin buffer"))
    keymap("n", "Y", api.fs.copy.absolute_path, opts("return to origin buffer"))
    keymap("n", "p", api.node.navigate.parent, opts("return to origin buffer"))
    keymap("n", "l", api.node.navigate.sibling.last, opts("return to origin buffer"))
    keymap("n", "h", api.node.navigate.sibling.first, opts("return to origin buffer"))
    keymap("n", "<c-]>", "<c-w>l", opts("go to right"))
    keymap("n", "<down>", "j", opts("return to origin buffer"))
    keymap("n", "P", function()
        api.node.open.preview()
    end, opts("preview file"))
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
        api.tree.toggle_no_arrow_filter()
        if not is_arrow_filter_activated then
            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = { "NvimTreeReloaded" },
                callback = function()
                    require("nvim-tree.api").tree.expand_all()
                    require("nvim-tree.actions").tree.find_file.fn()
                end,
            })
        end
    end
    keymap("n", "]]", function()
        require("nvim-tree.api").node.navigate.git.next()
        require("nvim-tree.api").node.open.edit()
    end)
    keymap("n", "[[", function()
        require("nvim-tree.api").node.navigate.git.prev()
        require("nvim-tree.api").node.open.edit()
    end)
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
        api.tree.toggle_no_buffer_filter()
        if not is_buffer_filter_activated then
            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = { "NvimTreeReloaded" },
                callback = function()
                    require("nvim-tree.api").tree.expand_all()
                    require("nvim-tree.actions").tree.find_file.fn()
                end,
            })
        end
    end
    keymap("n", "B", toggle_buffer_filter, opts("toggle arrow filter"))
    keymap("n", "<leader>B", toggle_buffer_filter)
    local function toggle_status_filter()
        if vim.g.Diff_file_count == 0 then
            vim.notify("", vim.log.levels.INFO, { title = "No Changed File" })
            return
        end
        local is_arrow_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_arrow
        local is_buffer_filter_activated = require("nvim-tree.explorer.filters").config.filter_no_buffer
        local is_git_filter_activated = require("nvim-tree.explorer.filters").config.filter_git_clean
        if is_arrow_filter_activated then
            api.tree.toggle_no_arrow_filter()
        end
        if is_buffer_filter_activated then
            api.tree.toggle_no_buffer_filter()
        end
        api.tree.toggle_git_clean_filter()
        if not is_git_filter_activated then
            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = { "NvimTreeReloaded" },
                callback = function()
                    require("nvim-tree.api").tree.expand_all()
                    require("nvim-tree.actions").tree.find_file.fn()
                end,
            })
        end
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
        {
            "<D-1>",
            function()
                require("nvim-tree.api").tree.toggle({ focus = false })
            end,
            mode = { "i", "n", "c" },
        },
        {
            "<c-9>",
            function()
                require("nvim-tree.api").tree.toggle({ focus = false })
            end,
            mode = { "i", "n", "c" },
        },
    },
    config = function()
        local function folders_or_files_first(a, b)
            if not a.nodes and b.nodes then
                return false
            elseif a.nodes and not b.nodes then
                return true
            end
        end
        local width = vim.api.nvim_get_option("columns")
        require("nvim-tree").setup({
            sort = {
                sorter = function(nodes)
                    table.sort(nodes, function(a, b)
                        if not (a and b) then
                            return true
                        end
                        local early_return = folders_or_files_first(a, b)
                        if early_return ~= nil then
                            return early_return
                        end
                        if a.nodes and b.nodes then
                            if a.size and b.size then
                                if a.size == b.size then
                                    return a.name < b.name
                                end
                                return a.size > b.size
                            end
                            if a.fs_state.size == b.fs_state.size then
                                return a.name < b.name
                            end
                            return a.fs_state.size > b.fs_state.size
                        end
                        local arrow_filenames = vim.g.arrow_filenames
                        if arrow_filenames then
                            local b_arrow_index = -1
                            local a_arrow_index = -1
                            for i, filename in ipairs(arrow_filenames) do
                                if string.sub(a.absolute_path, -#filename) == filename then
                                    a_arrow_index = statusline.text_for_statusline(_, i)
                                end
                                if string.sub(b.absolute_path, -#filename) == filename then
                                    b_arrow_index = statusline.text_for_statusline(_, i)
                                end
                            end
                            if a_arrow_index ~= -1 and b_arrow_index ~= -1 then
                                if a_arrow_index == b_arrow_index then
                                    return a.name < b.name
                                end
                                return a_arrow_index < b_arrow_index
                            elseif a_arrow_index ~= -1 and b_arrow_index == -1 then
                                return true
                            elseif b_arrow_index ~= -1 and a_arrow_index == -1 then
                                return false
                            end
                        end
                        if a.size and b.size then
                            if a.size == b.size then
                                return a.name < b.name
                            end
                            return a.size > b.size
                        end
                        if a.fs_state.size == b.fs_state.size then
                            return a.name < b.name
                        end
                        return a.fs_state.size > b.fs_state.size
                    end)
                end,
            },
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
                    max_folder_discovery = 1000,
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
                indent_markers = {
                    enable = true,
                    inline_arrows = false,
                    icons = {
                        corner = "│",
                        edge = "│",
                        item = "│",
                        bottom = "",
                        none = "│",
                    },
                },
                icons = {
                    git_placement = "after",
                    bookmarks_placement = "after",
                    web_devicons = {
                        file = { color = true, enable = false },
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
                        default = "",
                        bookmark = "B",

                        modified = "●",
                        folder = {
                            arrow_closed = "󱦰",
                            arrow_open = "󱞩",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "~",
                            staged = "~",
                            unmerged = "",
                            renamed = "➜",
                            untracked = " ",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
            },
        })
        vim.keymap.set("n", "<leader>uS", function()
            vim.g.show_nvim_tree_size = not vim.g.show_nvim_tree_size
            vim.cmd("NvimTreeRefresh")
        end)
    end,
}
