return {
    "otavioschwanck/arrow.nvim",
    priority = 10000,
    cond = function()
        return not vim.g.scrollback
    end,
    opts = {
        separate_by_branch = false,
        per_buffer_config = {
            sort_automatically = true,
            treesitter_context = {
                line_shift_down = 1,
            },
            satellite = {
                enable = false,
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
                                    vim.cmd("normal z")
                                end
                            end,
                        })
                    end,
                })
                vim.cmd("e " .. target_file_name)
            end,
        },
        buffer_leader_key = "\\",
        show_icons = true,
        leader_key = [[']], -- Recommended to be a single key
        -- index_keys = "123jklafghAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
        hide_handbook = true,
        window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
            width = "auto",
            height = "auto",
            row = 10,
            border = vim.g.neovide and "none" or "rounded",
        },
    },
    config = function(_, opts)
        require("arrow").setup(opts)
        vim.keymap.set("n", "mn", "<cmd>Arrow next_buffer_bookmark<CR>")
        vim.keymap.set("n", "mp", "<cmd>Arrow prev_buffer_bookmark<CR>")
    end,
}
