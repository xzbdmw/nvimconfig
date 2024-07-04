return {
    "echasnovski/mini-git",
    version = false,
    main = "mini.git",
    event = "VeryLazy",
    config = function()
        require("mini.git").setup( -- No need to copy this inside `setup()`. Will be used automatically.
            {
                -- General CLI execution
                job = {
                    -- Path to Git executable
                    git_executable = "git",

                    -- Timeout (in ms) for each job before force quit
                    timeout = 30000,
                },

                -- Options for `:Git` command
                command = {
                    -- Default split direction
                    split = "horizontal",
                },
            }
        )
    end,
    vim.keymap.set("n", "<leader>cc", function()
        vim.cmd("Git commit")
    end),
}
