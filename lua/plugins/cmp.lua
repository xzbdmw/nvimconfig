return {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "VeryLazy",
    keys = { { "<C-n>", false } },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-cmdline",
    },
    opts = function()
        local cmp = require("cmp")
        local compare = cmp.config.compare
        -- If you want insert `(` after select function or method item
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        return {
            --[[ enabled = function()
                -- disable completion in comments
                local context = require("cmp.config.context")
                -- keep command mode completion enabled when cursor is in a comment
                if vim.api.nvim_get_mode().mode == "c" then
                    return true
                else
                    return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
                end
            end, ]]
            preselect = cmp.PreselectMode.None,
            window = {
                completion = cmp.config.window.bordered({
                    border = "none",
                    side_padding = 0,
                    col_offset = -3,
                    winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalFloat",
                }),
                documentation = cmp.config.window.bordered({
                    border = "none",
                    side_padding = 0,
                    col_offset = -3,
                    winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalDocFloat",
                }),
            },
            completion = {
                -- autocomplete = { require("cmp.types").cmp.TriggerEvent.InsertEnter },
                completeopt = "menu,menuone,noinsert",
            },
            view = {
                entries = { name = "custom", selection_order = "near_cursor" },
            },
            performance = {
                debounce = 1,
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
                ["<space>"] = cmp.mapping(function(fallback)
                    if cmp.visible then
                        cmp.abort()
                        fallback()
                    else
                        fallback()
                    end
                end),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible then
                        cmp.abort()
                        fallback()
                    else
                        fallback()
                    end
                end),
                ["<f7>"] = cmp.mapping(function()
                    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
                end),
                ["<C-9>"] = cmp.mapping.complete(),
                ["<C-n>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "v", "n" }),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<down>"] = function(fallback)
                    if cmp.visible() then
                        if cmp.core.view.custom_entries_view:is_direction_top_down() then
                            cmp.select_next_item()
                        else
                            cmp.select_prev_item()
                        end
                    else
                        fallback()
                    end
                end,
                ["<up>"] = function(fallback)
                    if cmp.visible() then
                        if cmp.core.view.custom_entries_view:is_direction_top_down() then
                            cmp.select_prev_item()
                        else
                            cmp.select_next_item()
                        end
                    else
                        fallback()
                    end
                end,
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-7>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close_docs()
                    else
                        fallback()
                    end
                end),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                -- { name = "nvim_lsp", trigger_characters = { "&", ":" } },
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "buffer", keyword_length = 2 },
            }),
            formatting = {
                -- kind is icon, abbr is completion name, menu is [Function]
                -- fields = { "kind", "abbr", "menu" },
                fields = { "kind", "abbr" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({
                        mode = "symbol_text",
                        maxwidth = 60,
                    })(entry, vim_item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    kind.kind = " " .. (strings[1] or "") .. " "
                    -- kind.menu = "(" .. (strings[3] or "") .. ")"
                    return kind
                end,
            },
            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
            },
            sorting = {
                compare.order,
                comparators = {
                    compare.score,
                    compare.recently_used,
                    compare.locality,
                    compare.offset,
                },
            },
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        cmp.setup.filetype({ "markdown" }, {
            completion = {
                autocomplete = false,
            },
            sources = {
                -- { name = "nvim_lsp" },
                { name = "path" },
                -- { name = "buffer" },
            },
        })
        for _, source in ipairs(opts.sources) do
            source.group_index = source.group_index or 1
        end
        cmp.setup.cmdline("/", {
            completion = {
                autocomplete = false,
            },
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = cmp.mapping({
                    i = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ select = false }),
                }),
                ["<down>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end,
                },
                ["<up>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                },
                ["<C-p>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i", "c" }),
                ["<C-n>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i", "c" }),
            }),
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline({
                --[[ ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        fallback()
                    end
                end, { "i", "s" }), ]]
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
                ["<up>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                },
                ["<Esc>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.close()
                        else
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
                        end
                    end,
                }),
                ["<C-p>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i", "c" }),
                ["<C-n>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i", "c" }),
            }),
            --[[ completion = {
                completeopt = "menu,menuone,noselect",
            }, ]]
            sources = cmp.config.sources({
                { name = "cmdline" },
                { name = "path" },
            }),
        })
        require("cmp").setup(opts)
        --[[ local capabilities = require("cmp_nvim_lsp").default_capabilities() --nvim-cmp
        -- Setup lspconfig.
        local nvim_lsp = require("lspconfig")

        -- setup languages
        -- GoLang
        nvim_lsp["gopls"].setup({
            cmd = { "gopls" },
            -- on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                gopls = {
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        -- parameterNames = true,
                        rangeVariableTypes = true,
                    },
                    semanticTokens = true,
                    experimentalPostfixCompletions = false,
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = false,
                },
            },
            init_options = {
                -- usePlaceholders = false,
                usePlaceholders = true,
                completeFunctionCalls = true,
            },
        }) ]]
    end,
}
