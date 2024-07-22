return {
    "otavioschwanck/arrow.nvim",
    -- commit = "f3d8470580ecbd5778a68091eca8d5da304f2e2a",
    -- dir = "/Users/xzb/Project/lua/arrow.nvim/",
    -- dir = "/Users/xzb/Project/lua/fork/arrow.nvim/",
    -- event = "VeryLazy",
    opts = {
        per_buffer_config = {
            sort_automatically = true,
            treesitter_context = {
                line_shift_down = 1,
            },
            satellite = {
                enable = true,
                overlap = true,
                priority = 1000,
            },
            lines = 7,
            zindex = 20,
        },
        custom_actions = {
            open = function(target_file_name, current_file_name)
                local path = vim.fn.expand("%:~:.:h") .. "/" .. vim.fn.expand("%:t")
                if path == target_file_name then
                    return
                end
                vim.api.nvim_create_autocmd("BufEnter", {
                    once = true,
                    callback = function()
                        vim.api.nvim_create_autocmd("CursorMoved", {
                            once = true,
                            callback = function()
                                if vim.fn.line(".") > vim.fn.winheight(0) / 2 then
                                    vim.cmd("normal zz")
                                end
                            end,
                        })
                    end,
                })
                vim.cmd("e " .. target_file_name)
            end,
        },
        buffer_leader_key = "'",
        show_icons = true,
        leader_key = ";", -- Recommended to be a single key
        -- index_keys = "123jklafghAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
        hide_handbook = true,
        window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
            width = "auto",
            height = "auto",
            row = 10,
            col = 55,
            border = "none",
        },
    },
    config = function(_, opts)
        require("arrow").setup(opts)
        vim.keymap.set("n", "mn", "<cmd>Arrow next_buffer_bookmark<CR>")
        vim.keymap.set("n", "mp", "<cmd>Arrow prev_buffer_bookmark<CR>")
    end,
}
