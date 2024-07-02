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
            override_lens = function(render, posList, nearest, idx, relIdx)
                local c = vim.fn.getcmdline()
                if vim.fn.getcmdtype() ~= "" then
                    mode = vim.fn.getcmdtype()
                end
                if c ~= "" then
                    cmd = c
                end

                local lnum, col = unpack(posList[idx])
                local cnt = #posList
                local text = ("%s%s  [%d/%d]"):format(mode, cmd, idx, cnt)
                local chunks = { { " " }, { text, "HlSearchLensNear" } }
                render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
            end,
        })
    end,
}
