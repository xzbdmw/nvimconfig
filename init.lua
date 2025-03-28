vim.uv = vim.loop
api = vim.api

require("config.lazy")
local utils = require("config.utils")
_G.CI = 0.02
_G.searchmode = "/"
_G.lazygit_previous_win = nil
_G.pre_gitsigns_qf_operation = ""
vim.g.Base_commit = ""
vim.g.Diff_file_count = 0
vim.g.Base_commit_msg = ""
vim.g.Last_commit_msg = ""
vim.g.Last_commit = ""
vim.g.vim_enter = true
vim.g.stage_title = ""
vim.g.last_staged_title_path = ""
vim.g.winbar_macro_beginstate = ""
vim.g.skip_noice = false
vim.g.hlchunk_disable = false
vim.g.cy = false
vim.g.search_pos = nil
vim.g.diffview_fname = ""
vim.g.restore_view = true
vim.g.show_nvim_tree_size = false
vim.g.disable_flash = false
vim.g.mc_active = false
vim.g.sign_padding = true
vim.g.constran_minisnippets = false
-- This have to be commented because ghostty use --cmd to set
-- vim.g.scrollback = true, or it will be overwritten.
-- vim.g.scrollback = false
_G.hide_cursor_hl = function()
    local hide_hl = vim.deepcopy(_G.curosr_hl)
    hide_hl.blend = 100
    return hide_hl
end

vim.cmd("syntax off")

local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.hover = "gh"

-- sync system clipboard while yanking
api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        local v = vim.v.event
        local regcontents = v.regcontents
        vim.schedule(function()
            vim.fn.setreg("+", regcontents, "v")
        end)
    end,
})

-- sync system clipboard to vim clipboard
api.nvim_create_autocmd("FocusGained", {
    callback = function()
        local loaded_content = vim.fn.getreg("+")
        if loaded_content ~= "" then
            vim.fn.setreg('"', loaded_content, loaded_content:find("\n") ~= nil and "V" or "v")
        end
    end,
})

api.nvim_create_autocmd({ "BufLeave" }, {
    callback = function()
        if vim.bo.filetype == "lazyterm" then
            return
        end
        local win = vim.api.nvim_get_current_win()
        vim.wo[win].cursorline = true
    end,
})

api.nvim_create_autocmd({ "CursorMoved" }, {
    callback = function()
        local win = vim.api.nvim_get_current_win()
        if vim.wo[win].cursorline then
            local name = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
            if name ~= nil or vim.bo.filetype == "oil" or vim.bo.filetype == "qf" then
                vim.wo[win].cursorline = false
            end
        end
    end,
})

api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        vim.schedule(function()
            local win = vim.api.nvim_get_current_win()
            if vim.wo[win].cursorline then
                local name = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
                if name ~= nil then
                    vim.wo[win].cursorline = false
                end
            end
        end)
    end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "qf",
    callback = function()
        vim.schedule(function()
            local origin = vim.o.eventignore
            vim.o.eventignore = "all"
            vim.cmd("wall")
            vim.o.eventignore = origin
        end)
    end,
})

api.nvim_create_autocmd({ "User" }, {
    pattern = "TelescopePreviewerLoaded",
    callback = function(data)
        local winid = data.data.winid
        local preview_buf = api.nvim_win_get_buf(winid)
        vim.wo[winid].number = true
        utils.update_preview_state(preview_buf, winid)
        local ns = api.nvim_create_namespace("preview_match")
        vim.api.nvim_buf_clear_namespace(preview_buf, ns, 0, -1)
        utils.update_preview_match(ns, preview_buf)
        for _, t in ipairs({ 0, 10 }) do
            vim.defer_fn(function()
                utils.update_preview_match(ns, preview_buf)
            end, t)
        end
    end,
})

api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.md", "*.txt" },
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

api.nvim_create_autocmd({ "TabEnter" }, {
    callback = function()
        vim.schedule(function()
            local name = vim.api.nvim_buf_get_name(0)
            if vim.startswith(name, "/private/var") then
                FeedKeys("G", "n")
                vim.wo.scrolloff = 0
                vim.api.nvim_create_autocmd("TabClosed", {
                    once = true,
                    callback = function(d)
                        if d.file == "2" then
                            vim.system({ "open", "-a", "Ghostty" }):wait()
                        end
                    end,
                })
            end
        end)
    end,
})

