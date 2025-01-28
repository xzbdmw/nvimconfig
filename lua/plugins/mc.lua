return {
    "jake-stewart/multicursor.nvim",
    verison = false,
    config = function()
        local mc = require("multicursor-nvim")
        local keymap = vim.keymap.set
        local del = function(...)
            pcall(vim.keymap.del, ...)
        end
        local opts = { buffer = true, nowait = true }
        local function del_buffer_keys(buf)
            require("multicursor-nvim").clearCursors()
            if not api.nvim_buf_is_valid(buf) then
                return
            end
            del({ "n", "x" }, "N", { buffer = buf })
            del({ "n", "x" }, "n", { buffer = buf })
            del({ "n", "x" }, "q", { buffer = buf })
            del({ "n", "x" }, "<leader><c-a>", { buffer = buf })
            del({ "n", "x" }, "<leader><c-q>", { buffer = buf })
            del({ "n", "x" }, "<leader><c-e>", { buffer = buf })
            del({ "n", "x" }, "<leader>x", { buffer = buf })
            del({ "n", "x" }, "<c-t>", { buffer = buf })
            del({ "x" }, "<leader>e", { buffer = buf })
            del({ "n", "x" }, ")", { buffer = buf })
            del({ "n", "x" }, "(", { buffer = buf })
        end
        local function set_buffer_keys()
            keymap({ "n", "x" }, "q", function()
                mc.matchSkipCursor(1)
            end, opts)
            keymap({ "n", "x" }, "n", function()
                mc.matchAddCursor(1)
            end, opts)
            keymap({ "n", "x" }, "N", function()
                mc.matchAddCursor(-1)
            end, opts)
            keymap({ "n", "x" }, "<leader>x", mc.deleteCursor, opts)
            keymap({ "n", "x" }, "<c-t>", mc.toggleCursor, opts)
            keymap({ "n", "x" }, "<leader><c-q>", mc.duplicateCursors, opts)
            keymap({ "n", "x" }, "<leader><c-e>", mc.enableCursors, opts)
            keymap({ "n", "x" }, "<leader><c-a>", mc.alignCursors, opts)
            keymap("x", "<leader>e", function()
                mc.transposeCursors(1)
            end, opts)
            keymap({ "n", "x" }, ")", mc.nextCursor, opts)
            keymap({ "n", "x" }, "(", mc.prevCursor, opts)
        end
        local begin = function()
            if vim.g.mc_active then
                return
            end
            vim.g.mc_active = true
            local buf = vim.api.nvim_get_current_buf()
            set_buffer_keys()
            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = "ESC",
                callback = function()
                    del_buffer_keys(buf)
                end,
            })
        end

        mc.setup()
        keymap({ "n", "v" }, "<a-j>", function()
            begin()
            mc.lineAddCursor(1)
        end)
        keymap({ "n", "v" }, "<a-k>", function()
            begin()
            mc.lineAddCursor(-1)
        end)
        -- bring back cursors if you accidentally clear them
        keymap("n", "gV", function()
            begin()
            mc.restoreCursors()
        end)
        keymap({ "n", "x" }, "<c-n>", function()
            begin()
            mc.matchAddCursor(1)
        end)
        keymap({ "n", "x" }, "<leader>ma", function()
            begin()
            mc.matchAllAddCursors()
        end)
        keymap("x", "mm", function()
            begin()
            mc.matchCursors()
        end)
        keymap("x", "s", function()
            begin()
            mc.splitCursors()
        end)
        keymap("x", "I", function()
            if vim.fn.mode() == vim.api.nvim_replace_termcodes("<c-v>", true, true, true) then
                begin()
                mc.insertVisual()
            else
                FeedKeys("I", "n")
            end
        end)
        keymap("x", "A", function()
            if vim.fn.mode() == vim.api.nvim_replace_termcodes("<c-v>", true, true, true) then
                begin()
                mc.appendVisual()
            else
                FeedKeys("A", "n")
            end
        end)
        keymap("n", "<c-leftmouse>", function()
            begin()
            mc.handleMouse()
        end)
        vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "MultiCursor" })
        vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "LighterVisual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end,
}
