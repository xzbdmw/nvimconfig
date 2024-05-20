return {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    opts = {
        disable = function(_, bufnr) -- Disable in files with more than 5K
            return vim.api.nvim_buf_line_count(bufnr) > 5000
            -- return vim.bo.filetype == "rust"
        end,
        highlight = { enable = true, disable = { "markdown" } },
        indent = { enable = false },
        auto_install = true,
        ensure_installed = {
            "rust",
            "vue",
            "java",
            "bash",
            "c",
            "diff",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                -- scope_incremental = "<S-CR>",
                node_decremental = "<C-d>",
            },
        },
        textobjects = {
            move = {
                enable = false,
                goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
            },
        },
    },
}
-- return {}
