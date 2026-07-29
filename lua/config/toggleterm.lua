local M = {}

function M.smart_toggle()
    local ui = require("toggleterm.ui")
    local terms = require("toggleterm.terminal")
    local has_open = ui.find_open_windows()
    if has_open then
        _G.toggleterm_last_id = terms.get_focused_id() or _G.toggleterm_last_id
        vim.cmd("ToggleTerm")
    elseif _G.toggleterm_last_id and terms.get(_G.toggleterm_last_id) then
        vim.cmd(_G.toggleterm_last_id .. "ToggleTerm")
    else
        vim.cmd("ToggleTerm")
    end
end

-- Jump back to the previous prompt of an agent CLI session. Kept here rather than
-- inline in the keymap so reloading this module also updates already-open terminals.
function M.jump_prev_prompt()
    local term_title = vim.b.term_title
    local buffer_text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    local has_codex_prompt = buffer_text:find("›", 1, true) ~= nil
    -- Cursor Agent: Thought boxes + "→ Add a follow-up" prompt
    local has_cursor_agent = buffer_text:find("Thought for", 1, true) ~= nil
        or buffer_text:find("Add a follow-up", 1, true) ~= nil

    if (term_title and vim.startswith(term_title, "codex")) or has_codex_prompt then
        FeedKeys("<c-\\><c-n>k", "n")
        vim.defer_fn(function()
            vim.fn.search("› ", "b")
            _G.no_animation()
        end, 20)
    elseif has_cursor_agent then
        -- The "→" input box never reaches scrollback. Past user messages are
        -- background-filled blocks: a blank padding line, then the text, both
        -- padded to the same display width. The line above the padding is not,
        -- which distinguishes the top padding from the bottom one.
        FeedKeys("<c-\\><c-n>k", "n")
        vim.defer_fn(function()
            local cur = vim.api.nvim_win_get_cursor(0)[1]
            for i = cur - 1, math.max(2, cur - 20000), -1 do
                local line = vim.fn.getline(i)
                local width = #line
                if width >= 40 and line:match("^ +$") then
                    local below = vim.fn.getline(i + 1)
                    -- The live input box is padded the same way, but is the only
                    -- one prefixed with "→", so skip it however far the cursor is.
                    if
                        not below:match("^ +$")
                        and not below:match("^%s*→")
                        and vim.fn.strdisplaywidth(below) == width
                        and vim.fn.strdisplaywidth(vim.fn.getline(i - 1)) ~= width
                    then
                        vim.api.nvim_win_set_cursor(0, { i + 1, 0 })
                        FeedKeys("0", "m")
                        break
                    end
                end
            end
            _G.no_animation()
        end, 20)
    else
        -- › Improve documentation in @filename
        FeedKeys("<c-\\><c-n>", "n")
        vim.defer_fn(function()
            vim.fn.search("⏺ ", "b")
            _G.no_animation()
        end, 20)
    end
end

_G.ToggletermSmartToggle = M.smart_toggle

return M
