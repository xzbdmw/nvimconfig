return {
    "dnlhc/glance.nvim",
    config = function()
        local glance = require("glance")
        local actions = glance.actions
        --[[ 
        local height = 18
        local namespace = vim.api.nvim_create_namespace("GlancePlaceHolder")
        local place_holder = {}
        for _ = 1, height, 1 do
            place_holder[#place_holder + 1] = { { "", "Error" } }
        end
        local id = 0

        local function after_close()
            vim.api.nvim_buf_del_extmark(0, namespace, id)
        end

        local function before_open(results, open)
            local lnum = vim.api.nvim_win_get_cursor(0)[1]
            id = vim.api.nvim_buf_set_extmark(0, namespace, lnum - 1, 0, { virt_lines = place_holder })
            open(results)
        end ]]
        require("glance").setup({
            height = 18, -- Height of the window
            zindex = 10,

            -- By default glance will open preview "embedded" within your active window
            -- when `detached` is enabled, glance will render above all existing windows
            -- and won't be restiricted by the width of your active window
            detached = true,

            -- Or use a function to enable `detached` only when the active window is too small
            -- (default behavior)
            -- detached = function(winid)
            --     return vim.api.nvim_win_get_width(winid) < 100
            -- end,

            preview_win_opts = { -- Configure preview window options
                cursorline = true,
                number = true,
                wrap = false,
            },
            border = {
                enable = false, -- Show window borders. Only horizontal borders allowed
                top_char = "―",
                bottom_char = "―",
            },
            list = {
                position = "left", -- Position of the list window 'left'|'right'
                width = 0.25, -- 33% width relative to the active window, min 0.1, max 0.5
            },
            theme = { -- This feature might not work properly in nvim-0.7.2
                enable = true, -- Will generate colors for the plugin based on your current colorscheme
                mode = "darken", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
            },
            mappings = {
                list = {
                    ["j"] = actions.next, -- Bring the cursor to the next item in the list
                    ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
                    ["<Down>"] = actions.next,
                    ["<Up>"] = actions.previous,
                    ["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
                    ["<C-u>"] = actions.preview_scroll_win(5),
                    ["<C-d>"] = actions.preview_scroll_win(-5),
                    ["v"] = actions.jump_vsplit,
                    ["s"] = actions.jump_split,
                    ["t"] = actions.jump_tab,
                    ["<CR>"] = actions.jump,
                    ["o"] = actions.jump,
                    ["l"] = actions.open_fold,
                    ["h"] = actions.close_fold,
                    ["<Tab>"] = actions.enter_win("preview"), -- Focus preview window
                    ["q"] = actions.close,
                    ["Q"] = actions.close,
                    ["<Esc>"] = actions.close,
                    ["<C-q>"] = actions.quickfix,
                    -- ['<Esc>'] = false -- disable a mapping
                },
                preview = {
                    ["q"] = actions.close,
                    ["<C-n>"] = actions.next_location,
                    ["<C-p>"] = actions.previous_location,
                    ["<Tab>"] = actions.enter_win("list"), -- Focus list window
                },
            },
            hooks = {
                before_open = function(results, open, jump, _)
                    if #results == 2 then
                        jump(results[2]) -- argument is optional
                    elseif #results == 1 then
                        print("no reference")
                    else
                        open(results) -- argument is optional
                    end
                end,
            },
            folds = {
                fold_closed = ">",
                fold_open = "󱞩",
                folded = true, -- Automatically fold list on startup
            },
            indent_lines = {
                enable = true,
                icon = "|",
            },
            winbar = {
                enable = true, -- Available strating from nvim-0.8+
            },
        })
    end,
}
