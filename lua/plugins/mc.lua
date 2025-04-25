return {
    "jake-stewart/multicursor.nvim",
    config = function()
        local mc = require("multicursor-nvim")
        local examples = require("multicursor-nvim.examples")
        local keymap = vim.keymap.set
        local del = function(...)
            pcall(vim.keymap.del, ...)
        end
        local prev
        local cursormoveid
        local opts = { buffer = true, nowait = true }
        local function del_buffer_keys(buf)
            require("multicursor-nvim").clearCursors()
            vim.g.mc_active = false
            api.nvim_buf_clear_namespace(0, api.nvim_create_namespace("cursor-mc-count"), 0, -1)
            pcall(api.nvim_del_autocmd, cursormoveid)
            if not api.nvim_buf_is_valid(buf) then
                return
            end
            del({ "n", "x" }, "<d-s>", { buffer = buf })
            del({ "n", "x" }, "<leader>w", { buffer = buf })
            del({ "n" }, "<Tab>", { buffer = buf })
            del({ "n", "x" }, "y", { buffer = buf })
            del({ "i" }, "<d-v>", { buffer = buf })
            del({ "n", "x" }, "N", { buffer = buf })
            del({ "n", "x" }, "n", { buffer = buf })
            del({ "n" }, "u", { buffer = buf })
            del({ "n" }, "<C-R>", { buffer = buf })
            del({ "n", "x" }, "q", { buffer = buf })
            del({ "n", "x" }, "Q", { buffer = buf })
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
                if prev == "word" then
                    mc.matchSkipCursor(1)
                elseif prev == "line" then
                    mc.lineSkipCursor(1)
                elseif prev == "diag" then
                    mc.diagnosticSkipCursor(1)
                elseif prev == "document" then
                    examples.documentHighlightSkipCursor(1)
                end
            end, opts)
            keymap({ "n", "x" }, "Q", function()
                if prev == "word" then
                    mc.matchSkipCursor(-1)
                elseif prev == "line" then
                    mc.lineSkipCursor(-1)
                elseif prev == "diag" then
                    mc.diagnosticSkipCursor(-1)
                elseif prev == "document" then
                    examples.documentHighlightSkipCursor(-1)
                end
            end, opts)
            keymap({ "n" }, "<Tab>", function()
                mc.toggleCursor()
            end, opts)
            keymap({ "n", "x" }, "y", "y", opts)
            keymap({ "i" }, "<d-v>", function()
                vim.notify("use <C-r> instead")
            end, opts)
            keymap({ "n", "x" }, "<leader>w", function()
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "ESC",
                })
                vim.cmd("write")
            end, opts)
            keymap({ "n", "x" }, "<D-s>", function()
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "ESC",
                })
                vim.cmd("write")
            end, opts)
            keymap({ "n", "x" }, "<c-q>", function()
                require("multicursor-nvim").disableCursors()
            end, opts)
            keymap({ "n", "x" }, "n", function()
                if prev == "word" then
                    mc.matchAddCursor(1)
                elseif prev == "line" then
                    mc.lineAddCursor(1)
                elseif prev == "diag" then
                    examples.diagnosticAddCursor(1)
                elseif prev == "document" then
                    examples.documentHighlightAddCursor(1)
                end
            end, opts)
            keymap({ "n", "x" }, "N", function()
                if prev == "word" then
                    mc.matchAddCursor(-1)
                elseif prev == "line" then
                    mc.lineAddCursor(-1)
                elseif prev == "diag" then
                    examples.diagnosticAddCursor(-1)
                elseif prev == "document" then
                    examples.documentHighlightAddCursor(-1)
                end
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
            cursormoveid = api.nvim_create_autocmd("CursorMoved", {
                buffer = api.nvim_get_current_buf(),
                callback = function()
                    vim.schedule(function()
                        require("config.utils").mc_virt_count()
                    end)
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

        keymap({ "n", "x" }, "<leader><tab><tab>", function()
            begin()
            mc.toggleCursor()
        end)
        keymap({ "n", "x" }, "mw", function()
            reset_state()
            vim.cmd([[normal! m']])
            local visual = vim.fn.mode():find("[vV]") ~= nil
            mc.operator({ motion = "iw", visual = visual })
            require("config.utils").restore_mc_view(visual)
        end)

        keymap({ "n", "x" }, "me", function()
            begin()
            mc.diagnosticMatchCursors({ severity = vim.diagnostic.severity.ERROR })
        end)

        keymap({ "n", "x" }, "]D", function()
            begin()
            prev = "diag"
            if require("multicursor-nvim").numCursors() > 1 then
                examples.diagnosticAddCursor(1)
            else
                examples.diagnosticSkipCursor(1)
            end
        end)
        keymap({ "n", "x" }, "[D", function()
            begin()
            prev = "diag"
            examples.diagnosticAddCursor(-1)
        end)

        keymap({ "n", "x" }, "mh", function()
            begin()
            prev = "document"
            examples.documentHighlightMatchCursors()
        end)
        keymap({ "n", "x" }, "]r", function()
            begin()
            prev = "document"
            examples.documentHighlightAddCursor(1)
        end)
        keymap({ "n", "x" }, "[r", function()
            begin()
            prev = "document"
            examples.documentHighlightAddCursor(-1)
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
            prev = "line"
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
            prev = "word"
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
