local opts = { noremap = true, silent = true }
local utils = require("config.utils")

local keymap = vim.keymap.set

keymap({ "n", "i" }, "<D-s>", function()
    WT = vim.uv.hrtime()
    keymap({ "n" }, "<f16>", "k", opts)
    vim.defer_fn(function()
        keymap({ "n", "i" }, "<f16>", "<cmd>ToggleTerm<CR>", opts)
    end, 100)
    vim.cmd("write")
end, opts)

keymap("n", "<leader>W", function()
    local origin = vim.o.eventignore
    vim.o.eventignore = "all"
    vim.cmd("wall")
    vim.o.eventignore = origin
end, opts)

keymap({ "n" }, "g;", function()
    return "g;zz"
end, { expr = true, remap = true })

keymap({ "n" }, "gi", function()
    return "gi<C-o>zz"
end, { expr = true, remap = true })

keymap({ "n" }, "g,", function()
    return "g,zz"
end, { expr = true })

keymap({ "n" }, "/", function()
    utils.once(function()
        vim.api.nvim_exec_autocmds("User", {
            pattern = "SearchBegin",
        })
    end)
    utils.search("/")
end, opts)

keymap({ "n" }, "?", function()
    utils.search("?")
end, opts)

keymap({ "c" }, "<c-n>", "<c-g>", opts)
keymap({ "c" }, "<c-p>", "<c-t>", opts)

keymap({ "n" }, "<leader>w", function()
    vim.cmd("write")
end, opts)

_G.has_diagnostic = false
keymap("n", "<leader>ud", function()
    if _G.has_diagnostic then
        vim.diagnostic.config({ virtual_text = false })
        _G.has_diagnostic = false
    else
        vim.diagnostic.config({
            virtual_text = {
                prefix = "",
                source = "if_many",
                spacing = 2,
            },
        })
        _G.has_diagnostic = true
    end
end, opts)

keymap("i", "<c-x><c-o>", function()
    local cmp = require("cmp")
    if cmp.visible() then
        cmp.close()
    end
    require("cmp").complete({
        config = {
            sources = {
                {
                    name = "rg",
                },
            },
        },
    })
end)

keymap("i", "<c-x><c-y>", function()
    local cmp = require("cmp")
    if cmp.visible() then
        cmp.close()
    end
    require("cmp").complete({
        config = {
            sources = {
                {
                    name = "cmp_yanky",
                },
            },
        },
    })
end)

keymap("i", "<c-x><c-p>", function()
    local cmp = require("cmp")
    if cmp.visible() then
        cmp.close()
    end
    require("cmp").complete({
        config = {
            sources = {
                {
                    name = "dictionary",
                },
            },
        },
    })
end)

keymap("o", "h", function()
    return utils.operator_mode_lh("before")
end, { expr = true })

keymap("o", "l", function()
    return utils.operator_mode_lh("after")
end, { expr = true })

keymap("i", "<c-x><right>", function()
    local cmp = require("cmp")
    if cmp.visible() then
        cmp.close()
    end
    cmp.complete({
        config = {
            sources = {
                {
                    name = "buffer-lines",
                },
            },
        },
    })
end)

keymap("i", "<c-x><c-c>", function()
    vim.g.copilot_enable = true
    local cmp = require("cmp")
    if cmp.visible() then
        cmp.close()
    end
    cmp.complete({
        config = {
            sources = {
                {
                    name = "copilot",
                },
            },
        },
    })
end)

keymap("n", "<leader>h", function()
    FeedKeys("0", "n")
    vim.fn.winrestview({ leftcol = 0 })
    vim.schedule(function()
        local col = api.nvim_win_get_cursor(0)[2]
        local char = api.nvim_get_current_line():sub(col + 1, col + 1)
        if char == " " then
            FeedKeys("w", "n")
        end
    end)
end, opts)

