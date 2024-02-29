return {
    "coffebar/neovim-project",
    -- enabled = false,
    opts = {
        last_session_on_startup = true,
        projects = { -- define project roots
            "~/Project/rust/*",
            "~/Project/vim/*",
            "~/Project/Go/*",
            "~/Project/java/*",
            "~/Project/Python/*",
            "/Users/xzb/Documents/xzbdmw的副本/*",
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
        { "nvim-telescope/telescope.nvim" },
    },
    lazy = false,
    priority = 100,
}
