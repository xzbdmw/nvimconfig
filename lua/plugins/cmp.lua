local f = require("config.cmpformat")
return {
    -- "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dir = "/Users/xzb/.local/share/nvim/lazy/nvim-cmp",
    -- lazy = false,
    -- dir = "~/Project/lua/oricmp/nvim-cmp/",
    dependencies = {
        "zbirenbaum/copilot-cmp",
        { dir = "/Users/xzb/.local/share/nvim/lazy/cmp-nvim-lsp" },
        { dir = "~/Project/lua/cmp-rg/" },
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-cmdline",
    },
    opts = function()
        local cmp = require("cmp")
        local compare = cmp.config.compare
        return {
            enabled = function()
                local disabled = false
                disabled = disabled or (api.nvim_buf_get_option(0, "buftype") == "prompt")
                disabled = disabled or (vim.bo.filetype == "oil")
                disabled = disabled or (vim.fn.reg_recording() ~= "")
                disabled = disabled or (vim.fn.reg_executing() ~= "")
                return not disabled
            end,
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
                    winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalDocFloat",
                    col_offset = 0,
                    side_padding = 0,
                }),
            },
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            view = {
                entries = { name = "custom", selection_order = "near_cursor" },
                docs = {
                    auto_open = false,
                },
            },
            performance = {
                debounce = 0,
                throttle = 0,
                fetching_timeout = 200,
                confirm_resolve_timeout = 1,
                async_budget = 1,
                max_view_entries = 20,
            },
            snippet = {
                expand = function(args)
                    if not f.expand then
                        local function remove_bracket_contents(input)
                            local pattern = "^(.*)%b().*$"
                            local result = string.gsub(input, pattern, "%1")
                            return result
                        end
                        args.body = remove_bracket_contents(args.body)
                        f.expand = true
                    end
                    require("luasnip").lsp_expand(args.body)
                    -- vim.snippet.expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<D-d>"] = cmp.mapping(function()
                    if cmp.visible_docs() then
                        cmp.close_docs()
                    else
                        cmp.open_docs()
                    end
                end),
                ["<S-space>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm()
                        FeedKeys("(<C-e><esc>", "m")
                    else
                        fallback()
                    end
                    _G.has_moved_up = false
                end),
                ["<esc>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    vim.g.neovide_cursor_animation_length = 0
                    fallback()
                end),
                ["<right>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        _G.no_animation(_G.CI)
                        cmp.select_cur_item()
                        vim.schedule(function()
                            cmp.close()
                        end)
                    else
                        fallback()
                    end
                    _G.has_moved_up = false
                end),
                ["<space>"] = cmp.mapping(function(fallback)
                    vim.g.space = true
                    if cmp.visible() then
                        cmp.close()
                    end
                    fallback()
                    _G.has_moved_up = false
                end),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    _G.has_moved_up = false
                    fallback()
                end),
                ["<f7>"] = cmp.mapping(function()
                    ---@diagnostic disable-next-line: missing-parameter
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end),
                ["<C-9>"] = cmp.mapping.complete(),
                ["<down>"] = function(fallback)
                    if cmp.visible() then
                        if cmp.core.view.custom_entries_view:is_direction_top_down() then
                            cmp.select_next_item()
                            -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
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
                ["<C-e>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    else
                        fallback()
                    end
                    _G.has_moved_up = false
                end),
                ["<C-n>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                        vim.schedule(fallback)
                    else
                        fallback()
                    end
                end),
                ["<C-p>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                        vim.schedule(fallback)
                    else
                        fallback()
                    end
                end),
                ["<C-7>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close_docs()
                    else
                        fallback()
                    end
                end),
                ["<c-o>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        vim.g.enter = true
                        _G.no_animation(_G.CI)
                        vim.defer_fn(function()
                            vim.g.enter = false
                        end, 10)
                        cmp.confirm({ select = true })
                    else
                        _G.no_delay(0.0)
                        fallback()
                    end
                    vim.defer_fn(function()
                        -- hlchunk
                        ---@diagnostic disable-next-line: undefined-field
                        pcall(_G.update_indent, true)
                        -- mini-indentscope
                        ---@diagnostic disable-next-line: undefined-field
                        pcall(_G.mini_indent_auto_draw)
                    end, 100)
                    _G.has_moved_up = false
                end),
                ["<cr>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        _G.no_animation(_G.CI)
                        vim.g.enter = true
                        _G.CON = true
                        vim.defer_fn(function()
                            vim.g.enter = false
                            _G.CON = nil
                        end, 10)
                        if require("config.utils").if_multicursor() then
                            cmp.select_cur_item()
                            vim.schedule(cmp.close)
                        else
                            cmp.confirm({ select = true })
                        end
                    else
                        _G.no_delay(0.0)
                        fallback()
                    end
                    vim.defer_fn(function()
                        -- hlchunk
                        ---@diagnostic disable-next-line: undefined-field
                        pcall(_G.update_indent, true)
                        -- mini-indentscope
                        ---@diagnostic disable-next-line: undefined-field
                        pcall(_G.mini_indent_auto_draw)
                    end, 100)
                    _G.has_moved_up = false
                end),
            }),
            sources = cmp.config.sources({
                {
                    name = "nvim_lsp",
                    entry_filter = function(entry)
                        if vim.bo.filetype == "go" then
                            local word = entry:get_word()
                            if word == "ifaceassert" then
                                return false
                            end
                            if word == "if" and entry:get_kind() == 14 then
                                return false
                            end
                        elseif vim.bo.filetype == "lua" then
                            local word = entry:get_word()
                            if word == "re" then
                                return false
                            end
                        end
                        return true
                    end,
                },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "rg" },
            }),
            formatting = {
                -- kind is icon, abbr is completion name, menu is [Function]
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local function commom_format(e, item)
                        local kind = require("lspkind").cmp_format({
                            mode = "symbol_text",
                            -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default
                        })(e, item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = " " .. (strings[1] or "") .. " "
                        kind.menu = ""
                        kind.concat = kind.abbr
                        return kind
                    end
                    if vim.bo.filetype == "rust" then
                        return f.rust_fmt(entry, vim_item)
                    elseif vim.bo.filetype == "lua" then
                        return f.lua_fmt(entry, vim_item)
                    elseif vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
                        return f.cpp_fmt(entry, vim_item)
                    elseif vim.bo.filetype == "go" then
                        return f.go_fmt(entry, vim_item)
                    else
                        return commom_format(entry, vim_item)
                    end
                end,
            },
            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
                -- ghost_text = false,
            },
            sorting = {
                compare.order,
                comparators = {
                    -- reverse_prioritize,
                    cmp.config.compare.exact,
                    f.put_down_snippet,
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
        })

        cmp.setup.filetype({ "query" }, {
            sources = {
                { name = "treesitter" },
            },
        })
        for _, source in ipairs(opts.sources) do
            source.group_index = source.group_index or 1
        end
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = cmp.mapping({
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                            FeedKeys("<space><bs>", "n")
                        else
                            fallback()
                        end
                    end,
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
                ["<C-d>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "c", "s" }),
                ["<C-n>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i", "c" }),
            }),
            sources = {
                { name = "rg" },
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
                ["<C-d>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "c", "s" }),
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
                            FeedKeys("<c-c>", "n")
                        end
                    end,
                }),
                ["<C-p>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i", "c" }),
                ["<C-f>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "c" }),
                ["<C-b>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "c" }),
                ["<C-a>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "c" }),
                ["<C-n>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i", "c" }),
            }),
            sources = cmp.config.sources({
                { name = "cmdline" },
                { name = "path" },
            }),
        })
        require("cmp").setup(opts)
    end,
}
