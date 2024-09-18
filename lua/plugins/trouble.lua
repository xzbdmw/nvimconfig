return {
    "folke/trouble.nvim",
    -- dir = "~/Project/lua/trouble.nvim/",
    -- branch = "dev", -- IMPORTANT!
    -- commit = "ab7d4a80883df2733204556746dba0714fe966d1",
    keys = {
        {
            "<leader>xw",
            "<cmd>Trouble mydiags toggle focus=false<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<C-q>",
            function()
                if require("trouble").is_open("mydiags") then
                    vim.cmd("Trouble mydiags toggle filter.buf=0 focus=false")
                    vim.cmd("Trouble qflist toggle focus=false")
                else
                    vim.cmd("Trouble qflist toggle focus=false")
                end
            end,
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xx",
            function()
                if require("trouble").is_open("qflist") then
                    vim.cmd("Trouble qflist toggle focus=false")
                    vim.cmd("Trouble mydiags toggle filter.buf=0 focus=false")
                else
                    vim.cmd("Trouble mydiags toggle filter.buf=0 focus=false")
                end
            end,
            desc = "Buffer Diagnostics (Trouble)",
        },
    },
    opts = {
        auto_close = true, -- auto close when there are no items
        auto_open = false, -- auto open when there are items
        auto_preview = true, -- automatically open preview when on an item
        auto_refresh = true, -- auto refresh when open
        auto_jump = false, -- auto jump to the item when there's only one
        focus = false, -- Focus the window when opened
        restore = true, -- restores the last location in the list when opening
        follow = true, -- Follow the current item
        indent_guides = true, -- show indent guides
        max_items = 2000000, -- limit number of items that can be displayed per section
        multiline = true, -- render multi-line messages
        pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
        -- Window options for the preview window. Can be a split, floating window,
        -- or `main` to show the preview in the main editor window.
        preview = { type = "main", scratch = true },
        -- Throttle/Debounce settings. Should usually not be changed.
        ---@type table<string, number|{ms:number, debounce?:boolean}>
        throttle = {
            refresh = 100, -- fetches new data when needed
            update = 10, -- updates the window
            render = 10, -- renders the window
            follow = 1, -- follows the current item
            preview = { ms = 1, debounce = true }, -- shows the preview for the current item
        },
        -- Key mappings can be set to the name of a builtin action,
        -- or you can define your own custom action.
        keys = {
            ["?"] = "help",
            r = "refresh",
            R = "toggle_refresh",
            q = "close",
            o = "jump_close",
            ["<esc>"] = "cancel",
            ["<cr>"] = "jump",
            ["<Tab>"] = "tab",
            ["<2-leftmouse>"] = "jump",
            ["<c-s>"] = "jump_split",
            ["<c-v>"] = "jump_vsplit",
            -- go down to next item (accepts count)
            -- j = "next",
            ["}"] = "next",
            ["]]"] = "next",
            -- go up to prev item (accepts count)
            -- k = "prev",
            ["{"] = "prev",
            ["[["] = "prev",
            i = "inspect",
            p = "preview",
            P = "toggle_preview",
            zo = "fold_open",
            zO = "fold_open_recursive",
            zc = "fold_close",
            zC = "fold_close_recursive",
            za = "fold_toggle",
            zA = "fold_toggle_recursive",
            zm = "fold_more",
            zM = "fold_close_all",
            zr = "fold_reduce",
            zR = "fold_open_all",
            zx = "fold_update",
            zX = "fold_update_all",
            zn = "fold_disable",
            zN = "fold_enable",
            zi = "fold_toggle_enable",
        },
        modes = {
            mydiags = {
                mode = "diagnostics", -- inherit from diagnostics mode
                preview = {
                    zindex = 20,
                },
                filter = function(items)
                    -- remove overlap marks
                    local severity = vim.diagnostic.severity.HINT
                    for _, item in ipairs(items) do
                        severity = math.min(severity, item.severity)
                    end
                    local filtered = vim.tbl_filter(function(item)
                        return item.severity == severity and item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                    end, items)
                    local hash = {}
                    local set = {}
                    for _, item in ipairs(filtered) do
                        if not hash[item.lnum] then
                            set[#set + 1] = item
                            hash[item.lnum] = true
                        end
                        severity = math.min(severity, item.severity)
                    end
                    return set
                end,
            },
            preview_float = {
                mode = "diagnostics",
                preview = {
                    type = "float",
                    relative = "editor",
                    border = "rounded",
                    title = "Preview",
                    title_pos = "center",
                    position = { 0, -2 },
                    size = { width = 0.3, height = 0.3 },
                    zindex = 20,
                },
            },
            symbols = {
                desc = "document symbols",
                mode = "lsp_document_symbols",
                focus = false,
                win = { position = "right" },
                filter = {
                    -- remove Package since luals uses it for control flow structures
                    ["not"] = { ft = "lua", kind = "Package" },
                    any = {
                        -- all symbol kinds for help / markdown files
                        ft = { "help", "markdown" },
                        -- default set of symbol kinds
                        kind = {
                            "Class",
                            "Constructor",
                            "Enum",
                            "Field",
                            "Function",
                            "Interface",
                            "Method",
                            "Module",
                            "Namespace",
                            "Package",
                            "Property",
                            "Struct",
                            "Trait",
                        },
                    },
                },
            },
        },
        icons = {
            indent = {
                top = "│ ",
                middle = "├╴",
                last = "└╴",
                -- last          = "-╴",
                -- last       = "╰╴", -- rounded
                fold_open = "󱞩 ",
                fold_closed = "󱦰 ",
                ws = "  ",
            },
            folder_closed = " ",
            folder_open = " ",
            kinds = {
                Array = " ",
                Boolean = "󰨙 ",
                Class = " ",
                Constant = "󰏿 ",
                Constructor = " ",
                Enum = " ",
                EnumMember = " ",
                Event = " ",
                Field = " ",
                File = " ",
                Function = "󰊕 ",
                Interface = " ",
                Key = " ",
                Method = "󰊕 ",
                Module = " ",
                Namespace = "󰦮 ",
                Null = " ",
                Number = "󰎠 ",
                Object = " ",
                Operator = " ",
                Package = " ",
                Property = " ",
                String = " ",
                Struct = "󰆼 ",
                TypeParameter = " ",
                Variable = "󰀫 ",
            },
        },
    }, -- for default options, refer to the configuration section for custom setup.
}
