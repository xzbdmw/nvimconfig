return {
    "CRAG666/code_runner.nvim",
    config = function()
        require("code_runner").setup({
            -- choose default mode (valid term, tab, float, toggle)
            mode = "toggleterm",
            -- add hot reload
            hot_reload = true,
            -- Focus on runner window(only works on toggle, term and tab mode)
            focus = false,
            -- startinsert (see ':h inserting-ex')
            startinsert = false,
            insert_prefix = "",
            term = {
                --  Position to open the terminal, this option is ignored if mode ~= term
                position = "bot",
                -- window size, this option is ignored if mode == tab
                size = 12,
            },
            float = {
                close_key = "<ESC>",
                -- Window border (see ':h nvim_open_win')
                border = "none",

                -- Num from `0 - 1` for measurements
                height = 0.8,
                width = 0.8,
                x = 0.5,
                y = 0.5,

                -- Highlight group for floating window/border (see ':h winhl')
                border_hl = "FloatBorder",
                float_hl = "Normal",

                -- Transparency (see ':h winblend')
                blend = 0,
            },
            better_term = { -- Toggle mode replacement
                clean = false, -- Clean terminal before launch
                number = 10, -- Use nil for dynamic number and set init
                init = nil,
            },
            filetype_path = "",
            -- Execute before executing a file
            before_run_filetype = function()
                vim.cmd(":w")
            end,
            filetype = {
                java = {
                    "cd $dir &&",
                    "javac $fileName &&",
                    "java $fileNameWithoutExt",
                },
                python = "python3 -u",
                typescript = "deno run",
                rust = {
                    "cd $dir &&",
                    "rustc $fileName &&",
                    "$dir/$fileNameWithoutExt",
                },
                go = {
                    "go run $file",
                },
                c = function()
                    local c_base = {
                        "cd $dir &&",
                        "gcc $fileName -o",
                        "/tmp/$fileNameWithoutExt",
                    }
                    local c_exec = {
                        "&& /tmp/$fileNameWithoutExt &&",
                        "rm /tmp/$fileNameWithoutExt",
                    }
                    vim.ui.input({ prompt = "Add more args:" }, function(input)
                        c_base[4] = input
                        vim.print(vim.tbl_extend("force", c_base, c_exec))
                        require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
                    end)
                end,
            },
        })
        vim.keymap.set("n", "<leader>rf", ":RunCode<CR>", { noremap = true, silent = false })
        -- vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })
        -- vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", { noremap = true, silent = false })
        -- vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false })
        -- vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = false })
        -- vim.keymap.set("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false })
        -- vim.keymap.set("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false })
    end,
}
