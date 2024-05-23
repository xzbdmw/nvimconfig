local M = {}
M.cursor = function(callback, length)
    length = length or 0
    return function(...)
        vim.g.neovide_cursor_animation_length = length
        callback(...)
        vim.defer_fn(function()
            vim.g.neovide_cursor_animation_length = 0.06
        end, 100)
    end
end
_G.rust_query = vim.treesitter.query.parse(
    "rust",
    [[
(type_identifier) @type
(primitive_type) @type.builtin
(self) @variable.special
(field_identifier) @property

(call_expression
  function: [
    (identifier) @function
    (scoped_identifier
      name: (identifier) @function)
    (field_expression
      field: (field_identifier) @function.method)
  ])

(generic_function
  function: [
        (identifier) @function
    (scoped_identifier
      name: (identifier) @function)
    (field_expression
      field: (field_identifier) @function.method)
  ])

(function_item name: (identifier) @function.definition)
(function_signature_item name: (identifier) @function.definition)

(macro_invocation
  macro: [
    (identifier) @function.special
    (scoped_identifier
      name: (identifier) @function.special)
  ])

(macro_definition
  name: (identifier) @function.special.definition)

; Identifier conventions

; Assume uppercase names are types/enum-constructors
((identifier) @type
 (#match? @type "^[A-Z]"))

; Assume all-caps names are constants
((identifier) @constant
 (#match? @constant "^_*[A-Z][A-Z\\d_]*$"))

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket.special

(_
  .
  "<" @punctuation.bracket.special
  ">" @punctuation.bracket.special)

[
  "as"
  "async"
  "await"
  "break"
  "const"
  "continue"
  "default"
  "dyn"
  "else"
  "enum"
  "extern"
  "fn"
  "for"
  "if"
  "impl"
  "in"
  "let"
  "loop"
  "macro_rules!"
  "match"
  "mod"
  "move"
  "pub"
  "ref"
  "return"
  "static"
  "struct"
  "trait"
  "type"
  "union"
  "unsafe"
  "use"
  "where"
  "while"
  "yield"
  (crate)
  (mutable_specifier)
  (super)
] @keyword

[
  (string_literal)
  (raw_string_literal)
  (char_literal)
] @string

[
  (integer_literal)
  (float_literal)
] @number

(boolean_literal) @constant

[
  (line_comment)
  (block_comment)
] @comment]]
)
function M.parseEntry(entryStr)
    ::POS::
    local s, e, betweenParentheses = entryStr:find("%((.-)%)")
    local sub = string.sub(entryStr, s, e)
    if string.find(sub, "%:") == nil then
        entryStr = string.sub(e, string.len(entryStr))
        goto POS
    end
    if betweenParentheses then
        local parts = {}
        for part in betweenParentheses:gmatch("[^:]+") do
            table.insert(parts, tonumber(part))
        end

        if #parts == 2 then
            return parts[1], parts[2]
        else
            return nil, nil
        end
    else
        return nil, nil
    end
end
function M.WriteToFile(content)
    local filename = "/Users/xzb/.local/share/nvim/lazy/multicursors.nvim/demo.txt"
    local file = io.open(filename, "a")
    if file then
        file:write(content)

        file:flush()
    else
    end
end
function M.get_visual_selection_text()
    local _, srow, scol = unpack(vim.fn.getpos("v"))
    local _, erow, ecol = unpack(vim.fn.getpos("."))

    -- visual line mode
    if vim.fn.mode() == "V" then
        if srow > erow then
            return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
        else
            return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
        end
    end

    -- regular visual mode
    if vim.fn.mode() == "v" then
        if srow < erow or (srow == erow and scol <= ecol) then
            return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
        else
            return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
        end
    end

    -- visual block mode
    if vim.fn.mode() == "\22" then
        local lines = {}
        if srow > erow then
            srow, erow = erow, srow
        end
        if scol > ecol then
            scol, ecol = ecol, scol
        end
        for i = srow, erow do
            table.insert(
                lines,
                vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
            )
        end
        return lines
    end
end
return M
