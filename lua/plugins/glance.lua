return {
    "dnlhc/glance.nvim",
    lazy = false,
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

        lcal function after_close()
            vim.api.nvim_buf_del_extmark(0, namespace, id)
        en

        local function before_open(results, open)
            local lnum = vim.api.nvim_win_get_cursor(0)[1]
            id = vim.api.nvim_buf_set_extmark(0, namespace, lnum - 1, 0, { virt_lines = place_holder })
            open(results)
        end ]]

        local function openFileAtSamePosition()
            -- 获取当前光标位置
            local cursor = vim.api.nvim_win_get_cursor(0)
            local lnum = cursor[1]
            local col = cursor[2]

            -- 获取当前编辑的文件名
            local filename = vim.fn.expand("%:p")

            -- 关闭当前窗口
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("q", true, false, true), "t", true)
            local uri = vim.uri_from_fname(filename)
            local bufnr = vim.uri_to_bufnr(uri)
            vim.schedule(function()
                vim.api.nvim_win_set_buf(0, bufnr)
            end)
            -- 重新打开文件，并跳转到相同的位置
            -- 需要延迟执行，因为立即打开文件可能会因为窗口关闭操作而出现问题
            vim.schedule(function()
                vim.api.nvim_win_set_cursor(0, { lnum, col })
            end)
        end
        require("glance").setup({
            height = 18, -- Height of the window
            zindex = 10,
            detached = false,

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
                width = 0.24, -- 33% width relative to the active window, min 0.1, max 0.5
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
                    ["<C-CR>"] = function()
                        openFileAtSamePosition()
                    end,
                    ["q"] = actions.close,
                    ["n"] = actions.next_location,
                    ["N"] = actions.previous_location,
                    ["<Tab>"] = actions.enter_win("list"), -- Focus list window
                },
            },
            hooks = {
                before_open = function(result, open, jump, _)
                    local lnum = vim.api.nvim_win_get_cursor(0)[1]
                    local locations = {}
                    if #result == 2 then
                        locations = vim.tbl_filter(function(v)
                            return not (v.range.start.line + 1 == lnum)
                        end, vim.F.if_nil(result, {}))
                        vim.cmd("normal! m'")
                        jump(locations[1])
                    else
                        vim.cmd("normal! m'")
                        open(result) -- argument is optional
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("j", true, false, true), "t", true)
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "t", true)
                    end
                end,
                before_close = function()
                    -- vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "MyGlancePreviewAfterContextLine" })
                    -- vim.api.nvim_set_hl(0, "TreesitterContext", { link = "MyGlancePreviewAfterContext" })
                    -- vim.api.nvim_set_hl(0, "Normal", { bg = "#faf7e8" })
                end,
            },
            folds = {
                fold_closed = ">",
                fold_open = "󱞩",
                folded = true, -- Automatically fold list on startup
            },
            indent_lines = {
                enable = true,
                icon = " ",
            },
            winbar = {
                enable = true, -- Available strating from nvim-0.8+
            },
        })
    end,
}
