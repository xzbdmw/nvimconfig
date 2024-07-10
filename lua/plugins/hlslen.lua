return {
    "kevinhwang91/nvim-hlslens",
    version = false,
    config = function()
        local cmd = ""
        local mode = ""
        require("hlslens").setup({
            calm_down = false,
            nearest_only = true,
            nearest_float_when = "never",
            override_lens = function(render, posList, nearest, idx, relIdxm, extmark)
                local c = vim.fn.getcmdline()
                local is_cmdline = c ~= ""
                if is_cmdline then
                    mode = vim.fn.getcmdtype()
                    cmd = c
                end

                if _G.star_search ~= nil then
                    cmd = _G.star_search
                    _G.star_search = nil
                end

                local lnum, col = unpack(posList[idx])
                local cur_row = unpack(api.nvim_win_get_cursor(0))
                if (not is_cmdline) and cur_row ~= lnum then
                    return
                end
                local cnt = #posList
                local text = ("%s%s  [%d/%d]"):format(mode, cmd, idx, cnt)
                if not is_cmdline then
                    extmark:clearBuf(0)
                    -- because use cmp tab to select does not update search pattern
                    text = ("%s%s  [%d/%d]"):format(mode, vim.fn.getreg("/"), idx, cnt)
                end
                local chunks = { { " " }, { text, "HlSearchLensNear" } }
                render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
            end,
        })
    end,
}
