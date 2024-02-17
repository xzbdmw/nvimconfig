local methods = {
    definitions = {
        name = "textDocument/definition",
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

local function cursor_not_on_result(bufnr, cursor, result)
    local target_uri = result.targetUri or result.uri
    local target_range = result.targetRange or result.range

    local target_bufnr = vim.uri_to_bufnr(target_uri)
    local target_row_start = target_range.start.line + 1
    local target_row_end = target_range["end"].line + 1
    local target_col_start = target_range.start.character + 1
    local target_col_end = target_range["end"].character + 1

    local current_bufnr = bufnr
    local current_range = cursor
    local current_row = current_range[1]
    local current_col = current_range[2] + 1 -- +1 because if cursor highlights first character its a column behind

    return target_bufnr ~= current_bufnr
        or current_row < target_row_start
        or current_row > target_row_end
        or (current_row == target_row_start and current_col < target_col_start)
        or (current_row == target_row_end and current_col > target_col_end)
end

local function make_params()
    local params = vim.lsp.util.make_position_params(0)

    params.context = { includeDeclaration = false }
    -- params.position = { character = 16, line = 79 }
    return params
end

local function definitions()
    local current_cursor = vim.api.nvim_win_get_cursor(0)
    local current_bufnr = vim.fn.bufnr("%")
    -- vim.print(vim.inspect(make_params()))
    -- vim.print(methods.definitions.name)
    vim.lsp.buf_request(0, methods.definitions.name, make_params(), function(err, result, context, _)
        -- print("result" .. vim.inspect(result))
        methods.definitions.is_pending = false

        methods.definitions.result = result

        -- I assume that the we care about only one (first) definition
        if result and #result > 0 and #result < 2 then
            local first_definition = result[1]

            if cursor_not_on_result(current_bufnr, current_cursor, first_definition) then
                vim.lsp.util.jump_to_location(
                    first_definition,
                    vim.lsp.get_client_by_id(context.client_id).offset_encoding
                )
                return
            else
                vim.cmd("Lspsaga finder")
            end
        elseif result and #result >= 2 then
            vim.cmd("Lspsaga goto_definition")
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