api.nvim_create_autocmd("User", {
    pattern = { "ArrowUpdate" },
    callback = function()
        vim.defer_fn(function()
            vim.cmd("NvimTreeRefresh")
        end, 10)
    end,
})

api.nvim_create_autocmd("QuitPre", {
    callback = function()
        if not utils.fold_method_diff() then
            vim.cmd([[silent! mkview!]])
        end
    end,
})

api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
        utils.record_winbar_enter()
        api.nvim_set_hl(0, "Cursor", { bg = "#6327A6" })
    end,
})

api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
        _G.set_winbar(vim.g.winbar_macro_beginstate)
        vim.on_key(nil, api.nvim_create_namespace("winbar_macro"))
        api.nvim_set_hl(0, "Cursor", { bg = "#000000" })
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "gitsigns.blame" },
    callback = function()
        FeedKeys("<Tab>", "m")
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
        vim.bo.indentexpr = "nvim_treesitter#indent()"
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.keymap.set("x", "<leader>re", function()
            utils.gopls_extract_all()
        end, { buffer = true })
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "FlashHide",
    callback = function()
        local key_ns = vim.api.nvim_create_namespace("flash;")
        vim.on_key(function(_, typed)
            if typed == ";" then
                require("flash.prompt").jump_to_next_match(false)
            elseif typed == "," then
                require("flash.prompt").jump_to_prev_match(false)
            else
                vim.on_key(nil, api.nvim_create_namespace("flash;"))
                vim.g.disable_flash = false
            end
        end, key_ns)
    end,
})

-- api.nvim_create_autocmd("BufWritePost", {
--     pattern = "*.rs",
--     callback = function()
--         local params = vim.lsp.util.make_range_params()
--         params.context = {
--             only = { "quickfix" },
--             diagnostics = vim.tbl_map(function(d)
--                 return d.user_data.lsp
--             end, vim.diagnostic.get(0)),
--             triggerKind = 1,
--         }
--         params.range = {
--             start = { line = 0, character = 0 },
--             ["end"] = { line = #vim.api.nvim_buf_get_lines(0, 0, -1, false), character = 0 },
--         }
--         vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, context, config)
--             for _, action in ipairs(result or {}) do
--                 if action.title == "Remove all the unused imports" then
--                     local client = vim.lsp.get_client_by_id(context.client_id)
--                     client.request("codeAction/resolve", action, function(err_resolve, resolved_action)
--                         if err_resolve then
--                             vim.notify(err_resolve.code .. ": " .. err_resolve.message, vim.log.levels.ERROR)
--                             return
--                         end
--                         if resolved_action.edit then
--                             vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
--                             vim.cmd("silent write")
--                         end
--                     end)
--                     return
--                 end
--             end
--         end)
--     end,
-- })

api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 100)
        for _, res in pairs(result or {}) do
            for _, action in pairs(res.result or {}) do
                if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                else
                    vim.lsp.buf.execute_command(action.command)
                end
            end
        end
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "lazy" },
    callback = function(args)
        vim.defer_fn(function()
            pcall(api.nvim_buf_del_keymap, args.buf, "n", "U")
        end, 500)
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "undotree", "diff" },
    callback = function(args)
        local win = vim.fn.win_findbuf(args.buf)[1]
        vim.wo[win].winbar = ""
    end,
})

api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.schedule(function()
            if vim.bo.filetype == "noice" then
                vim.keymap.set("n", "K", "5k", { buffer = true })
                vim.wo.signcolumn = "no"
            end
        end)
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "git" },
    callback = function()
        vim.wo.signcolumn = "no"
        vim.cmd("setlocal syntax=ON")
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    end,
})

