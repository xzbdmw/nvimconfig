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

_G.ToggletermSmartToggle = M.smart_toggle

return M
