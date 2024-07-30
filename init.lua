vim.uv = vim.loop
api = vim.api

require("config.lazy")
local utils = require("config.utils")

_G.CI = 0.04
_G.searchmode = "/"
_G.lazygit_previous_win = nil
_G.pre_gitsigns_qf_operation = ""
vim.g.Base_commit = ""
vim.g.diff_file_count = 0
vim.g.Base_commit_msg = ""
vim.g.vim_enter = true
vim.g.stage_title = ""
vim.g.last_staged_title_path = ""

vim.cmd("syntax off")

local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.hover = "gh"

api.nvim_create_augroup("LeapIlluminate", {})

-- sync system clipboard while yanking
api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        local v = vim.v.event
        local regcontents = v.regcontents
        vim.schedule(function()
            vim.fn.setreg("+", regcontents)
        end)
    end,
})

-- sync system clipboard to vim clipboard
api.nvim_create_autocmd("FocusGained", {
    callback = function()
        local loaded_content = vim.fn.getreg("+")
        if loaded_content ~= "" then
            vim.fn.setreg('"', loaded_content)
        end
    end,
})

api.nvim_create_autocmd({ "User" }, {
    pattern = "TelescopePreviewerLoaded",
    callback = function(data)
        local winid = data.data.winid
        vim.wo[winid].number = true
        utils.update_preview_state(api.nvim_win_get_buf(winid), winid)
    end,
})

_G.leapjump = false
api.nvim_create_autocmd("User", {
    pattern = { "LeapSelectPre", "LeapJumpRepeat" },
    callback = function()
        _G.leapjump = true
        local buf = api.nvim_get_current_buf()
        local win = api.nvim_get_current_win()
        require("illuminate.engine").refresh_references(buf, win)
    end,
    group = "LeapIlluminate",
})
api.nvim_create_autocmd("User", {
    pattern = { "LeapPatternPost" },
    callback = function()
        _G.leapfirst = true
    end,
    group = "LeapIlluminate",
})

api.nvim_create_autocmd("User", {
    pattern = { "ArrowUpdate" },
    callback = function()
        vim.cmd("NvimTreeRefresh")
    end,
})

api.nvim_create_autocmd("QuitPre", {
    callback = function()
        if not utils.fold_method_diff() then
            vim.cmd([[silent! mkview!]])
        end
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
    pattern = { "noice" },
    callback = function()
        api.nvim_create_autocmd("BufEnter", {
            once = true,
            callback = function()
                vim.keymap.set("n", "K", "3k", { buffer = true })
            end,
        })
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "git" },
    callback = function()
        vim.b.miniindentscope_disable = true
        vim.cmd("setlocal syntax=ON")
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    end,
})

api.nvim_create_autocmd("TabEnter", {
    callback = function()
        local tabnum = vim.fn.tabpagenr()
        if tabnum ~= 1 then
            vim.g.neovide_underline_stroke_scale = 0
            vim.b.miniindentscope_disable = true
        else
            vim.g.neovide_underline_stroke_scale = 1.5
        end
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit" },
    callback = function()
        local buf
        vim.api.nvim_create_autocmd("CursorMoved", {
            once = true,
            callback = function()
                vim.cmd("norm! gg")
                FeedKeys("a", "m")
                vim.cmd("setlocal syntax=ON")
                vim.schedule(function()
                    buf = vim.api.nvim_get_current_buf()
                end)
            end,
        })
        vim.defer_fn(function()
            vim.keymap.set({ "n", "i" }, "<CR>", function()
                vim.schedule(function()
                    if vim.bo.filetype == "lazyterm" then
                        FeedKeys("<C-v><c-l>", "n")
                    end
                end)
                vim.defer_fn(function()
                    utils.refresh_last_commit()
                    utils.update_diff_file_count()
                    utils.set_git_winbar()
                end, 50)

                vim.cmd("w")
                if vim.api.nvim_get_mode().mode == "i" then
                    FeedKeys("<esc>", "n")
                end
                vim.cmd(string.format("bw! %d", buf))
                local result = vim.system(
                    { "git", "commit", "--cleanup=strip", "-F", "./.git/COMMIT_EDITMSG" },
                    nil,
                    function(result)
                        if result.code == 0 then
                            vim.notify(result.stdout, vim.log.levels.INFO)
                        end
                    end
                )
            end, { buffer = true })
        end, 100)
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = { "undotree", "diff" },
    callback = function()
        vim.cmd("setlocal syntax=ON")
    end,
})

api.nvim_create_autocmd({ "TermEnter", "BufEnter" }, {
    callback = function()
        if vim.opt.buftype:get() == "terminal" then
            vim.cmd(":startinsert")
        end
    end,
})