api.nvim_create_autocmd("TabEnter", {
    callback = function()
        local tabnum = vim.fn.tabpagenr()
        if tabnum ~= 1 then
            vim.g.neovide_underline_stroke_scale = 0
        else
            vim.g.neovide_underline_stroke_scale = 1.5
        end
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit" },
    callback = function()
        local buf
        api.nvim_create_autocmd("CursorMoved", {
            once = true,
            callback = function()
                vim.cmd("norm! gg")
                FeedKeys("a", "m")
                vim.cmd("setlocal syntax=ON")
                vim.schedule(function()
                    buf = api.nvim_get_current_buf()
                end)
            end,
        })
        vim.defer_fn(function()
            vim.keymap.set({ "n" }, "<CR>", function()
                vim.schedule(function()
                    if vim.bo.filetype == "lazyterm" then
                        -- refresh lazygit
                        FeedKeys("<C-v><c-l>", "n")
                    end
                end)
                vim.defer_fn(function()
                    utils.refresh_last_commit()
                    utils.update_diff_file_count()
                    utils.refresh_nvim_tree_git()
                end, 50)

                vim.cmd("w")
                vim.cmd(string.format("bw! %d", buf))
                vim.system(
                    { "git", "commit", "--cleanup=strip", "-F", "./.git/COMMIT_EDITMSG" },
                    { cwd = utils.git_root() },
                    function(result)
                        if result.code == 0 then
                            vim.notify(result.stdout, vim.log.levels.INFO)
                            require("nvim-tree.actions.reloaders").reload_explorer()
                        end
                    end
                )
            end, { buffer = true })
        end, 100)
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = "lazyterm",
    callback = function()
        local function in_prompt()
            local view = vim.fn.winsaveview()
            local bottonline = view.topline + vim.api.nvim_win_get_height(0)
            local row = vim.api.nvim_win_get_cursor(0)[1]
            return bottonline - 1 ~= row or api.nvim_buf_get_lines(0, row - 1, row, false)[1]:match("Search") ~= nil
        end
        vim.keymap.set("t", "c", function()
            return in_prompt() and "c" or "<c-e>"
        end, { buffer = true, expr = true })
        vim.keymap.set("t", "q", function()
            return in_prompt() and "q" or "<c-q>"
        end, { buffer = true, expr = true })
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "undotree", "diff" },
    callback = function()
        vim.cmd("setlocal syntax=ON")
    end,
})

vim.api.nvim_set_hl(0, "YankyYanked", { link = "Search", default = true })

api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(args)
        vim.keymap.set("n", "<cr>", "<cr>", { buffer = args.buf })
        vim.keymap.set("n", "<Tab>", function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_config(win).zindex == 52 then
                    vim.api.nvim_win_close(win, true)
                    break
                end
            end
            utils.normal_tab()
        end, { buffer = args.buf })
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function()
        utils.hide_cursor()
        api.nvim_create_autocmd("User", {
            once = true,
            pattern = "OilCursor",
            callback = function()
                utils.show_cursor()
            end,
        })
    end,
})

local origin = vim.g.neovide_flatten_floating_zindex
api.nvim_create_autocmd("CmdwinEnter", {
    callback = function()
        vim.g.neovide_flatten_floating_zindex = origin .. ",249,250"
        vim.keymap.set("n", "<cr>", "<cr>", { buffer = true })
        vim.keymap.set({ "i", "n" }, "<Tab>", "<cr>", { buffer = true })
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true })
        local cmp = require("cmp")
        if cmp.visible() then
            cmp.close()
        end
        cmp.setup.buffer({ sources = cmp.config.sources({ { name = "cmdline" } }) })
    end,
})
api.nvim_create_autocmd("CmdwinLeave", {
    callback = function()
        vim.g.neovide_flatten_floating_zindex = origin
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function(event)
        -- incremental selectino will overwritten <CR>.
        vim.schedule(function()
            vim.keymap.set("n", "<CR>", "K", { buffer = event.buf })
        end)
    end,
})

vim.api.nvim_create_autocmd("TextChangedI", {
    callback = function()
        local snip = require("config.autosnip")
        if vim.loop.fs_stat(vim.api.nvim_buf_get_name(0)) == nil then
            return
        end
        if vim.bo.filetype == "go" then
            -- snip.go_auto_add_equal()
            snip.go_auto_add_pair()
            snip.auto_add_forr()
            snip.auto_add_fori()
            snip.auto_add_forj()
            snip.auto_add_forl()
        elseif vim.bo.filetype == "lua" then
            snip.lua_auto_add_local()
            snip.lua_auto_pai()
            snip.lua_auto_pia()
            snip.lua_auto_add_while()
            snip.lua_abbr()
            snip.auto_add_forr()
            snip.auto_add_fori()
            snip.auto_add_forj()
        end
        snip.auto_add_if()
        snip.auto_add_ret()
        snip.autotrue()
        snip.autofalse()
    end,
})

