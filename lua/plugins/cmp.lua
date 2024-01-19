return {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-cmdline",
    },
    opts = function()
        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
        local cmp = require("cmp")
        local defaults = require("cmp.config.default")()
        return {
            window = {
                completion = cmp.config.window.bordered({
                    border = "none",
                    side_padding = 0,
                    col_offset = -2,
                }),
            },
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            performance = {
                debounce = 0,
                throttle = 0,
                fetching_timeout = 500,
                confirm_resolve_timeout = 80,
                async_budget = 1,
                max_view_entries = 200,
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                -- ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
                ["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-6>"] = cmp.mapping.close_docs(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<S-CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<C-CR>"] = function(fallback)
                    cmp.abort()
                    fallback()
                end,
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "buffer", keyword_length = 3 },
            }),
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(_, item)
                    local icons = {
                        Array = " ",
                        Boolean = " 󰨙",
                        Class = " 󰯳",
                        Codeium = " 󰘦",
                        Color = " ",
                        Control = " ",
                        Collapsed = " ",
                        Constant = " 󰏿",
                        Constructor = " ",
                        Copilot = " ",
                        Enum = " 󰯹",
                        EnumMember = " ",
                        Event = " ",
                        Field = " ",
                        File = " ",
                        Folder = " ",
                        Function = " 󰊕",
                        Interface = " 󰰅",
                        Key = " ",
                        Keyword = " ",
                        Method = " 󰰑",
                        Module = " ",
                        Namespace = " 󰦮",
                        Null = " ",
                        Number = " 󰰔",
                        Object = " ",
                        Operator = " ",
                        Package = " ",
                        Property = " ",
                        Reference = " ",
                        Snippet = " ",
                        String = " 󰰣",
                        Struct = " 󰆼",
                        TabNine = " 󰏚",
                        Text = " ",
                        TypeParameter = " 󰰦",
                        Unit = " ",
                        Value = " ",
                        Variable = " 󰀫",
                    }
                    -- item.menu = ""
                    local ELLIPSIS_CHAR = "…"
                    local MAX_LABEL_WIDTH = 30
                    -- local icons = require("lazyvim.config").icons.kinds
                    if icons[item.kind] then
                        -- item.kind = icons[item.kind] .. item.kind
                        item.kind = icons[item.kind]
                    end
                    local label = item.abbr
                    local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
                    if truncated_label ~= label then
                        item.abbr = truncated_label .. ELLIPSIS_CHAR
                    end
                    return item
                    -- fields = { "kind", "abbr", "menu" },
                    -- format = function(entry, vim_item)
                    --     local kind = require("lspkind").cmp_format({
                    --         mode = "symbol_text",
                    --         maxwidth = 50,
                    --         show_labelDetails = true,
                    --     })(entry, vim_item)
                    --     local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    --     kind.kind = " " .. (strings[1] or "") .. " "
                    --     kind.menu = "    (" .. (strings[2] or "") .. ")"
                    --     return kind
                end,
            },
            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
            },
            sorting = defaults.sorting,
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        for _, source in ipairs(opts.sources) do
            source.group_index = source.group_index or 1
        end
        -- `/` cmdline setup.
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = cmp.mapping({
                    i = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ select = false }),
                }),
                ["<Down>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end,
                },
                -- ["<Up>"] = {
                --     c = function(fallback)
                --         if cmp.visible() then
                --             cmp.select_prev_item()
                --         else
                --             fallback()
                --         end
                --     end,
                -- },
            }),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
        require("cmp").setup(opts)
    end,
}
