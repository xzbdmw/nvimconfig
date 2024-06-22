local M = {}
M.expand = true
M.CompletionItemKind = {
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
M.reverse_prioritize = function(entry1, entry2)
    local is_snip = entry1:get_completion_item().insertTextFormat == 2
    if entry1.source.name == "copilot" and entry2.source.name ~= "copilot" then
        return false
    elseif entry2.copilot == "copilot" and entry1.source.name ~= "copilot" then
        return true
    end
end

M.put_down_snippet = function(entry1, entry2)
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

function M.copilot(kind, strings)
    kind.abbr = kind.abbr
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end

function M.findLast(haystack, needle)
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
function M.trim_detail(detail)
    if detail then
        detail = vim.trim(detail)
        if vim.startswith(detail, "(use") then
            detail = string.sub(detail, 6, #detail)
            detail = "(" .. detail
        end
    end
    return detail
end
function M.match_fn(description)
    return string.match(description, "^pub fn")
        or string.match(description, "^fn")
        or string.match(description, "^unsafe fn")
        or string.match(description, "^pub unsafe fn")
        or string.match(description, "^pub const unsafe fn")
        or string.match(description, "^const fn")
        or string.match(description, "^pub const fn")
end

function M.rust_fmt(entry, vim_item)
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

function M.lua_fmt(entry, vim_item)
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

function M.c_fmt(entry, vim_item)
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
function M.cpp_fmt(entry, vim_item)
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
function M.go_fmt(entry, vim_item)
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
return M