api.nvim_create_autocmd("FileType", {
    -- stylua: ignore
    pattern = { "saga_codeaction", "txt", "PlenaryTestPopup", "help", "lspinfo", "man", "notify", "qf", "query", "spectre_panel", "startuptime", "tsplayground", "neotest-output", "checkhealth", "neotest-summary", "vim", "neotest-output-panel", "toggleterm" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", function()
            if vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "" then
                FeedKeys("q", "n")
            else
                _G.no_animation()
                _G.hide_cursor(function() end)
                vim.cmd("close")
            end
        end, { buffer = event.buf, silent = true })
    end,
})

api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:n",
    callback = function()
        local len = vim.g.neovide_cursor_animation_length
        if len ~= 0 then
            _G.set_cursor_animation(0.0)
        end
        utils.refresh_diagnostic_winbar()
    end,
})

api.nvim_create_autocmd("ModeChanged", {
    pattern = "[vV\x16]:*",
    callback = function()
        api.nvim_buf_clear_namespace(0, api.nvim_create_namespace("visual_range"), 0, -1)
        _G.indent_update()
    end,
})

api.nvim_create_autocmd("ModeChanged", {
    pattern = "n:V",
    callback = function()
        if api.nvim_get_mode().mode == "v" or vim.wo.signcolumn ~= "yes" then
            return
        end
        local s, e = vim.fn.line("."), vim.fn.line("v")
        local ns = api.nvim_create_namespace("visual_range")
        api.nvim_buf_set_extmark(0, ns, s - 1, 0, {
            end_row = e - 1,
            strict = false,
            priority = 1,
            virt_text = { { "", "Hl" } },
        })
        _G.indent_update()
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "v_V", -- visual mode press V
    callback = utils.try_update_visual_coloum,
})

api.nvim_create_autocmd("CursorMoved", {
    callback = utils.try_update_visual_coloum,
})

api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
        utils.set_diagnostic_winbar()
        local time = { 100, 200, 300, 400 }
        for _, t in ipairs(time) do
            vim.defer_fn(utils.set_diagnostic_winbar, t)
        end
    end,
})

api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
        pcall(function()
            local is_enabled = require("noice.ui")._attached
            if not is_enabled then
                vim.schedule(function()
                    vim.cmd("Noice enable")
                end)
            end
        end)
        vim.defer_fn(function()
            if vim.bo.filetype == "toggleterm" then
                vim.o.scrolloff = 0
            else
                vim.o.scrolloff = 6
            end
        end, 20)
        _G.set_cursor_animation(0.0)
    end,
})

-- Search confirm -> hlslens.refreshCurrentBuf -> collet pos ->
-- hlslens calling nvim_exec_autocmds SatelliteSearch -> Satellite render
api.nvim_create_autocmd("User", {
    pattern = "SatelliteSearch",
    callback = function()
        utils.refresh_satellite_search()
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "ClearSatellite",
    callback = function()
        utils.clear_satellite_search()
    end,
})

_G.glance_buffer = {}
api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        utils.set_glance_keymap()
        utils.set_glance_winbar()
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "TroubleOpen",
    callback = function(data)
        local mode = data.data
        if mode == "mydiags" then
            _G.has_diagnostic = true
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "",
                    source = "if_many",
                    spacing = 0,
                },
            })
        end
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "TroubleClose",
    callback = function(data)
        local mode = data.data
        if mode == "mydiags" and not utils.has_filetype("trouble") then
            _G.has_diagnostic = false
            vim.diagnostic.config({ virtual_text = false })
        end
    end,
})

api.nvim_create_autocmd({ "BufRead" }, {
    pattern = {
        "/Users/xzb/.rustup/toolchains/**/*.rs",
        "/Users/xzb/.cargo/**/*.rs",
        "/opt/homebrew/Cellar/**/*.go",
    },
    command = "setlocal nomodifiable",
})

