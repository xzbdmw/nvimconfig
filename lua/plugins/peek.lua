return {
    "toppair/peek.nvim",
    cmd = "MarkdownOpen",
    build = "deno task --quiet build:fast",
    config = function()
        -- default config:
        require("peek").setup({
            auto_load = true, -- whether to automatically load preview when
            -- entering another markdown buffer
            close_on_bdelete = true, -- close preview window on buffer delete

            syntax = true, -- enable syntax highlighting, affects performance

            theme = "light", -- 'dark' or 'light'

            update_on_change = true,

            app = "webview",

            -- explained below

            filetype = { "markdown" }, -- list of filetypes to recognize as markdown

            -- relevant if update_on_change is true
            throttle_at = 200000, -- start throttling when file exceeds this
            -- amount of bytes in size
            throttle_time = "auto", -- minimum amount of time in milliseconds
            -- that has to pass before starting new render
        })
        vim.api.nvim_create_user_command("MarkdownOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("MarkdownClose", require("peek").close, {})
    end,
}
