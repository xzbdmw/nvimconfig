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
            del({ "n", "x" }, "<d-s>", { buffer = buf })
            del({ "n", "x" }, "y", { buffer = buf })
            del({ "i" }, "<d-v>", { buffer = buf })
            del({ "n", "x" }, "N", { buffer = buf })
            del({ "n", "x" }, "n", { buffer = buf })
            del({ "n", "x" }, "u", { buffer = buf })
            del({ "n", "x" }, "q", { buffer = buf })
            del({ "n", "x" }, "<c-q>", { buffer = buf })
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
            keymap({ "n", "x" }, "y", "y", opts)
            keymap({ "i" }, "<d-v>", function()
                vim.notify("use <C-r> instead")
            end, opts)
            keymap({ "n", "x" }, "<D-s>", function()
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "ESC",
                })
                vim.cmd("write")
            end, opts)
            keymap({ "n", "x" }, "<c-q>", function()
                mc.matchSkipCursor(-1)
            end, opts)
            keymap({ "n", "x" }, "n", function()
                mc.matchAddCursor(1)
            end, opts)
            keymap({ "n", "x" }, "N", function()
                mc.matchAddCursor(-1)
            end, opts)
            keymap({ "n", "x" }, "u", function()
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "ESC",
                })
                return "u"
            end, { expr = true, remap = true })
            keymap({ "n", "x" }, "<leader>x", mc.deleteCursor, opts)
            keymap({ "n", "x" }, "<leader><c-q>", mc.duplicateCursors, opts)
            keymap({ "n", "x" }, "<leader>e", mc.enableCursors, opts)
            keymap({ "n", "x" }, "<leader><c-a>", mc.alignCursors, opts)
            keymap("x", "<leader><c-e>", function()
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
        keymap({ "n", "v" }, "<a-n>", function()
            begin()
            mc.lineAddCursor(1)
        end)
        keymap({ "n", "v" }, "<a-p>", function()
            begin()
            mc.lineAddCursor(-1)
        end)
        -- bring back cursors if you accidentally clear them
        keymap("n", "gV", function()
            begin()
            mc.restoreCursors()
        end)
        keymap({ "n", "x" }, "<d-x>", function()
            begin()
            mc.toggleCursor()
        end)
        keymap({ "n", "x" }, "<c-n>", function()
            if vim.api.nvim_get_mode().mode == "n" then
                FeedKeys("viw", "mix")
            end
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
        keymap("n", "<c-leftmouse>", function()
            if not vim.g.mc_aptive then
                mc.addCursor("<Nop>")
            end
            begin()
            mc.handleMouse()
        end)
        vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "MultiCursor" })
        vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "LighterVisual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end,
}