api.nvim_create_user_command("Ut", function()
    ---@diagnostic disable-next-line: param-type-mismatch
    api.nvim_cmd(api.nvim_parse_cmd("UndotreeToggle", {}), {})
    utils.setUndotreeWinSize()
end, { desc = "load undotree" })

api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        -- TODO: remove this later
        local tabnum = vim.fn.tabpagenr()
        if tabnum == 1 and not utils.fold_method_diff() then
            vim.cmd([[silent! mkview!]])
        end
        api.nvim_exec_autocmds("User", {
            pattern = "GitSignsUserUpdate",
        })
        vim.defer_fn(function()
            utils.refresh_last_commit()
            utils.update_diff_file_count()
            utils.refresh_nvim_tree_git()
        end, 10)
        pcall(_G.indent_update)
        for _, buf in ipairs(api.nvim_list_bufs()) do
            -- Don't save while there's any 'nofile' buffer open.
            if api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
                return
            end
        end
        require("session_manager").save_current_session()
    end,
})

api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function(args)
        utils.set_winbar(args.buf)
        vim.defer_fn(function()
            utils.set_winbar(args.buf)
            utils.set_git_winbar()
            utils.set_diagnostic_winbar()
        end, 50)
        utils.set_git_winbar()
        utils.set_diagnostic_winbar()
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    callback = utils.set_git_winbar,
})

api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "*",
    callback = function()
        if not utils.fold_method_diff() then
            vim.cmd([[silent! mkview!]])
        end
    end,
})

api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    callback = function(ev)
        if vim.wo.foldmethod == "diff" and vim.fn.tabpagenr() == 1 then
            print("foldmethod diff")
            vim.wo.foldmethod = "manual"
        end
        if vim.bo[ev.buf].filetype == "oil" and api.nvim_get_current_buf() == ev.buf then
            utils.set_oil_winbar()
        end
        if vim.bo.filetype == "fzf" then
            return
        else
            vim.cmd([[silent! loadview]])
        end
    end,
})

api.nvim_create_autocmd({ "BufReadPre" }, {
    pattern = "*",
    callback = function()
        vim.g.gd = true
        vim.defer_fn(function()
            vim.g.gd = false
        end, 30)
    end,
})

vim.cmd([[set viewoptions-=curdir]])

api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionLoadPre",
    callback = function()
        vim.g.vim_enter = true
        local tabcount = #api.nvim_list_tabpages()
        if tabcount > 1 then
            vim.cmd("tabclose! " .. 2)
        end
        vim.g.show_nvim_tree_size = false
        pcall(api.nvim_del_augroup_by_name, "diffview_nvim")
    end,
})

api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionLoadPost",
    callback = function()
        local ok, gs = pcall(require, "gitsigns")
        if ok then
            if vim.g.Base_commit ~= "" then
                Signs_staged = nil
                gs.change_base(vim.g.Base_commit, true)
                for _, t in ipairs({ 200, 500 }) do
                    -- when nvim start at first time, gitsigns may choose index as base
                    vim.defer_fn(function()
                        utils.update_diff_file_count()
                        gs.change_base(vim.g.Base_commit, true)
                    end, t)
                end
            else
                vim.defer_fn(function()
                    utils.refresh_last_commit()
                    utils.update_diff_file_count()
                end, 200)
                gs.reset_base(vim.g.Base_commit, true)
            end
        end
        require("nvim-tree.api").tree.toggle({ focus = false })
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "LoadSessionPre",
    callback = function()
        -- toggle all filter
        FeedKeys("<leader>F", "m")
        if require("gitsigns.config").config.word_diff then
            local gs = package.loaded.gitsigns
            gs.toggle_word_diff()
            gs.toggle_deleted()
            gs.toggle_linehl()
            return
        end
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(args)
        if args.data.err then
            return
        end
        vim.defer_fn(function()
            for _, action in ipairs(args.data.actions) do
                if action.type == "delete" then
                    local _, path = require("oil.util").parse_url(action.url)
                    local bufnr = vim.fn.bufnr(path)
                    if bufnr ~= -1 then
                        vim.cmd("bw! " .. bufnr)
                    end
                end
                vim.cmd("NvimTreeRefresh")
            end
            require("smart-open.util").reset_cache()
        end, 100)
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "GitSignsUserUpdate",
    callback = function()
        if utils.has_filetype("trouble") then
            if _G.pre_gitsigns_qf_operation == "cur" then
                for _, t in ipairs({ 200, 500 }) do
                    vim.defer_fn(function()
                        require("gitsigns").setqflist(0)
                    end, t)
                end
            elseif _G.pre_gitsigns_qf_operation == "all" then
                for _, t in ipairs({ 200, 500 }) do
                    vim.defer_fn(function()
                        require("gitsigns").setqflist("all")
                    end, t)
                end
            end
        end
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "MiniSnippetsSessionJump",
    callback = function(args)
        if vim.g.constran_minisnippets then
            vim.g.constran_minisnippets = false
            return
        end
        if args.data.tabstop_to == "0" and #MiniSnippets.session.get(true) > 1 then
            MiniSnippets.session.stop()
        end
    end,
})

