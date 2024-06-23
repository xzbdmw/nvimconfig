-- print("else branch")
-- print("else branch")
-- print("else branch")
-- print("else branch")
local methods = {
    definitions = {
        name = "textDocument/definition",
        is_pending = false,
        cancel_function = nil,
        result = nil,
    },
    implementation = {
        name = "textDocument/implementation",
        is_pending = false,
        cancel_function = nil,
        result = nil,
    },
    references = {
        name = "textDocument/references",
        is_pending = false,
        cancel_function = nil,
        result = nil,
    },
}

local function clear_references()
    if methods.references.is_pending then
        methods.references.cancel_function()
    end
    methods.references.cancel_function = nil
    methods.references.result = nil
    methods.references.is_pending = nil
end

local function clear_definitions()
    if methods.definitions.is_pending then
        methods.definitions.cancel_function()
    end
    methods.definitions.cancel_function = nil
    methods.definitions.is_pending = nil
    methods.definitions.result = nil
end

local function deep_compare(tbl1, tbl2)
    if tbl1 == tbl2 then
        return true
    elseif type(tbl1) == "table" and type(tbl2) == "table" then
        for key1, value1 in pairs(tbl1) do
            local value2 = tbl2[key1]

            if value2 == nil then
                -- avoid the type call for missing keys in tbl2 by directly comparing with nil
                return false
            elseif value1 ~= value2 then
                if type(value1) == "table" and type(value2) == "table" then
                    if not deep_compare(value1, value2) then
                        return false
                    end
                else
                    return false
                end
            end
        end

        -- check for missing keys in tbl1
        for key2, _ in pairs(tbl2) do
            if tbl1[key2] == nil then
                return false
            end
        end

        return true
    end

    return false
end
local function cursor_not_on_result(_, cursor, result)
    if result == nil then
        return true
    end
    if result.originSelectionRange then
        return not deep_compare(result.originSelectionRange, result.targetSelectionRange)
    end
    if result.range then
        local targetline = result.range.start.line + 1
        local current_line = cursor[1]
        return targetline ~= current_line
    end
    -- local target_uri = result.targetUri or result.uri
    -- local target_range = result.targetRange or result.range
    --
    -- -- local target_bufnr = vim.uri_to_bufnr(target_uri)
    -- local target_row_start = target_range.start.line + 1
    -- -- local target_row_end = target_range["end"].line + 1
    -- -- local target_col_start = target_range.start.character + 1
    -- -- local target_col_end = target_range["end"].character + 1
    --
    -- -- local current_bufnr = bufnr
    -- local current_range = cursor
    -- local current_row = current_range[1]
    -- -- local current_col = current_range[2] + 1 -- +1 because if cursor highlights first character its a column behind
    --
    -- -- cursor_not_on_result target_uri: "file:///Users/xzb/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec.rs"
    -- -- cursor_not_on_result target_range: {
    -- --   ["end"] = {
    -- --     character = 1,
    -- --     line = 384
    -- --   },
    -- --   start = {
    -- --     character = 0,
    -- --     line = 118
    -- --   }
    -- -- }
    -- -- cursor_not_on_result target_bufnr: 67
    -- -- cursor_not_on_result target_row_start: 119
    -- -- cursor_not_on_result target_row_end: 385
    -- -- cursor_not_on_result target_col_start: 1
    -- -- cursor_not_on_result target_col_end: 2
    -- -- cursor_not_on_result current_bufnr: 67
    -- -- cursor_not_on_result current_range: { 145, 8 }
    -- -- cursor_not_on_result current_row: 145
    -- -- cursor_not_on_result current_col: 9
    -- -- return target_bufnr ~= current_bufnr
    -- --     or current_row < target_row_start
    -- --     or current_row > target_row_end
    -- --     or (current_row == target_row_start and current_col < target_col_start)
    -- --     or (current_row == target_row_end and current_col > target_col_end)
    -- return current_row ~= target_row_start + 1
end

local function make_params()
    local params = vim.lsp.util.make_position_params(0)
    params.context = { includeDeclaration = false }
    return params
end

local function definitions()
    local current_cursor = api.nvim_win_get_cursor(0)
    local current_bufnr = vim.fn.bufnr("%")
    vim.lsp.buf_request(0, methods.definitions.name, make_params(), function(_, result, context, _)
        methods.definitions.is_pending = false
        methods.definitions.result = result
        if result == nil or #result == 0 then
            return
        end
        -- I assume that the we care about only one (first) definition
        if result and #result <= 2 then
            local first_definition = result[1]
            if cursor_not_on_result(current_bufnr, current_cursor, first_definition) then
                -- print("jump")
                vim.lsp.util.jump_to_location(
                    first_definition,
                    vim.lsp.get_client_by_id(context.client_id).offset_encoding
                )
                return
                    -- print("else branch")
                    vim.cmd("Glance references")
            end
        else
            -- print("enter 3")
            vim.cmd("Glance references")
        end
    end)

    methods.definitions.is_pending = true
end

local function def_or_ref()
    clear_references()
    clear_definitions()
    -- sending references request before definitons to parallelize both requests
    definitions()
end
return { definition_or_references = def_or_ref }