keymap({ "n", "i" }, "<f16>", "<cmd>ToggleTerm<CR>", opts) -- <D-k>
keymap({ "n" }, "<leader>rr", function()
    require("nvim-tree.actions.reloaders").reload_explorer()
    if require("nvim-tree.explorer.filters").config.filter_git_clean then
        require("nvim-tree.api").tree.expand_all()
    end
end, opts)
keymap("n", "<C-m>", "%", opts)
keymap("n", "g.", "`.", opts)
keymap("n", "o", function()
    _G.no_delay(0)
    return "o"
end, { expr = true, remap = true })
keymap("n", "O", function()
    _G.no_delay(0)
    return "O"
end, { expr = true })

keymap("n", "i", function()
    _G.set_cursor_animation(0.0)
    vim.defer_fn(function()
        _G.set_cursor_animation(_G.CI)
    end, 10)
    return "i"
end, { expr = true })

keymap("n", "a", function()
    _G.set_cursor_animation(0.0)
    vim.defer_fn(function()
        _G.set_cursor_animation(_G.CI)
    end, 10)
    return "a"
end, { expr = true })

keymap("n", "I", function()
    vim.defer_fn(function()
        _G.set_cursor_animation(_G.CI)
    end, 100)
    return "I"
end, { expr = true })

keymap("n", "<leader><leader>g", function()
    vim.notify(vim.g.Base_commit_msg, vim.log.levels.INFO)
end, opts)

keymap("n", "<right>", "]", { remap = true })
keymap("n", "<left>", "[", { remap = true })

keymap("o", "f", "t", opts)
keymap("x", "f", "t", opts)
keymap("x", "F", "T", opts)
keymap("o", "F", "T", opts)

keymap("n", "A", function()
    vim.defer_fn(function()
        _G.set_cursor_animation(_G.CI)
    end, 100)
    return "A"
end, { expr = true })

keymap("n", "C", '"_C', opts)
keymap({ "x", "n" }, "c", function()
    _G.no_animation(_G.CI)
    return '"_c'
end, { expr = true })
keymap("o", "c", function()
    _G.no_animation(_G.CI)
    return "c"
end, { expr = true })

keymap("i", "<c-a>", function()
    _G.no_animation(_G.CI)
    return "<c-a>"
end, { expr = true })

keymap("n", "<c-a>", "A", { remap = true })
keymap("n", "<leader>", "", opts)

local darker = false
keymap("n", "<leader>uc", function()
    if darker then
        api.nvim_set_hl(0, "@spell.go", { fg = "#6d6b6b" })
        api.nvim_set_hl(0, "Comment", { fg = "#6d6b6b" })
        api.nvim_set_hl(0, "@spell.rust", { fg = "#6d6b6b" })
        darker = false
    else
        api.nvim_set_hl(0, "@spell.go", { fg = "#364E57" })
        api.nvim_set_hl(0, "@spell.rust", { fg = "#364E57" })
        api.nvim_set_hl(0, "Comment", { fg = "#364E57" })
        darker = true
    end
end, opts)

keymap("i", "<C-d>", function()
    _G.no_animation()
    return "<C-w>"
end, { expr = true })

keymap("n", "`", function()
    vim.g.gd = true
    vim.defer_fn(function()
        vim.g.gd = false
    end, 100)
    _G.no_animation()
    return "<cmd>e #<cr>"
end, { expr = true })

-- various textobjects
keymap({ "o", "x" }, "u", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>")
keymap({ "o", "x" }, "n", "<cmd>lua require('various-textobjs').nearEoL()<CR>")

keymap("n", "<leader>cm", "<cmd>messages clear<CR>", opts)
keymap("n", "<leader>M", function()
    vim.g.skip_noice = not vim.g.skip_noice
end, opts)
keymap("i", "<f12>", "<cmd>messages clear<CR>", opts)

keymap({ "n" }, "<C-n>", function()
    vim.cmd("MCstart")
    FeedKeys("n", "m")
end)

keymap("n", "D", "d$", opts)
keymap("n", "<C-i>", "<C-i>", opts)
keymap({ "n", "x", "o" }, "L", "$", opts)

keymap("c", "<d-s>", function()
    local function escape_magic(s)
        return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?\\])", "%%%1"))
    end
    local original = vim.fn.getcmdline()
    local filetype = vim.bo.filetype
    local w = original:gsub(escape_magic(".\\{-}"), " ")
    FeedKeys("<esc>", "m")
    vim.schedule(function()
        require("custom.telescope-pikers").prettyGrepPicker("egrepify", w, filetype)
    end)
