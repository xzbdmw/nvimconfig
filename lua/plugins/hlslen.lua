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
                local is_cmdline = vim.fn.getcmdline() ~= ""
                if is_cmdline then
                    mode = vim.fn.getcmdtype()
                    cmd = vim.trim(vim.fn.getcmdline())
                end

                if _G.star_search ~= nil then
                    cmd = _G.star_search
                    _G.star_search = nil
                end

                if cmd == nil or cmd == "" or cmd == " " then
                    render.clear(true, 0, true)
                    return
                end

                local cur_row = unpack(api.nvim_win_get_cursor(0))

                if posList == nil then
                    local chunks = {
                        { " " },
                        { mode, "HlSearchLensCountFail" },
                        { cmd, "HlSearchLensNearFail" },
                        { " [0 of 0]", "HlSearchLensCountFail" },
                    }
                    render.clear(true, 0, true)
                    render.setVirt(0, cur_row - 1, 0, chunks, true)
                    return
                end

                local lnum, col = unpack(posList[idx])
                if (not is_cmdline) and cur_row ~= lnum then
                    return
                end
                local cnt = #posList
                local count = (" [%d of %d]"):format(idx, cnt)
                if not is_cmdline then
                    extmark:clearBuf(0)
                    cmd = vim.trim(vim.fn.getreg("/")) -- because use cmp tab to select does not update search pattern
                else
                    render.clear(true, 0, true)
                end
                local chunks = {
                    { " " },
                    { mode, "HlSearchLensCount" },
                    { cmd, "HlSearchLensNear" },
                    { count, "HlSearchLensCount" },
                }
                vim.defer_fn(function()
                    require("treesitter-context").context_hlslens_force_update(_G.parent_bufnr, _G.parent_winid)
                end, 10)
                render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
            end,
        })
    end,
}
