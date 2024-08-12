local f = require("config.cmpformat")
local utils = require("config.utils")
return {
    -- "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter", "User SearchBegin" },
    dir = "/Users/xzb/.local/share/nvim/lazy/nvim-cmp",
    -- lazy = false,
    -- dir = "~/Project/lua/oricmp/nvim-cmp/",
    dependencies = {
        "zbirenbaum/copilot-cmp",
        { dir = "/Users/xzb/.local/share/nvim/lazy/cmp-nvim-lsp" },
        { dir = "~/Project/lua/cmp-rg/" },
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
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
                disabled = disabled or (vim.bo.filetype == "oil" or vim.bo.filetype == "gitcommit")
                disabled = disabled or (vim.fn.reg_recording() ~= "")
                disabled = disabled or (vim.fn.reg_executing() ~= "")
                disabled = disabled or utils.is_big_file(api.nvim_get_current_buf())
                disabled = disabled or api.nvim_buf_get_name(0) == "lsp:rename"
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
                ["<d-v>"] = cmp.mapping(function(fallback)
                    fallback()
                    vim.cmd([[redraw]])
                end, { "i", "c", "s" }),
                ["<esc>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    fallback()
                end),
                ["<space>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    fallback()
                end),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    vim.schedule(fallback)
                end),
                ["<C-9>"] = cmp.mapping.complete(),
                ["<down>"] = function(fallback)
                    if cmp.visible() then
                        if cmp.core.view.custom_entries_view:is_direction_top_down() then
                            _G.no_animation(_G.CI)
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
                            _G.no_animation(_G.CI)
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
                    end
                    fallback()
                end),
                ["<C-c>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    else
                        fallback()
                    end
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
                ["<left>"] = cmp.mapping(function(fallback)
                    _G.no_animation(_G.CI)
                    fallback()
                end),
                ["<c-cr>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    _G.no_animation(_G.CI)
                    fallback()
                end),
                ["<c-r>"] = cmp.mapping(function(fallback)
                    _G.no_animation(_G.CI)
                    if cmp.visible() then
                        _G.CON = true
                        vim.defer_fn(function()
                            _G.CON = nil
                        end, 10)
                        f.expand = false
                        cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
                        vim.defer_fn(function()
                            ---@diagnostic disable-next-line: undefined-field
                            pcall(_G.update_indent, true) -- hlchunk
                            ---@diagnostic disable-next-line: undefined-field
                            pcall(_G.mini_indent_auto_draw) -- mini-indentscope
                        end, 20)
                    else
                        fallback()
                    end
                end),
                ["<right>"] = cmp.mapping(function(fallback)
                    _G.no_animation(_G.CI)
                    if cmp.visible() then
                        _G.CON = true
                        vim.defer_fn(function()
                            _G.CON = nil
                        end, 10)
                        f.expand = false
                        cmp.confirm({ select = true })
                        vim.defer_fn(function()
                            ---@diagnostic disable-next-line: undefined-field
                            pcall(_G.update_indent, true) -- hlchunk
                            ---@diagnostic disable-next-line: undefined-field
                            pcall(_G.mini_indent_auto_draw) -- mini-indentscope
                        end, 20)
                    else
                        fallback()
                    end
                end),
                ["<cr>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        _G.no_animation(_G.CI)
                        _G.CON = true
                        vim.defer_fn(function()
                            _G.CON = nil
                        end, 10)
                        f.expand = true
                        if utils.if_multicursor() then
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
                        ---@diagnostic disable-next-line: undefined-field
                        pcall(_G.update_indent, true) -- hlchunk
                        ---@diagnostic disable-next-line: undefined-field
                        pcall(_G.mini_indent_auto_draw) -- mini-indentscope
                    end, 20)
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
            }, {
                { name = "buffer" },
            }),
            matching = {
                disallow_fuzzy_matching = false,
                disallow_fullfuzzy_matching = false,
                -- nvim_set_current_tabpage nvimctab
                disallow_partial_fuzzy_matching = false,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = false,
                disallow_symbol_nonprefix_matching = true,
            },
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
        for _, source in ipairs(opts.sources) do
            source.group_index = source.group_index or 1
        end
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = cmp.mapping({
                    c = function(fallback)
                        fallback()
                    end,
                }),
                ["<esc>"] = cmp.mapping({
                    c = function()
                        _G.hide_cursor(function() end)
                        FeedKeys("<c-c>", "n")
                    end,
                }),
                ["<Tab>"] = cmp.mapping({
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                            FeedKeys("<space><bs><CR>", "n")
                        else
                            FeedKeys("<CR>", "n")
                        end
                    end,
                }),
                ["<right>"] = cmp.mapping({
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                            vim.cmd([[redraw]])
                        else
                            fallback()
                        end
                    end,
                }),
                ["<up>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end,
                },
                ["<c-n>"] = {
                    c = function()
                        FeedKeys("<C-g>", "n")
                    end,
                },
                ["<c-p>"] = {
                    c = function()
                        FeedKeys("<C-t>", "n")
                    end,
                },
                ["<down>"] = {
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
                    vim.cmd([[redraw]])
                end, { "i", "c", "s" }),
                ["<C-u>"] = cmp.mapping(function(fallback)
                    fallback()
                    vim.cmd([[redraw]])
                end, { "i", "c", "s" }),
                ["<d-v>"] = cmp.mapping(function(fallback)
                    fallback()
                    vim.cmd([[redraw]])
                end, { "i", "c", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "rg" },
            }, {
                { name = "buffer" },
            }),
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
                ["<c-n>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.close()
                        end
                        FeedKeys("<down>", "m")
                    end,
                },
                ["<c-p>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.close()
                        end
                        FeedKeys("<up>", "m")
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
                ["<C-f>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "c" }),
                ["<C-b>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "c" }),
                ["<C-a>"] = cmp.mapping(function(fallback)
                    local is_cmdline = vim.fn.getcmdline()
                    if vim.startswith(is_cmdline, "IncRename") then
                        local cursor = utils.noice_incsearch_at_start()
                        local shift = cursor - 3
                        for i = 1, shift do
                            FeedKeys("<left>", "n")
                        end
                    else
                        fallback()
                    end
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