end, opts)

keymap("c", "<space>", function()
    local mode = vim.fn.getcmdtype()
    if mode == "?" or mode == "/" then
        return [[.\{-}]]
    else
        return " "
    end
end, { expr = true })

keymap({ "n", "v" }, "<D-=>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end, opts)
keymap({ "n", "v" }, "<D-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end, opts)
keymap({ "n", "v" }, "<D-0>", "<cmd>lua vim.g.neovide_scale_factor = 1<CR>")
keymap("n", "<leader><c-r>", "<cmd>e!<cr>", opts)

keymap("n", "*", function()
    vim.g.type_star = true
    vim.defer_fn(function()
        vim.g.type_star = false
    end, 100)
    vim.cmd("keepjumps normal! mi*`i")
    _G.star_search = vim.fn.getreg("/")
    require("hlslens").start()
end)

keymap("n", "<leader>uq", function()
    if vim.v.hlsearch ~= 0 then
        vim.cmd("nohlsearch")
        require("hlslens").exportLastSearchToQuickfix()
    end
    vim.cmd("Trouble qflist toggle focus=false")
end, opts)

keymap("n", "<leader>q", "<cmd>qall!<CR>", opts)
keymap({ "n", "i", "c", "t" }, "<f17>", "<cmd>qall!<CR>", opts)
keymap("n", "Y", "y$", opts)

keymap("v", "<up>", ":MoveBlock(-1)<CR>", opts)
keymap("v", "<down>", ":MoveBlock(1)<CR>", opts)
keymap("n", "<up>", "<A-k>", { remap = true, desc = "Move Up" })
keymap("n", "<down>", "<A-j>", { remap = true, desc = "Move Down" })
keymap("v", "<up>", "<A-k>", { remap = true, desc = "Move Up" })
keymap("v", "<down>", "<A-j>", { remap = true, desc = "Move Down" })

keymap("n", "gs", function()
    require("treesitter-context").go_to_context(vim.v.count1)
    require("config.utils").adjust_view(0, 4)
end, opts)

keymap({ "n", "v" }, "<f13>", vim.lsp.buf.signature_help, opts)

keymap("n", "<leader>`", "<cmd>tabnext<cr>", opts)

keymap("n", "<leader>uu", function()
    local is_enabled = require("noice.ui")._attached
    if is_enabled then
        return "<cmd>Noice disable<CR>"
    else
        return "<cmd>Noice enable<CR>"
    end
end, { expr = true })

keymap("n", "<leader>sd", function()
    if vim.g.Base_commit == "" then
        vim.cmd("DiffviewOpen")
    else
        vim.cmd("DiffviewOpen " .. vim.g.Base_commit)
    end
end, opts)

keymap("n", "<leader>sf", function()
    vim.cmd("DiffviewFileHistory %")
end, opts)

keymap("n", "<leader>cd", function()
    local tabcount = #vim.api.nvim_list_tabpages()
    if tabcount > 1 then
        vim.cmd("tabclose! " .. 2)
    end
end, opts)

keymap("n", "za", function()
    local is_comment = vim.fn.foldclosed(vim.fn.line("."))
    if is_comment ~= -1 then
        return "zo"
    else
        FeedKeys("m6", "n")
        FeedKeys("zfai", "m")
        FeedKeys("`6", "n")
    end
end, { remap = true, expr = true })

keymap("n", "<leader>sm", function()
    vim.cmd("messages")
end, opts)

utils.load_appropriate_theme()

-- dot trick
keymap("n", "<space><esc>", ".", opts)

-- mark trick
keymap("n", "<space>;", "m6A;<esc>`6", opts)

keymap("n", "<space>)", "m6A)<esc>`6", opts)
keymap("n", "<space>;", "m6A,<esc>`6", opts)
keymap("n", "<D-w>", "<cmd>close<CR>", opts)

keymap("n", "<D-2>", function()
    local cur_win = api.nvim_get_current_win()
    local wins = api.nvim_list_wins()
    for _, win in ipairs(wins) do
        if win == cur_win then
            goto continue
        end
        if api.nvim_win_is_valid(win) and api.nvim_win_get_config(win).relative == "" then
            api.nvim_win_close(win, true)
        end
        ::continue::
    end
end, opts)

keymap("n", "gq", function()
    if vim.fn.reg_recording() == "" and vim.fn.reg_executing() == "" then
        return "qa"
    else
        return "q"
    end
end, { expr = true })

keymap("i", "<space>", function()
    if vim.fn.reg_recording() == "" and vim.fn.reg_executing() == "" then
        utils.insert_mode_space()
    end
    return "<space>"
end, { expr = true })

keymap("i", "<Tab>", function()
    utils.insert_mode_tab()
end, opts)

keymap("x", "V", function()
    vim.schedule(function()
        api.nvim_exec_autocmds("User", {
            pattern = "v_V",
        })
        _G.indent_update()
    end)
    return "V"
end, { expr = true })

keymap("n", "<Tab>", function()
    utils.normal_tab()
end, { desc = "swicth window" })

keymap("x", "<C-r>", '"', opts)

keymap("i", "<D-v>", function()
    utils.insert_paste()
end)

keymap({ "n", "o" }, "0", "^", opts)

keymap("n", "<D-a>", "ggVG", opts)

keymap({ "n" }, "q", function()
    if vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "" then
        FeedKeys("q", "n")
    else
        utils.close_win()
    end
end)

keymap("n", "<leader>vr", function()
    if utils.has_filetype("NvimTree") then
        return "<d-1><cmd>vsp<CR><c--><c--><c-->"
    else
        return "<cmd>vsp<CR><c--><c--><c-->"
    end
end, { expr = true, remap = true })

keymap("n", "<leader><leader>n", function()
    vim.wo.number = not vim.wo.number
    if vim.fn.getwininfo(api.nvim_get_current_win())[1].terminal == 0 then
        if vim.wo.signcolumn == "no" then
            vim.wo.signcolumn = "yes"
        else
            vim.wo.signcolumn = "no"
        end
    end
end, opts)

keymap("n", "<leader>vd", "<cmd>sp<CR>")
keymap("n", "<leader><left>", function()
    return "<C-w>H"
end, { expr = true })
keymap("n", "<leader><right>", function()
    return "<C-w>L"
end, { expr = true })
keymap("n", "<leader><down>", function()
    return "<C-w>J"
end, { expr = true })
keymap("n", "<leader><up>", function()
    return "<C-w>K"
end, { expr = true })
keymap({ "n", "v" }, "J", "4j", opts)
keymap({ "n", "v" }, "K", "4k", opts)
keymap("n", "<C-b>", "<C-v>", opts)
keymap("i", "<c-b>", "<S-left>", opts)
keymap("i", "<c-f>", "<S-right>", opts)
-- don't messy up indent
keymap("i", "<C-r>", function()
    utils.insert_C_R()
    return "<C-r><C-o>"
end, { expr = true })

keymap("n", "<D-z>", "u", opts)

keymap("i", "<D-z>", "<C-o>u", opts)

keymap("n", "e", function()
    return "ea"
end, { expr = true })

keymap("n", "E", function()
    return "Ea"
end, { expr = true })

keymap("n", "<leader>j", function()
    _G.set_cursor_animation(0)
    vim.defer_fn(function()
        _G.set_cursor_animation(_G.CI)
    end, 100)
    return "f{a<CR>"
end, { expr = true, remap = true })

keymap("n", "<M-w>", "<c-w>", opts)
keymap("n", "<leader>k", "<C-i>", opts)
keymap("n", "<d-w>", "<c-w>", opts)
keymap("n", "mm", "%", opts)

-- Command line mapping
keymap("c", "<C-d>", "<C-w>", opts)
keymap("c", "<d-v>", '<c-r>"', opts)

keymap("c", "<C-p>", "<up>", opts)
keymap("c", "<C-n>", "<down>", opts)
keymap("c", "<c-f>", "<S-Right>", opts)
keymap("c", "<d-w>", "<c-f>", opts)
keymap("c", "<c-b>", "<S-Left>", opts)
keymap("c", "<c-a>", "<Home>", opts)

-- Terminal mapping
keymap("t", "<c-f>", function()
    _G.no_animation(_G.CI)
    local filetype = vim.bo.filetype
    if filetype == "lazyterm" then
        return "<M-right>"
    else
        return "<c-f>"
    end
end, { expr = true })

keymap("t", "<right>", function()
    _G.no_animation(_G.CI)
    return "<right>"
end, { expr = true })

keymap("t", "<c-u>", function()
    _G.no_animation(_G.CI)
    return "<c-u>"
end, { expr = true })

keymap("t", "<BS>", function()
    _G.no_animation(_G.CI)
    return "<BS>"
end, { expr = true })

keymap("t", "<c-d>", function()
    _G.no_animation(_G.CI)
    return "<c-d>"
end, { expr = true })

keymap("t", "<c-b>", function()
    _G.no_animation(_G.CI)
    return "<M-left>"
end, { expr = true })

keymap("t", "<D-v>", function()
    local next_char_code = 48
    local next_char = vim.fn.nr2char(next_char_code)
    return '<C-\\><C-N>"' .. next_char .. "pi"
end, { expr = true })

keymap("t", "<c-->", function()
    require("smart-splits").resize_left()
end, opts)
keymap("t", "<c-=>", function()
    require("smart-splits").resize_right()
end, opts)
keymap("t", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap("t", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })

keymap("x", "za", "zf", opts)
keymap("n", "zu", "zfu", { remap = true })
keymap({ "n", "i" }, "<f18>", "<C-i>", opts)

--Nvimtree workaround
keymap("n", "<C-f>", function()
    local winnid = require("config.utils").filetype_windowid("NvimTree")
    vim.api.nvim_set_current_win(winnid)
end, opts)
keymap("n", "<leader>cr", function()
    local bufnr = api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(bufnr)
    require("nvim-tree").change_root(path, bufnr)
end, opts)
keymap({ "n" }, "<leader>fn", '<cmd>lua require("nvim-tree.api").fs.create()<CR>', { desc = "create new file" })

keymap("n", "<2-LeftMouse>", "<leader>d", { remap = true })
keymap("n", "<leader>cc", function()
    Open_git_commit()
end, opts)
keymap("n", "V", function()
    keymap("v", "J", "j", { buffer = 0 })
    keymap("v", "K", "k", { buffer = 0 })
    vim.defer_fn(function()
        keymap("v", "J", "4j", { buffer = 0 })
        keymap("v", "K", "4k", { buffer = 0 })
    end, 150)
    return "V"
end, { expr = true })

keymap("x", "<bs>", function()
    FeedKeys("holo", "t")
end, opts)

keymap({ "s", "i", "n" }, "<C-7>", function()
    for _, win in pairs(api.nvim_list_wins()) do
        local success, win_config = pcall(api.nvim_win_get_config, win)
        if success and win_config.relative ~= "" then
            print(vim.inspect(win))
            print(vim.inspect(win_config))
            api.nvim_win_close(win, true)
        end
    end
end, opts)

keymap("n", "]q", function()
    vim.cmd("cnext")
end, opts)
keymap("n", "[q", function()
    vim.cmd("cprev")
end, opts)

keymap("n", "zz", function()
    utils.adjust_view(0, 3)
end, opts)

keymap("n", "<leader>d", function()
    ST = vim.uv.hrtime()
    if api.nvim_win_get_config(api.nvim_get_current_win()).zindex == 10 then
        vim.lsp.buf.definition()
    else
        vim.cmd("Glance definitions")
    end
end)

keymap("n", "gd", function()
    vim.lsp.buf.definition()
end)

local del = vim.keymap.del
del("n", "<leader>w-")
del("n", "<leader>ww")
del("n", "<leader>wd")
del("t", "<esc><esc>")
del("n", "<leader>fn")
del("n", "<leader>w|")
del("n", "gsh")
del("n", "gshn")
del("n", "gshl")