api.nvim_create_autocmd("TermOpen", {
    callback = function(args)
        local opts = { buffer = 0 }
        if vim.endswith(args.file, [[#1]]) then
            vim.keymap.set("t", "<Tab>", [[<C-\><C-n><Tab>]], { remap = true, buffer = 0 })
            vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        end
        vim.keymap.set("t", "<C-d>", [[<C-\><C-w>]], opts)
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = {
        "qf",
    },
    callback = function()
        vim.defer_fn(function()
            vim.keymap.set("n", "<cr>", "<cr>", { buffer = true })
        end, 100)
    end,
})

api.nvim_create_autocmd("CmdwinEnter", {
    callback = function()
        vim.keymap.set("n", "<cr>", "<cr>", { buffer = true })
    end,
})

api.nvim_create_autocmd("FileType", {
    pattern = {
        "saga_codeaction",
        "txt",
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "vim",
        "neotest-output-panel",
        "toggleterm",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", function()
            _G.no_animation()
            _G.hide_cursor(function() end)
            return "<cmd>close<cr>"
        end, { expr = true, buffer = event.buf, silent = true })
    end,
})

api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:n",
    callback = function()
        local len = vim.g.neovide_cursor_animation_length
        if len ~= 0 then
            vim.g.neovide_cursor_animation_length = 0
        end
    end,
})

api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
        local is_enabled = require("noice.ui")._attached
        if not is_enabled then
            vim.schedule(function()
                vim.cmd("Noice enable")
            end)
        end
        vim.defer_fn(function()
            vim.o.scrolloff = 6
        end, 20)
        local len = vim.g.neovide_cursor_animation_length
        if len ~= 0 then
            vim.g.neovide_cursor_animation_length = 0
        end
    end,
})

_G.glance_buffer = {}
api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = utils.set_glance_keymap,
})

api.nvim_create_autocmd("WinResized", {
    pattern = "*",
    callback = function()
        utils.checkSplitAndSetLaststatus()
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
        if tabnum == 1 then
            vim.cmd([[silent! mkview!]])
        end
        vim.defer_fn(function()
            utils.refresh_last_commit()
            utils.update_diff_file_count()
            utils.set_git_winbar()
        end, 10)
        ---@diagnostic disable-next-line: undefined-field
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

---@diagnostic disable: undefined-global
-- bootstrap lazy.nvim, LazyVim and your plugins
api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
        end
    end,
    once = true,
})

api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
        utils.set_winbar()
        utils.set_git_winbar()
    end,
})

api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = utils.set_glance_winbar,
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
    callback = function()
        if vim.wo.foldmethod == "diff" and vim.fn.tabpagenr() == 1 then
            print("foldmethod diff")
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
        local tabcount = #vim.api.nvim_list_tabpages()
        if tabcount > 1 then
            vim.cmd("tabclose! " .. 2)
        end
    end,
})

api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionLoadPost",
    callback = function()
        local ok, gs = pcall(require, "gitsigns")
        if ok then
            if vim.g.Base_commit ~= "" then
                gs.change_base(vim.g.Base_commit, true)
                -- when nvim start at first time, gitsigns may choose index as base
                vim.defer_fn(function()
                    utils.update_diff_file_count()
                    gs.change_base(vim.g.Base_commit, true)
                end, 200)
                vim.defer_fn(function()
                    utils.update_diff_file_count()
                    gs.change_base(vim.g.Base_commit, true)
                end, 500)
            else
                vim.defer_fn(function()
                    utils.refresh_last_commit()
                    utils.update_diff_file_count()
                    utils.set_git_winbar()
                end, 200)
                gs.reset_base(vim.g.Base_commit, true)
            end
        end
        require("nvim-tree.api").tree.toggle({ focus = false })
        vim.defer_fn(function()
            -- because arrow does not update when changing sessions
            vim.cmd("NvimTreeRefresh")
            ---@diagnostic disable-next-line: undefined-field
            pcall(_G.indent_update)
        end, 100)
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(args)
        if args.data.err then
            return
        end
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
    end,
})

api.nvim_create_autocmd("BufWinEnter", {
    callback = utils.set_oil_winbar,
})

api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    callback = utils.set_git_winbar,
})

api.nvim_create_autocmd("User", {
    pattern = "GitSignsChanged",
    callback = function()
        vim.defer_fn(function()
            utils.update_diff_file_count()
            utils.set_git_winbar()
        end, 300)
    end,
})

api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionDelete",
    callback = function(args)
        local from_path = args.data.from
        local bufnr = vim.fn.bufnr(from_path)
        pcall(function()
            local win = vim.fn.win_findbuf(bufnr)[1]
            api.nvim_win_call(win, function()
                vim.cmd("BufDel")
            end)
        end)
        pcall(function()
            vim.defer_fn(function()
                MiniFiles.close()
            end, 5)
            vim.cmd("NvimTreeRefresh")
        end)
    end,
})

vim.lsp.set_log_level("off")

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
