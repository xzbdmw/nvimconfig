local types = require("cmp.types")
local M = {}
M.expand = true
-- stylua: ignore
M.CompletionItemKind = { Text = 1, Method = 2, Function = 3, Constructor = 4, Field = 5, Variable = 6, Class = 7, Interface = 8, Module = 9, Property = 10, Unit = 11, Value = 12, Enum = 13, Keyword = 14, Snippet = 15, Color = 16, File = 17, Reference = 18, Folder = 19, EnumMember = 20, Constant = 21, Struct = 22, Event = 23, Operator = 24, TypeParameter = 25 }

local function go_sort(kind1, kind2)
    -- Snippet lower
    if kind1 == types.lsp.CompletionItemKind.Snippet then
        return false
    end
    if kind2 == types.lsp.CompletionItemKind.Snippet then
        return true
    end
    -- Field higher than function/method
    if (kind1 == 2 or kind1 == 3) and kind2 == 5 then
        return false
    elseif (kind2 == 2 or kind2 == 3) and kind1 == 5 then
        return true
    end
    -- Variable the highest
    if kind1 ~= 6 and kind2 == 6 then
        return false
    elseif kind2 ~= 6 and kind1 == 6 then
        return true
    end
    -- Put down moudle
    -- if kind1 == 9 then
    --     return false
    -- end
    -- if kind2 == 9 then
    --     return true
    -- end
    return nil
end

local function rust_sort(kind1, kind2)
    -- Snippet lower
    if kind1 == types.lsp.CompletionItemKind.Snippet then
        return false
    end
    if kind2 == types.lsp.CompletionItemKind.Snippet then
        return true
    end

    -- Field higher than function/method
    if (kind1 == 2 or kind1 == 3) and kind2 == 5 then
        return false
    elseif (kind2 == 2 or kind2 == 3) and kind1 == 5 then
        return true
    end

    -- EnumMember higher than function/method
    if (kind1 == 2 or kind1 == 3) and kind2 == 20 then
        return false
    elseif (kind2 == 2 or kind2 == 3) and kind1 == 20 then
        return true
    end

    if kind1 ~= 6 and kind2 == 6 then
        return false
    elseif kind2 ~= 6 and kind1 == 6 then
        return true
    end
    return nil
end

local function lua_sort(kind1, kind2)
    -- Variable the highest
    if kind1 ~= 6 and kind2 == 6 then
        return false
    elseif kind2 ~= 6 and kind1 == 6 then
        return true
    end
    return nil
end

M.put_down_snippet = function(entry1, entry2)
    local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
    local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
    kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
    kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
    if vim.bo.filetype == "go" then
        return go_sort(kind1, kind2)
    elseif vim.bo.filetype == "rust" then
        -- visible items comes first
        local detail1 = vim.tbl_get(entry1.completion_item, "labelDetails", "detail")
        local detail2 = vim.tbl_get(entry2.completion_item, "labelDetails", "detail")
        if kind1 == kind2 then
            if detail1 and not detail2 then
                return false
            end
            if detail2 and not detail1 then
                return true
            end
        end
        return rust_sort(kind1, kind2)
    elseif vim.bo.filetype == "lua" then
        return lua_sort(kind1, kind2)
    end
    return nil
end

M.sort = function(kind1, kind2)
    if vim.bo.filetype == "go" then
        return go_sort(kind1, kind2)
    elseif vim.bo.filetype == "rust" then
        return rust_sort(kind1, kind2)
    elseif vim.bo.filetype == "lua" then
        return lua_sort(kind1, kind2)
    end
    return nil
end

return M
