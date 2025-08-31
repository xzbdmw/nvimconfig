local keymap = vim.keymap.set
-- Helper function to set operatorfunc properly
local setOpfunc = vim.fn[vim.api.nvim_exec(
    [[
  func s:setOpfunc(val)
    let &opfunc = a:val
  endfunc
  echon get(function('s:setOpfunc'), 'name')
]],
    true
)]

-- Case conversion functions
local function snake_to_camel(text)
    return text:gsub("_(%l)", function(c)
        return c:upper()
    end)
end

local function camel_to_snake(text)
    return text:gsub("(%l)(%u)", "%1_%2"):lower()
end

local function toggle_case(text)
    if text:find("_") then
        return snake_to_camel(text)
    elseif text:find("%u") then
        return camel_to_snake(text)
    else
        return text
    end
end

-- Helper functions from multicursor pattern
local function getRange()
    local s = vim.api.nvim_buf_get_mark(0, "[")
    local e = vim.api.nvim_buf_get_mark(0, "]")
    return { startRow = s[1], startCol = s[2], endRow = e[1], endCol = e[2] }
end

local function getSelection(range, vmode)
    if vmode == "char" then
        return vim.api.nvim_buf_get_text(
            0,
            range.startRow - 1,
            range.startCol,
            math.min(range.endRow - 1, vim.fn.line("$") - 1),
            range.endCol + 1,
            {}
        )
    else
        -- motion is linewise, col position doesn't matter
        return vim.api.nvim_buf_get_lines(0, range.startRow - 1, range.endRow, false)
    end
end

-- Case conversion operator function
local function case_conversion_operator(opmode)
    local range = getRange()
    local lines = getSelection(range, opmode)

    if #lines == 0 then
        return
    end

    -- Convert each line
    for i, line in ipairs(lines) do
        lines[i] = toggle_case(line)
    end

    -- Replace the text
    if opmode == "char" then
        vim.api.nvim_buf_set_text(
            0,
            range.startRow - 1,
            range.startCol,
            math.min(range.endRow - 1, vim.fn.line("$") - 1),
            range.endCol + 1,
            lines
        )
    else
        vim.api.nvim_buf_set_lines(0, range.startRow - 1, range.endRow, false, lines)
    end
end

vim.keymap.del("n", "gri", opts)

-- Make the function globally accessible
_G.case_conversion_operator = case_conversion_operator

-- Set up the case conversion operator
keymap("n", "gr", function()
    setOpfunc("v:lua.case_conversion_operator")
    vim.api.nvim_feedkeys("g@", "ni", false)
end)
