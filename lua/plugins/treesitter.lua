return {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    opts = {
        highlight = { enable = true, disable = { "gitcommit" } },
        indent = { enable = false },
        auto_install = true,
        -- stylua: ignore
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
            swap = {
                enable = false,
                swap_next = {
                    ["<leader>an"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>ap"] = "@parameter.inner",
                },
            },
            select = {
                enable = true,
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                -- keymaps = {
                --     -- You can use the capture groups defined in textobjects.scm
                --     ["af"] = "@function.outer",
                --     ["if"] = "@function.inner",
                -- },
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "V", -- linewise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true or false
                include_surrounding_whitespace = false,
            },
            move = {
                enabled = true,
                goto_next_start = { ["]f"] = "@function.outer", ["]a"] = "@parameter.inner" },
                goto_next_end = { ["]e"] = "@function.outer" },
                goto_previous_start = { ["[f"] = "@function.outer", ["[a"] = "@parameter.outer" },
                goto_previous_end = { ["[e"] = "@function.outer" },
            },
        },
    },
}
-- return {}
