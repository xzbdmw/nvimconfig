local f = require("config.cmpformat")
local utils = require("config.utils")
local ignore = function()
    vim.o.eventignore = "TextChangedI"
    vim.defer_fn(function()
        vim.o.eventignore = ""
    end, 10)
end
return {
    -- "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter", "User SearchBegin" },
    dir = "/Users/xzb/.local/share/nvim/lazy/nvim-cmp",
    -- enabled = false,
    -- lazy = false,
    -- dir = "~/Project/lua/oricmp/nvim-cmp/",
    dependencies = {
        "onsails/lspkind.nvim",
        "zbirenbaum/copilot-cmp",
        { dir = "/Users/xzb/.local/share/nvim/lazy/cmp-nvim-lsp" },
        { dir = "~/Project/lua/cmp-rg/" },
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        { dir = "/Users/xzb/.local/share/nvim/lazy/cmp-mini-snippets/" },
        "echasnovski/mini.snippets",
        -- "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-cmdline",
        "chrisgrieser/cmp_yanky",
        "uga-rosa/cmp-dictionary",
    },
    opts = function()
        local cmp = require("cmp")
        local compare = cmp.config.compare
        return {
            enabled = function()
                if vim.api.nvim_get_mode().mode == "c" then
                    return true
                end
                local disabled = false
                disabled = disabled or (api.nvim_buf_get_option(0, "buftype") == "prompt")
                disabled = disabled or utils.is_big_file(api.nvim_get_current_buf())
                -- return false
                return not disabled
            end,
            preselect = cmp.PreselectMode.None,
            window = {
                completion = cmp.config.window.bordered({
                    border = "none",
                    side_padding = 0,
                    col_offset = -3,
                    winhighlight = "CursorLine:MyCmpCursorLine,Normal:MyNormalFloat",
                }),
                documentation = cmp.config.window.bordered({
                    border = "none",
                    winhighlight = "CursorLine:MyCmpCursorLine,Normal:MyNormalDocFloat",
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
                throttle = 1,
                fetching_timeout = 20000,
                confirm_resolve_timeout = 1,
                async_budget = 1,
                max_view_entries = 100,
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
                    if vim.bo.filetype == "lua" then
                        require("cmp.config").set_onetime({ sources = {} })
                    end
                    utils.mini_snippet_expand(args)
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
                ["<down>"] = function(fallback)
                    if cmp.visible() then
                        if cmp.core.view.custom_entries_view:is_direction_top_down() then
                            _G.no_animation(_G.CI)
                            ignore()
                            cmp.select_next_item()
                        else
                            ignore()
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
                            ignore()
                            cmp.select_prev_item()
                        else
                            ignore()
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
                    fallback()
                end),
                ["<C-b>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.close()
                    end
                    require("cmp").complete({
                        config = {
                            sources = {
                                {
                                    name = "buffer",
                                },
                            },
                        },
                    })
                end),
                ["<C-p>"] = cmp.mapping(function(fallback)
                    fallback()
                end),
                ["<C-g>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    require("cmp").complete({
                        config = {
                            sources = {
                                {
                                    name = "rg",
                                },
                            },
                        },
                    })
                end),
                ["<C-y>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    require("cmp").complete({
                        config = {
                            sources = {
                                {
                                    name = "cmp_yanky",
                                },
                            },
                        },
                    })
                end),
                ["<C-7>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close_docs()
                    else
                        fallback()
                    end
                end),
                ["<f13>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.close()
                    end
                    vim.lsp.buf.signature_help()
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
                ["<right>"] = cmp.mapping(function(fallback)
                    _G.no_animation(_G.CI)
                    if cmp.visible() then
                        f.expand = false
                        cmp.confirm({ select = true })
                        vim.defer_fn(function()
                            pcall(_G.update_indent, true) -- hlchunk
                            pcall(_G.mini_indent_auto_draw) -- mini-indentscope
                        end, 20)
                    else
                        fallback()
                    end
                end),
                ["<cr>"] = cmp.mapping(function(fallback)
                    TTT = vim.uv.hrtime()
                    if cmp.visible() then
                        _G.no_animation(_G.CI)
                        f.expand = true
                        cmp.confirm({ select = true })
                    else
                        utils.speedup_newline(0)
                        fallback()
                    end
                    vim.defer_fn(function()
                        pcall(_G.update_indent, true) -- hlchunk
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
                            if entry:get_completion_item().label == "local function" then
                                return false
                            end
                            if word == "re" then
                                return false
                            end
                        end
                        return true
                    end,
                },
                {
                    name = "mini.snippets",
                    option = {
                        use_minisnippets_match_rule = false,
                        only_show_in_line_start = true,
                    },
                },
                { name = "path" },
            }, {
                {
                    name = "buffer",
                    option = {
                        get_bufnrs = function()
                            local bufs = {}
                            for _, win in ipairs(vim.api.nvim_list_wins()) do
                                local buf = vim.api.nvim_win_get_buf(win)
                                if vim.bo[buf].filetype ~= "NvimTree" then
                                    bufs[buf] = true
                                end
                            end
                            return vim.tbl_keys(bufs)
                        end,
                    },
                },
            }, {
                { name = "dictionary" },
            }),
            matching = {
                disallow_fuzzy_matching = false,
                disallow_fullfuzzy_matching = false,
                -- nvim_set_current_tabpage nvimctab
                disallow_partial_fuzzy_matching = false,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = false,
                disallow_symbol_nonprefix_matching = false,
            },
            formatting = {
                -- kind is icon, abbr is completion name, menu is [Function]
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({
                        mode = "symbol_text",
                    })(entry, vim.deepcopy(vim_item))

                    local highlights_info = require("colorful-menu").cmp_highlights(entry)
                    -- error, such as missing parser, fallback to use raw label.
                    if highlights_info == nil then
                        vim_item.abbr = entry:get_completion_item().label
                    else
                        vim_item.abbr_hl_group = highlights_info.highlights
                        vim_item.abbr = highlights_info.text
                    end

                    -- This is optional, you can omit if you don't use lspkind.
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    vim_item.kind = " " .. (strings[1] or "") .. " "
                    vim_item.menu = ""

                    return vim_item
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
                    function(...)
                        return require("cmp_buffer"):compare_locality(...)
                    end,
                    compare.offset,
                },
            },
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        for _, source in ipairs(opts.sources) do
            source.group_index = source.group_index or 1
        end
        cmp.setup.filetype({ "cpp", "c" }, {
            window = {
                completion = cmp.config.window.bordered({
                    border = "none",
                    side_padding = 0,
                    col_offset = -4,
                    winhighlight = "CursorLine:MyCmpCursorLine,Normal:MyNormalFloat",
                }),
            },
        })
        cmp.setup.cmdline({ "/", "?" }, {
            enabled = function()
                if vim.bo.filetype == "vim" then
                    return false
                end
                return true
            end,
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = cmp.mapping({
                    c = function(fallback)
                        fallback()
                    end,
                }),
                ["<BS>"] = cmp.mapping({
                    c = function(fallback)
                        local cmd = vim.trim(vim.fn.getcmdline())
                        if vim.endswith(cmd, "\\.\\{-}") then
                            FeedKeys("<Bs><BS><BS><BS><BS><BS>", "n")
                        else
                            fallback()
                        end
                    end,
                }),
                ["<esc>"] = cmp.mapping({
                    c = function()
                        _G.hide_cursor(function() end)
                        FeedKeys("<c-c>", "n")
                    end,
                }),
                ["<Tab>"] = cmp.mapping({
                    c = function()
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
                ["<down>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                },
                ["<c-n>"] = {
                    c = function()
                        if cmp.visible() then
                            cmp.close()
                        end
                        FeedKeys("<c-n>", "n")
                    end,
                },
                ["<c-p>"] = {
                    c = function()
                        if cmp.visible() then
                            cmp.close()
                        end
                        FeedKeys("<c-p>", "n")
                        vim.cmd("redraw!")
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
                -- { name = "buffer" },
            }),
        })
        cmp.setup.cmdline(":", {
            window = {
                completion = cmp.config.window.bordered({
                    border = "none",
                    side_padding = 0,
                    col_offset = 0,
                    winhighlight = "CursorLine:MyCmpCursorLine,Normal:MyNormalFloat",
                }),
            },
            formatting = {
                -- kind is icon, abbr is completion name, menu is [Function]
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    vim_item.kind = ""
                    vim_item.menu = ""
                    return vim_item
                end,
            },
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = cmp.mapping({
                    i = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ select = false }),
                }),
                ["<Tab>"] = {
                    c = function()
                        FeedKeys("<CR>", "n")
                    end,
                },
                ["<Down>"] = {
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
                        if cmp.visible() then
                            cmp.close()
                        end
                        FeedKeys("<down>", "m")
                    end,
                },
                ["<c-p>"] = {
                    c = function()
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
                        end
                        FeedKeys("<c-c>", "n")
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
                        for _ = 1, shift do
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
        require("cmp_dictionary").setup({})
    end,
}