api.nvim_create_autocmd("User", {
    pattern = { "NvimTreeReloaded" },
    callback = function()
        require("nvim-tree.actions").tree.find_file.fn()
    end,
})

api.nvim_create_autocmd("TermOpen", {
    command = "setlocal nonu nornu signcolumn=no",
})

api.nvim_create_autocmd("User", {
    pattern = "GitSignsChanged",
    callback = function()
        vim.defer_fn(function()
            utils.refresh_nvim_tree_git()
        end, 50)
        vim.defer_fn(function()
            utils.update_diff_file_count()
        end, 300)
    end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        vim.schedule(function()
            vim.diagnostic.hide(nil)
        end)
    end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "i:n",
    callback = function()
        vim.schedule(function()
            vim.diagnostic.show()
        end)
    end,
})

local hisel_id
local hisel_ns = api.nvim_create_namespace("hisel")
api.nvim_create_augroup("hisel", {})
api.nvim_create_autocmd("ModeChanged", {
    group = "hisel",
    pattern = "*:[vV\x16]",
    callback = function(args)
        -- for viw
        vim.on_key(function(_, _)
            local prev_text = utils.get_visual()
            vim.defer_fn(function()
                if api.nvim_get_current_buf() ~= args.buf then
                    return
                end
                local new_text = utils.get_visual()
                if new_text ~= prev_text then
                    utils.do_highlight(args.buf)
                end
            end, 10)
        end, hisel_ns)
        utils.do_highlight(args.buf)
        -- for cr
        vim.defer_fn(function()
            utils.do_highlight(args.buf)
        end, 10)
        hisel_id = api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                utils.do_highlight(args.buf)
            end,
        })
    end,
})

api.nvim_create_autocmd("ModeChanged", {
    group = "hisel",
    pattern = "[vV\x16]:*",
    callback = function()
        if hisel_id then
            api.nvim_del_autocmd(hisel_id)
            vim.on_key(nil, hisel_ns)
            hisel_id = nil
        end
        utils.clear()
    end,
})

if vim.g.neovide then
    api.nvim_set_hl(0, "TermCursor", {})
else
    api.nvim_set_hl(0, "TermCursor", { bg = "#3636DB" })
end

vim.lsp.set_log_level("error")
require("vim.lsp.log").set_format_func(vim.inspect)

local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
    require("profile").instrument_autocmds()
    if should_profile:lower():match("^start") then
        require("profile").start("*")
    else
        require("profile").instrument("*")
    end
end
local function toggle_profile()
    local prof = require("profile")
    if prof.is_recording() then
        prof.stop()
        vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
                prof.export(filename)
                vim.notify(string.format("Wrote %s", filename))
            end
        end)
    else
        prof.start("*")
    end
end
vim.keymap.set({ "n", "i" }, "<D-i>", toggle_profile)
-- api.nvim_create_autocmd("CursorMoved", {
--     callback = function()
--         if vim.g.gd then
--             if ST ~= nil then
--                 Time(ST, "CursorMoved")
--             end
--         end
--     end,
-- })
