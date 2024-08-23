return {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    -- dir = "~/Project/lua/glance.nvim/",
    config = function()
        local glance = require("glance")
        local actions = glance.actions

        local function clear_and_restore()
            for bufnr, _ in pairs(_G.glance_buffer) do
                api.nvim_buf_del_keymap(bufnr, "n", "<CR>")
                api.nvim_buf_del_keymap(bufnr, "n", "<esc>")
                api.nvim_buf_del_keymap(bufnr, "n", "q")
            end
            _G.glance_buffer = {}
            vim.keymap.set("v", "<CR>", function()
                vim.cmd([[:'<,'>lua require("nvim-treesitter.incremental_selection").node_incremental()]])
            end)
            vim.keymap.set("n", "<CR>", function()
                require("nvim-treesitter.incremental_selection").init_selection()
            end)
            _G.reference = false
        end

        local function quickfix()
            clear_and_restore()
            actions.quickfix()
        end

        local function jump()
            clear_and_restore()
            actions.jump()
        end

        function Close_with_q()
            clear_and_restore()
            vim.defer_fn(actions.close, 1)
        end

        function Open()
            clear_and_restore()
            actions.close(api.nvim_get_current_buf())
        end

        require("glance").setup({
            use_trouble_qf = true,
            height = 18, -- Height of the window
            zindex = 10,
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
                position = "right", -- Position of the list window 'left'|'right'
                -- width = 0.19, -- 33% width relative to the active window, min 0.1, max 0.5
                width = 0.25, -- 33% width relative to the active window, min 0.1, max 0.5
            },
            theme = { -- This feature might not work properly in nvim-0.7.2
                enable = false, -- Will generate colors for the plugin based on your current colorscheme
                mode = "darken", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
            },
            mappings = {
                list = {
                    ["j"] = actions.next, -- Bring the cursor to the next item in the list
                    ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
                    ["<Down>"] = actions.next,
                    ["<Up>"] = actions.previous,
                    ["<C-u>"] = actions.preview_scroll_win(5),
                    ["<C-d>"] = actions.preview_scroll_win(-5),
                    ["v"] = actions.jump_vsplit,
                    ["s"] = actions.jump_split,
                    ["t"] = actions.jump_tab,
                    ["<CR>"] = jump,
                    ["o"] = actions.jump,
                    ["l"] = actions.open_fold,
                    ["n"] = actions.next_location,
                    ["h"] = actions.close_fold,
                    ["<Tab>"] = actions.enter_win("preview"), -- Focus preview window
                    ["q"] = Close_with_q,
                    ["Q"] = Close_with_q,
                    ["<Esc>"] = Close_with_q,
                    ["<C-q>"] = quickfix,
                    -- ['<Esc>'] = false -- disable a mapping
                },
                preview = {
                    ["n"] = actions.next_location,
                    ["<C-q>"] = quickfix,
                    ["N"] = actions.previous_location,
                    ["<C-f>"] = actions.enter_win("list"),
                    ["<Tab>"] = actions.enter_win("list"), -- Focus list window
                },
            },
            hooks = {
                before_open = function(result, open, jumpfn, method)
                    if method == "definitions" and #result >= 1 then
                        vim.cmd("normal! m'")
                        jumpfn(result[1])
                    elseif method == "implementations" then
                        vim.cmd("normal! m'")
                        open(result)
                        FeedKeys("<Tab>", "t")
                    elseif method == "references" then
                        if #result == 1 then
                            vim.cmd("normal! m'")
                            jumpfn(result[1])
                        elseif #result == 2 then
                            print("2")
                            vim.cmd("normal! m'")
                            local lnum = api.nvim_win_get_cursor(0)[1]
                            local locations = vim.tbl_filter(function(v)
                                return not (v.range.start.line + 1 == lnum)
                            end, vim.F.if_nil(result, {}))
                            vim.cmd("normal! m'")
                            if locations ~= nil and #locations ~= 0 then
                                jumpfn(locations[1])
                            else
                                print("can't find reference")
                            end
                        else
                            vim.cmd("normal! m'")
                            open(result)
                            FeedKeys("<Tab>", "t")
                        end
                        return
                    end
                end,
                before_close = function()
                    _G.glance_list_method = nil
                    _G.glance_listnr = nil
                end,
            },
            folds = {
                fold_closed = ">",
                fold_open = "󱞩",
                folded = false, -- Automatically fold list on startup
            },
            indent_lines = {
                enable = true,
                icon = " ",
            },
            winbar = {
                enable = false, -- Available strating from nvim-0.8+
            },
        })
    end,
}
