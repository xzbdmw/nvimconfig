return {
    "jake-stewart/multicursor.nvim",
    verison = false,
    config = function()
        local mc = require("multicursor-nvim")
        local keymap = vim.keymap.set
        local del = function(...)
            pcall(vim.keymap.del, ...)
        end
        local cursormoveid
        local opts = { buffer = true, nowait = true }
        local function del_buffer_keys(buf)
            require("multicursor-nvim").clearCursors()
            vim.g.mc_active = false
            vim.o.guicursor = "n-sm-ve:block-Cursor,i-c-ci:ver16-Cursor,r-cr-v-o:hor7-Cursor"
            api.nvim_buf_clear_namespace(0, api.nvim_create_namespace("cursor-mc-count"), 0, -1)
            pcall(api.nvim_del_autocmd, cursormoveid)
            if not api.nvim_buf_is_valid(buf) then
                return
            end
            del({ "n", "x" }, "<d-s>", { buffer = buf })
            del({ "n", "x" }, "<Tab>", { buffer = buf })
            del({ "n", "x" }, "y", { buffer = buf })
            del({ "i" }, "<d-v>", { buffer = buf })
            del({ "n", "x" }, "N", { buffer = buf })
            del({ "n", "x" }, "n", { buffer = buf })
            del({ "n" }, "u", { buffer = buf })
            del({ "n" }, "<C-R>", { buffer = buf })
            del({ "n", "x" }, "q", { buffer = buf })
            del({ "n", "x" }, "<c-q>", { buffer = buf })
            del({ "n", "x" }, "<leader><c-a>", { buffer = buf })
            del({ "n", "x" }, "<leader><c-q>", { buffer = buf })
            del({ "n", "x" }, "<leader><c-e>", { buffer = buf })
            del({ "n", "x" }, "<leader>x", { buffer = buf })
            del({ "n", "x" }, ")", { buffer = buf })
            del({ "n", "x" }, "(", { buffer = buf })
        end
        local function set_buffer_keys()
            keymap({ "n", "x" }, "q", function()
                mc.matchSkipCursor(1)
            end, opts)
            keymap({ "n", "x" }, "<Tab>", function()
                mc.toggleCursor()
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
            keymap({ "n" }, "u", "u", opts)
            keymap({ "n" }, "<C-r>", "<C-r>", opts)
            keymap({ "n", "x" }, "<leader>x", mc.deleteCursor, opts)
            keymap({ "n", "x" }, "<leader><c-q>", mc.duplicateCursors, opts)
            keymap({ "n", "x" }, "<leader><c-a>", mc.alignCursors, opts)
            keymap("x", "<leader><c-e>", function()
                mc.transposeCursors(1)
            end, opts)
            keymap({ "n", "x" }, ")", function()
                mc.nextCursor()
            end, opts)
            keymap({ "n", "x" }, "(", function()
                mc.prevCursor()
            end, opts)
        end
        local begin = function()
            if vim.g.mc_active then
                return
            end
            vim.g.mc_active = true
            vim.o.guicursor = "n-sm-ve-v:block-Cursor,i-c-ci:ver16-Cursor,r-cr-o:hor7-Cursor"
            cursormoveid = api.nvim_create_autocmd("CursorMoved", {
                buffer = api.nvim_get_current_buf(),
                callback = function()
                    vim.schedule(function()
                        require("config.utils").mc_virt_count()
                    end)
                end,
            })
            api.nvim_create_autocmd("TextChanged", {
                once = true,
                buffer = api.nvim_get_current_buf(),
                callback = function()
                    vim.o.guicursor = "n-sm-ve:block-Cursor,i-c-ci:ver16-Cursor,r-cr-v-o:hor7-Cursor"
                end,
            })
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
        local reset_state = function()
            if vim.g.mc_active then
                api.nvim_exec_autocmds("User", {
                    pattern = "ESC",
                })
            end
            begin()
        end

        mc.setup()
        keymap({ "n", "x" }, "mw", function()
            reset_state()
            vim.cmd([[normal! m']])
            local visual = vim.fn.mode():find("[vV]") ~= nil
            mc.operator({ motion = "iw" })
            require("config.utils").restore_mc_view(visual)
        end)
        keymap({ "n" }, "mW", function()
            reset_state()
            vim.cmd([[normal! m']])
            mc.operator()
            require("config.utils").restore_mc_view()
        end)
        keymap({ "n" }, "ms", function()
            reset_state()
            mc.operator({ pattern = [[\<\w]] })
        end)
        keymap({ "n", "v" }, "<d-n>", function()
            begin()
            mc.lineAddCursor(1)
        end)
        -- bring back cursors if you accidentally clear them
        keymap("n", "gV", function()
            begin()
            mc.restoreCursors()
        end)
        keymap({ "n", "x" }, "<c-n>", function()
            -- if vim.api.nvim_get_mode().mode == "n" then
            --     FeedKeys("viw", "mix")
            -- end
            begin()
            mc.matchAddCursor(1)
        end)
        keymap({ "n", "x" }, "<leader>ma", function()
            begin()
            mc.matchAllAddCursors()
            require("config.utils").mc_virt_count()
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
        vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "MCDisabled" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end,
}
