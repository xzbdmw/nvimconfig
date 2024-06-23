return {
    "coffebar/neovim-project",
    commit = "db586796f67e206f0494b1d64492b1db8c109589",
    keys = {
        { "<D-9>", "<cmd>NeovimProjectLoadRecent<CR>" },
    },
    -- commit = "33a5d6ef5f9e035470c80cbec0bbfe23e776543c",
    opts = {
        filetype_autocmd_timeout = 0,
        last_session_on_startup = true,
        projects = { -- define project roots
            "/usr/local/share/nvim/runtime/lua/vim",
            "/Users/xzb/Project/lua/lua/fzf-lua",
            "/Users/xzb/Project/lua/fork/*",
            "/Users/xzb/Project/lua/origin/nvim-cmp",
            "/Users/xzb/Project/lua/oricmp/nvim-cmp",
            "/Users/xzb/Project/lua/color/nvim-cmp",
            "~/Project/rust/*",
            "~/raycast/*",
            "/Users/xzb/Project/Rust/myneovide/neovide/",
            "/Users/xzb/Project/Rust/my_repo_neovide/neovide/",
            "/Users/xzb/Documents/xzbdmw的副本",
            "~/Project/vim/*",
            "~/Project/lua/*",
            "~/Project/Typescript/*",
            "~/Project/Go/*",
            "~/Project/C/*",
            "~/Project/C++/*",
            "/Users/xzb/Downloads/nvim-macos/share/nvim/*",
            "/Users/xzb/Downloads/lih-admin_2",
            "/Users/xzb/.local/share/nvim/lazy/*",
            "/Users/xzb/.local/share/nvimlazy/lazy/LazyVim",
            -- "/Users/xzb/.local/share/nvim_rust/lazy/*",
            "~/Project/java/*",
            "~/Project/Typescript/*",
            "~/Project/Python/*",
            "~/.config/*",
        },
        session_manager_opts = {
            autosave_ignore_dirs = {
                vim.fn.expand("~"), -- don't create a session for $HOME/
                "/tmp",
            },
            autosave_ignore_filetypes = {
                -- All buffers of these file types will be closed before the session is saved
                "ccc-ui",
                "gitcommit",
                "gitrebase",
                "qf",
                "toggleterm",
            },
        },
    },
    init = function()
        -- enable saving the state of plugins in the session
        vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
        { "Shatur/neovim-session-manager" },
        { "nvim-tree/nvim-tree" },
        -- { dir = "~/Project/lua/telescope.nvim/" },
    },
    lazy = false,
    priority = 10000000,
}
