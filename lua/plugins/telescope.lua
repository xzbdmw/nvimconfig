return {
    "nvim-telescope/telescope.nvim",
    keys = {
        -- disable the keymap to grep files
        -- { "<leader>/", false },
        -- { "<leader>fb", false },
        -- change a keymap
        { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "recent files" },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                path_display = require("custom.path_display").filenameFirstWithoutParent,
                file_sorter = require("custom.file_sorter").file_sorter,
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
                layout_config = { preview_cutoff = 0, prompt_position = "top", mirror = false },
                -- Default configuration for telescope goes here:
                -- config_key = value,
                mappings = {
                    i = {
                        -- ["<esc>"] = require("telescope.actions").close,
                        -- map actions.which_key to <C-h> (default: <C-/>)
                        -- actions.which_key shows the mappings for your picker,
                        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                    },
                },
            },
            pickers = {
                lsp_references = {
                    include_declaration = false,
                    push_cursor_on_edit = true,
                },
            },
            extensions = {
                frecency = {
                    show_scores = false,
                    show_unindexed = true,
                    ignore_patterns = { "*.git/*", "*/tmp/*" },
                    disable_devicons = false,
                    default_workspace = "CWD",
                    workspaces = {
                        ["conf"] = "/Users/xzb/.config",
                        ["data"] = "/Users/xzb/.local/share",
                        ["project"] = "/Users/xzb/Project",
                        ["wiki"] = "/Users/xzb/wiki",
                    },
                },
            },
        })
        require("telescope").load_extension("file_browser")
    end,
}
