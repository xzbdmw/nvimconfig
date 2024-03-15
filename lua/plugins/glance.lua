_G.parentbufnr = nil
return {
    "dnlhc/glance.nvim",
    event = "VeryLazy",
    config = function()
        local glance = require("glance")
        local actions = glance.actions

        local function clear_and_restore()
            for bufnr, _ in pairs(_G.glancebuffer) do
                vim.api.nvim_buf_del_keymap(bufnr, "n", "<CR>")
                vim.api.nvim_buf_del_keymap(bufnr, "n", "<esc>")
                vim.api.nvim_buf_del_keymap(bufnr, "n", "q")
                -- vim.api.nvim_buf_del_keymap(bufnr, "n", "H")
            end
            _G.glancebuffer = {} -- 重置glancebuffer
            vim.keymap.set("v", "<CR>", function()
                vim.cmd([[:'<,'>lua require("nvim-treesitter.incremental_selection").node_incremental()]])
            end)
            vim.keymap.set("n", "<CR>", function()
                vim.cmd([[:lua require("nvim-treesitter.incremental_selection").init_selection()]])
            end)
            _G.reference = false
        end

        function Jump()
            clear_and_restore()
            actions.jump()
            vim.schedule(function()
                FeedKeys("H", "t")
            end)
        end

        function Close_with_q()
            clear_and_restore()
            vim.defer_fn(actions.close, 1)
        end

        function OpenAndKeepHighlight()
            OpenFileAtSamePosition()
            FeedKeys("H", "t")
        end
        function OpenFileAtSamePosition()
            -- 获取当前光标位置
            local cursor = vim.api.nvim_win_get_cursor(0)
            local lnum = cursor[1]
            local col = cursor[2]

            -- 获取当前编辑的文件名
            local filename = vim.fn.expand("%:p")

            clear_and_restore()
            vim.schedule(function()
                local uri = vim.uri_from_fname(filename)
                local bufnr = vim.uri_to_bufnr(uri)
                vim.api.nvim_win_set_buf(0, bufnr)
            end)
            actions.close()
            vim.schedule(function()
                vim.api.nvim_win_set_cursor(0, { lnum, col })
            end)
        end
        require("glance").setup({
            height = 18, -- Height of the window
            zindex = 10,
            -- detached = false,

            --[[ Or use a function to enable `detached` only when the active window is too small
            (default behavior)
            detached = function(winid)
                return vim.api.nvim_win_get_width(winid) < 100
            end, ]]

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
                    ["<CR>"] = Jump,
                    ["o"] = actions.jump,
                    ["l"] = actions.open_fold,
                    ["h"] = actions.close_fold,
                    ["<Tab>"] = actions.enter_win("preview"), -- Focus preview window
                    ["q"] = Close_with_q,
                    ["Q"] = Close_with_q,
                    ["<Esc>"] = Close_with_q,
                    ["<C-q>"] = actions.quickfix,
                    -- ['<Esc>'] = false -- disable a mapping
                },
                preview = {
                    -- ["<esc>"] = CloseIfNormal,
                    -- ["q"] = Close_with_q,
                    ["n"] = actions.next_location,
                    ["N"] = actions.previous_location,
                    ["<C-f>"] = actions.enter_win("list"),
                    ["<Tab>"] = actions.enter_win("list"), -- Focus list window
                },
            },
            hooks = {
                before_open = function(result, open, jump, _)
                    _G.parentbufnr = vim.api.nvim_get_current_buf()
                    local lnum = vim.api.nvim_win_get_cursor(0)[1]
                    local locations = {}
                    if result ~= nil and result[1].range == nil then
                        open(result)
                        FeedKeys("<Tab>", "t")
                        return
                    end
                    if #result == 1 then
                        print("no reference")
                        return
                    end
                    if #result == 2 then
                        locations = vim.tbl_filter(function(v)
                            return not (v.range.start.line + 1 == lnum)
                        end, vim.F.if_nil(result, {}))
                        vim.cmd("normal! m'")
                        jump(locations[1])
                    else
                        vim.cmd("normal! m'")
                        open(result) -- argument is optional
                        FeedKeys("<Tab>", "t")
                        if _G.reference == false then
                            FeedKeys("n", "t")
                        end
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
