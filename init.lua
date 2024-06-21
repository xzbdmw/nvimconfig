require("config.lazy")
local utils = require("config.utils")

vim.uv = vim.loop
_G.CI = 0.04
vim.cmd("syntax off")

local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.hover = "gh"

vim.api.nvim_create_augroup("LeapIlluminate", {})

-- sync system clipboard while yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        local v = vim.v.event
        local regcontents = v.regcontents
        vim.schedule(function()
            vim.fn.setreg("+", regcontents)
        end)
    end,
})

-- sync system clipboard to vim clipboard
vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
        local loaded_content = vim.fn.getreg("+")
        if loaded_content ~= "" then
            vim.fn.setreg('"', loaded_content)
        end
    end,
})

-- Not needed because delete also trigger TextYankPost
-- vim.api.nvim_create_autocmd("TextChanged", {
--     callback = function()
--         if vim.system == nil then
--             return
--         end
--         vim.schedule(function()
--             local s = vim.fn.getreg('"')
--             vim.system({ "echo", s, "| pbcopy" })
--         end)
--     end,
-- })

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "TelescopePreviewerLoaded",
    callback = function(data)
        local winid = data.data.winid
        vim.wo[winid].number = true
        vim.defer_fn(function()
            pcall(function()
                require("treesitter-context").context_force_update(vim.api.nvim_win_get_buf(winid), winid)
                ---@diagnostic disable-next-line: undefined-field
                pcall(_G.indent_update, winid)
            end)
        end, 5)
    end,
})
_G.leapjump = false

vim.api.nvim_create_autocmd("User", {
    pattern = { "LeapSelectPre", "LeapJumpRepeat" },
    callback = function()
        _G.leapjump = true
        local buf = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        require("illuminate.engine").refresh_references(buf, win)
    end,
    group = "LeapIlluminate",
})
vim.api.nvim_create_autocmd("User", {
    pattern = { "LeapPatternPost" },
    callback = function()
        _G.leapfirst = true
    end,
    group = "LeapIlluminate",
})

vim.api.nvim_create_autocmd("User", {
    pattern = { "ArrowUpdate" },
    callback = function()
        vim.cmd("NvimTreeRefresh")
    end,
})

vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        vim.cmd([[silent! mkview!]])
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "undotree", "diff" },
    callback = function()
        vim.cmd([[syntax on]])
    end,
})

-- nvim-cmp
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    pattern = "*:n",
    callback = function()
        _G.has_moved_up = false
    end,
})

vim.api.nvim_create_autocmd({ "TermEnter", "BufEnter" }, {
    callback = function()
        if vim.opt.buftype:get() == "terminal" then
            vim.cmd(":startinsert")
        end
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(args)
        local opts = { buffer = 0 }
        if vim.endswith(args.file, [[#1]]) then
            vim.keymap.set("t", "<Tab>", [[<C-\><C-n><Tab>]], { remap = true, buffer = 0 })
            vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        end
        vim.keymap.set("t", "<C-d>", [[<C-\><C-w>]], opts)
    end,
})

-- walkaroud for incremental selection
vim.api.nvim_create_augroup("cmdwin_treesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "qf",
    },
    command = "TSBufDisable incremental_selection",
})

vim.api.nvim_create_autocmd("FileType", {
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

vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:n",
    callback = function()
        local len = vim.g.neovide_cursor_animation_length
        if len ~= 0 then
            vim.g.neovide_cursor_animation_length = 0
        end
    end,
})

_G.glance_buffer = {}
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = utils.set_glance_keymap,
})

vim.api.nvim_create_autocmd("WinResized", {
    pattern = "*",
    callback = function()
        utils.checkSplitAndSetLaststatus()
    end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = {
        "/Users/xzb/.rustup/toolchains/**/*.rs",
        "/Users/xzb/.cargo/**/*.rs",
        "/opt/homebrew/Cellar/**/*.go",
    },
    command = "setlocal nomodifiable",
})

vim.api.nvim_create_user_command("Ut", function()
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_cmd(vim.api.nvim_parse_cmd("UndotreeToggle", {}), {})
    utils.setUndotreeWinSize()
end, { desc = "load undotree" })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        vim.cmd([[silent! mkview!]])
        ---@diagnostic disable-next-line: undefined-field
        pcall(_G.indent_update)
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            -- Don't save while there's any 'nofile' buffer open.
            if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
                return
            end
        end
        require("session_manager").save_current_session()
    end,
})

---@diagnostic disable: undefined-global
-- bootstrap lazy.nvim, LazyVim and your plugins
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(_)
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = utils.set_winbar,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = utils.set_glance_winbar,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "*",
    callback = function()
        vim.cmd([[silent! mkview!]])
    end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "fzf" then
            return
        else
            vim.cmd([[silent! loadview]])
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    pattern = "*",
    callback = function()
        vim.g.gd = true
        vim.defer_fn(function()
            vim.g.gd = false
        end, 100)
    end,
})

vim.cmd([[set viewoptions-=curdir]])

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionLoadPost",
    callback = function()
        local tree = require("nvim-tree.api").tree
        pcall(tree.toggle, { focus = false })
        vim.defer_fn(function()
            vim.cmd("NvimTreeRefresh")
            ---@diagnostic disable-next-line: undefined-field
            pcall(_G.indent_update)
        end, 100)
    end,
})

vim.api.nvim_create_autocmd("User", {
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
                    vim.cmd("bw " .. bufnr)
                end
            end
            vim.cmd("NvimTreeRefresh")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = utils.set_oil_winbar,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionDelete",
    callback = function(args)
        local from_path = args.data.from
        local bufnr = vim.fn.bufnr(from_path)
        pcall(function()
            local win = vim.fn.win_findbuf(bufnr)[1]
            vim.api.nvim_win_call(win, function()
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
-- vim.api.nvim_create_autocmd("CursorMoved", {
--     callback = function()
--         if vim.g.gd then
--             if ST ~= nil then
--                 Time(ST, "CursorMoved")
--             end
--         end
--     end,
-- })

-- local origin = vim.lsp.util.jump_to_location
-- vim.lsp.util.jump_to_location = function(location, offset_encoding, reuse_win)
--     ST = vim.uv.hrtime()
--     origin(location, offset_encoding, reuse_win)
-- end
