local expand = true
local CompletionItemKind = {
    Text = 1,
    Method = 2,
    Function = 3,
    Constructor = 4,
    Field = 5,
    Variable = 6,
    Class = 7,
    Interface = 8,
    Module = 9,
    Property = 10,
    Unit = 11,
    Value = 12,
    Enum = 13,
    Keyword = 14,
    Snippet = 15,
    Color = 16,
    File = 17,
    Reference = 18,
    Folder = 19,
    EnumMember = 20,
    Constant = 21,
    Struct = 22,
    Event = 23,
    Operator = 24,
    TypeParameter = 25,
}

local function copilot(kind, strings)
    kind.abbr = kind.abbr
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end

local function findLast(haystack, needle)
    local i = haystack:match(".*" .. needle .. "()")
    if i == nil then
        return nil
    else
        return i - 1
    end
end
--[[ local function trim_detail(detail)
    if detail then
        detail = vim.trim(detail)
        if vim.startswith(detail, "(use") then
            detail = string.sub(detail, 6, #detail)
        end
        local last = findLast(detail, "%:")
        if last then
            local last_item = detail:sub(last + 1, #detail - 1)
            detail = detail:sub(1, last - 2)
            detail = last_item .. " " .. detail
            detail = "(" .. detail .. ")"
        else
            detail = "(" .. detail
        end
    end
    return detail
end ]]
local function trim_detail(detail)
    if detail then
        detail = vim.trim(detail)
        if vim.startswith(detail, "(use") then
            detail = string.sub(detail, 6, #detail)
            detail = "(" .. detail
        end
    end
    return detail
end
local function match_fn(description)
    return string.match(description, "^pub fn")
        or string.match(description, "^fn")
        or string.match(description, "^unsafe fn")
        or string.match(description, "^pub unsafe fn")
        or string.match(description, "^pub const unsafe fn")
        or string.match(description, "^const fn")
        or string.match(description, "^pub const fn")
end

local function rust_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local completion_item = entry:get_completion_item()
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number

    local label_detail = completion_item.labelDetails
    if item_kind == 3 or item_kind == 2 then -- Function/Method
        --[[ labelDetails.
        function#function#if detail: {
          description = "pub fn shl(self, rhs: Rhs) -> Self::Output",
          detail = " (use std::ops::Shl)"
        } ]]
        if label_detail then
            local detail = label_detail.detail
            detail = trim_detail(detail)
            local description = label_detail.description
            if description then
                if string.sub(description, #description, #description) == "," then
                    description = description:sub(1, #description - 1)
                end
            end
            if
                (detail and vim.startswith(detail, "macro")) or (description and vim.startswith(description, "macro"))
            then
                kind.concat = kind.abbr
                goto OUT
            end
            if detail and description then
                if match_fn(description) then
                    local start_index, _ = string.find(description, "(", nil, true)
                    if start_index then
                        description = description:sub(start_index, #description)
                    end
                end
                local index = string.find(kind.abbr, "(", nil, true)
                -- description: "macro simd_swizzle"
                -- detail: " (use std::simd::simd_swizzle)"
                if index then
                    local prefix = string.sub(kind.abbr, 1, index - 1)
                    kind.abbr = prefix .. description .. " " .. detail
                    kind.concat = "fn " .. prefix .. description .. "{}//" .. detail
                    kind.offset = 3
                else
                    kind.concat = kind.abbr .. "  //" .. detail
                    kind.abbr = kind.abbr .. " " .. detail
                end
            elseif detail then
                kind.concat = "fn " .. kind.abbr .. "{}//" .. detail
                kind.abbr = kind.abbr .. " " .. detail
            elseif description then
                if match_fn(description) then
                    local start_index, _ = string.find(description, "%(")
                    if start_index then
                        description = description:sub(start_index, #description)
                    end
                end
                local index = string.find(kind.abbr, "(", nil, true)
                if index then
                    local prefix = string.sub(kind.abbr, 1, index - 1)
                    kind.abbr = prefix .. description .. " "
                    kind.concat = "fn " .. prefix .. description .. "{}//"
                    kind.offset = 3
                else
                    kind.concat = kind.abbr .. "  //" .. description
                    kind.abbr = kind.abbr .. " " .. description
                end
            else
                kind.concat = kind.abbr
            end
        end
    elseif item_kind == 15 then
    elseif item_kind == 5 then -- Field
        local detail = completion_item.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = "struct S {" .. kind.abbr .. ": " .. detail .. "}"
            kind.abbr = kind.abbr .. ": " .. detail
        else
            kind.concat = "struct S {" .. kind.abbr .. ": String" .. "}"
        end
        kind.offset = 10
    elseif item_kind == 6 or item_kind == 21 then -- variable constant
        if label_detail then
            local detail = label_detail.description
            --[[ if detail then -- align type at right
                -- local s = kind.abbr .. " " .. detail
                local hole = string.rep(" ", 60 - #kind.abbr - #detail)
                kind.concat = "let " .. kind.abbr .. string.rep(" ", 58 - #kind.abbr - #detail) .. ": " .. detail
                kind.abbr = kind.abbr .. hole .. detail
                kind.offset = 4
            else ]]
            if detail then
                kind.concat = "let " .. kind.abbr .. ": " .. detail
                kind.abbr = kind.abbr .. ": " .. detail
                kind.offset = 4
            else
                kind.concat = kind.abbr
            end
        end
    elseif item_kind == 9 then -- Module
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = kind.abbr .. "  //" .. detail
            kind.abbr = kind.abbr .. " " .. detail
            kind.offset = 0
        else
            kind.concat = kind.abbr
        end
    elseif item_kind == 8 then -- Trait
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = "trait " .. kind.abbr .. "{}//" .. detail
            kind.abbr = kind.abbr .. " " .. detail
        else
            kind.concat = "trait " .. kind.abbr .. "{}"
            kind.abbr = kind.abbr
        end
        kind.offset = 6
    elseif item_kind == 22 then -- Struct
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = kind.abbr .. "  //" .. detail
            kind.abbr = kind.abbr .. " " .. detail
        else
            kind.concat = kind.abbr
        end
    elseif item_kind == 1 then -- "Text"
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    elseif item_kind == 14 then
        if kind.abbr == "mut" then
            kind.concat = "let mut"
            kind.offset = 4
        else
            kind.concat = kind.abbr
        end
    else
        --[[ if label_detail then
            local detail = label_detail.detail
            local description = label_detail.description
            if detail then
                kind.abbr = kind.abbr .. " " .. detail
            end
            if description then
                kind.abbr = kind.abbr .. " " .. description
            end
        end
        if completion_item.detail then
            kind.abbr = kind.abbr .. " " .. completion_item.detail
        end ]]
        kind.concat = kind.abbr
    end
    if item_kind == 15 then
        kind.concat = ""
    end
    ::OUT::
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 60 then
        kind.abbr = kind.abbr:sub(1, 60)
    end

    return kind
end

local function lua_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })

    local is_copilot = entry:get_completion_item().copilot
    if is_copilot then
        return copilot(kind, strings)
    end

    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    if item_kind == 5 then -- Field
        kind.concat = "v." .. kind.abbr
        kind.offset = 2
    elseif item_kind == 1 or item_kind == 16 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    else
        kind.concat = kind.abbr
    end
    kind.abbr = kind.abbr
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end

local function c_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    if item_kind == 5 then -- Field
        kind.concat = "v." .. kind.abbr
        kind.offset = 2
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    else
        kind.concat = kind.abbr
    end
    kind.abbr = kind.abbr
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end
local function cpp_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    -- detail = "int",
    -- documentation = {
    --   kind = "markdown",
    --   value = "From `<cstdio>`"
    -- }
    -- filterText = "printf",
    -- insertText = "printf(${1:const char *, ...})",
    -- insertTextFormat = 2,
    -- kind = 3,
    -- label = "•printf",
    -- labelDetails = {
    --   detail = "(const char *, ...)"
    -- },
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    local completion_item = entry:get_completion_item()
    if vim.startswith(completion_item.label, "•") then
        completion_item.label = vim.trim(string.sub(completion_item.label, 4, #completion_item.label))
    end
    kind.abbr = vim.trim(kind.abbr)
    if vim.startswith(kind.abbr, "•") then
        kind.abbr = vim.trim(string.sub(kind.abbr, 4, #kind.abbr))
    end
    local label_detail = completion_item.labelDetails
    local ducument = completion_item.documentation
    if item_kind == 3 or item_kind == 2 or item_kind == 4 then --Function
        if label_detail ~= nil then
            -- label = " get",
            -- labelDetails = {
            --   detail = "<class T1>(const tuple<Args...> &tup)"
            -- },
            kind.concat = string.format(
                "%s%s; %s a//%s",
                vim.trim(completion_item.label or ""),
                vim.trim(label_detail.detail or ""),
                vim.trim(completion_item.detail or ""),
                vim.trim(ducument and ducument.value or "")
            )
            kind.abbr = string.format(
                "%s%s: %s   %s",
                vim.trim(completion_item.label or ""),
                vim.trim(label_detail.detail or ""),
                vim.trim(completion_item.detail or ""),
                vim.trim(ducument and ducument.value or "")
            )
            -- kind.abbr = kind.concat
            kind.offset = 0
        end
    elseif item_kind == 6 then -- Variable
        -- detail = "int",
        -- kind = 6,
        -- label = " a",
        kind.concat = string.format("&%s;%s a", vim.trim(completion_item.label), completion_item.detail)
        kind.abbr = string.format("%s %s", vim.trim(completion_item.label), completion_item.detail)
        kind.offset = 1
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    else
        kind.concat = kind.abbr
    end
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end
local function go_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    local completion_item = entry:get_completion_item()

    local is_copilot = entry:get_completion_item().copilot
    if is_copilot then
        return copilot(kind, strings)
    end

    local detail = completion_item.detail
    if item_kind == 5 then -- Field
        if detail then
            local last = findLast(kind.abbr, "%.")
            if last then
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "type T struct{" .. space_hole .. catstr .. " " .. detail .. "}"
                kind.offset = 14
                kind.abbr = kind.abbr .. " " .. detail
            else
                kind.concat = "type T struct{" .. kind.abbr .. " " .. detail .. "}"
                kind.offset = 14
                kind.abbr = kind.abbr .. " " .. detail
            end
        else
            kind.concat = "type T struct{" .. kind.abbr .. " " .. "}"
            kind.offset = 14
            kind.abbr = kind.abbr .. " " .. detail
        end
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    elseif item_kind == 15 then -- snippet
        kind.concat = ""
        kind.offset = 1
    elseif item_kind == 6 or item_kind == 21 then -- Variable
        local last = findLast(kind.abbr, "%.")
        if detail then
            if last then
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "var " .. space_hole .. catstr .. " " .. detail
                kind.offset = 4
                kind.abbr = kind.abbr .. " " .. detail
            else
                if detail then
                    kind.concat = "var " .. kind.abbr .. " " .. detail
                    kind.abbr = kind.abbr .. " " .. detail
                    kind.offset = 4
                end
            end
        end
    elseif item_kind == 22 then -- Struct
        local last = findLast(kind.abbr, "%.")
        if last then
            local catstr = kind.abbr:sub(last + 1, #kind.abbr)
            local space_hole = string.rep(" ", last)
            kind.concat = "type " .. space_hole .. catstr .. " struct{}"
            kind.offset = 5
            kind.abbr = kind.abbr .. " struct{}"
        else
            kind.concat = "type " .. kind.abbr .. " struct{}"
            kind.abbr = kind.abbr .. " struct{}"
            kind.offset = 5
        end
    elseif item_kind == 3 or item_kind == 2 then -- Function/Method
        local last = findLast(kind.abbr, "%.")
        if last then
            if detail then
                detail = detail:sub(5, #detail)
                kind.abbr = kind.abbr .. detail
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "func " .. space_hole .. catstr .. "{}"
                kind.offset = 5
            else
                kind.concat = "func " .. kind.abbr .. "(){}"
                kind.offset = 5
            end
        else
            if detail then
                detail = detail:sub(5, #detail)
                kind.abbr = kind.abbr .. detail
                kind.concat = "func " .. kind.abbr .. "{}"
                kind.offset = 5
            else
                kind.concat = "func " .. kind.abbr .. "(){}"
                kind.abbr = kind.abbr
                kind.offset = 5
            end
        end
    elseif item_kind == 9 then -- Module
        if detail then
            kind.offset = 6 - #kind.abbr
            kind.abbr = kind.abbr .. " " .. detail
            kind.concat = "import " .. detail
        end
    elseif item_kind == 8 then -- Interface
        local last = findLast(kind.abbr, "%.")
        if last then
            local catstr = kind.abbr:sub(last + 1, #kind.abbr)
            local space_hole = string.rep(" ", last)
            kind.concat = "type " .. space_hole .. catstr .. " interface{}"
            kind.offset = 5
            kind.abbr = kind.abbr .. " interface{}"
        else
            kind.concat = "type " .. kind.abbr .. " interface{}"
            kind.abbr = kind.abbr .. " interface{}"
            kind.offset = 5
        end
    else
        kind.concat = kind.abbr
    end
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = ""
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end
return {
    -- "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dir = "/Users/xzb/.local/share/nvim/lazy/nvim-cmp",
    -- lazy = false,
    -- dir = "~/Project/lua/oricmp/nvim-cmp/",
    dependencies = {
        "lukas-reineke/cmp-rg",
        "zbirenbaum/copilot-cmp",
        { dir = "/Users/xzb/.local/share/nvim/lazy/cmp-nvim-lsp" },
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-cmdline",
    },
    opts = function()
        local reverse_prioritize = function(entry1, entry2)
            local is_snip = entry1:get_completion_item().insertTextFormat == 2
            if entry1.source.name == "copilot" and entry2.source.name ~= "copilot" then
                return false
            elseif entry2.copilot == "copilot" and entry1.source.name ~= "copilot" then
                return true
            end
        end
        local put_down_snippet = function(entry1, entry2)
            local types = require("cmp.types")
            local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
            local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
            kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
            kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
            if kind1 ~= kind2 then
                if kind1 == types.lsp.CompletionItemKind.Snippet or kind1 == 9 then
                    return false
                end
                if kind2 == types.lsp.CompletionItemKind.Snippet or kind2 == 9 then
                    return true
                end
            end
            return nil
        end
        local cmp = require("cmp")
        local compare = cmp.config.compare
        return {
            enabled = function()
                local disabled = false
                disabled = disabled or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt")
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
                fetching_timeout = 10000,
                confirm_resolve_timeout = 10000,
                async_budget = 1,
                max_view_entries = 20,
            },
            snippet = {
                expand = function(args)
                    if not expand then
                        local function remove_bracket_contents(input)
                            local pattern = "^(.*)%b().*$"
                            local result = string.gsub(input, pattern, "%1")
                            return result
                        end
                        args.body = remove_bracket_contents(args.body)
                        expand = true
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
                        expand = false
                        _G.no_animation(_G.CI)
                        cmp.confirm()
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
                        cmp.abort()
                    else
                        fallback()
                    end
                    _G.has_moved_up = false
                end),
                ["<C-n>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    end
                    fallback()
                end),
                ["<C-p>"] = cmp.mapping(function(fallback)
                    if cmp.visible then
                        cmp.close()
                    end
                    if cmp.visible() then
                        cmp.close()
                    end
                    fallback()
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
                        vim.g.enter = true
                        _G.no_animation(_G.CI)
                        _G.CON = true
                        vim.defer_fn(function()
                            vim.g.enter = false
                            _G.CON = nil
                        end, 10)
                        if require("config.utils").if_multicursor() then
                            expand = false
                        else
                            expand = true
                        end
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
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip", keyword_length = 2 },
                { name = "path" },
            }, {
                { name = "rg", keyword_length = 2 },
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
                        return rust_fmt(entry, vim_item)
                    elseif vim.bo.filetype == "lua" then
                        return lua_fmt(entry, vim_item)
                    elseif vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
                        return cpp_fmt(entry, vim_item)
                    elseif vim.bo.filetype == "go" then
                        return go_fmt(entry, vim_item)
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
                    put_down_snippet,
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
                ["<C-d>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i", "c", "s" }),
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
            sources = cmp.config.sources({
                { name = "cmdline" },
                { name = "path" },
            }),
        })
        require("cmp").setup(opts)
    end,
}
