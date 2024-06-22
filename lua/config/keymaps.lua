local opts = { noremap = true, silent = true }
local utils = require("config.utils")

local keymap = vim.keymap.set

keymap({ "n", "i" }, "<D-s>", function()
    vim.cmd("write")
end, opts)

keymap({ "n" }, "<leader>w", function()
    vim.cmd("write")
end, opts)

keymap("i", "<c-g>", function()
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
keymap("i", "<D-g>", function()
    require("cmp").complete({
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
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
        if char == " " then
            FeedKeys("w", "n")
        end
    end)
end, opts)

-- <D-k>
keymap({ "n", "i" }, "<f16>", "<cmd>ToggleTerm<CR>", opts)
keymap({ "n" }, "<leader>rr", "<cmd>NvimTreeRefresh<CR>", opts)
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
    vim.g.neovide_cursor_animation_length = 0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 10)
    return "i"
end, { expr = true })
keymap("n", "a", function()
    vim.g.neovide_cursor_animation_length = 0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 10)
    return "a"
end, { expr = true })

keymap("n", "I", function()
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 100)
    return "I"
end, { expr = true })

keymap("n", "A", function()
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 100)
    return "A"
end, { expr = true })

keymap({ "v", "n" }, "c", function()
    _G.no_animation(_G.CI)
    return '"_c'
end, { expr = true })

keymap("o", "c", function()
    _G.no_animation(_G.CI)
    return "c"
end, { expr = true })

keymap("i", "<C-d>", function()
    _G.no_animation()
    return "<C-w>"
end, { expr = true })

keymap("n", "`", function()
    vim.g.gd = true
    _G.no_animation()
    return "<cmd>e #<cr>"
end, { expr = true })

-- various textobjs
keymap({ "o", "x" }, "u", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>")
keymap({ "o", "x" }, "im", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>")
keymap({ "o", "x" }, "am", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>")
keymap({ "o", "x" }, "n", "<cmd>lua require('various-textobjs').nearEoL()<CR>")

keymap("n", "<leader>cm", "<cmd>messages clear<CR>", opts)

keymap({ "n" }, "<C-n>", function()
    vim.g.cmp_completion = false
    vim.cmd("MCstart")
    FeedKeys("n", "m")
end)

keymap({ "x" }, "<C-n>", function()
    vim.g.cmp_completion = false
    vim.cmd("MCstart")
end)

keymap("n", "D", "d$", opts)
keymap("n", "<C-i>", "<C-i>", opts)
keymap("n", "Q", "qa", opts)
keymap({ "n", "x", "o" }, "L", "$", opts)

keymap({ "n", "v" }, "<D-=>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end, opts)
keymap({ "n", "v" }, "<D-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end, opts)
keymap({ "n", "v" }, "<D-0>", "<cmd>lua vim.g.neovide_scale_factor = 1<CR>")

keymap("n", "*", function()
    if not vim.bo.filetype == "noice" then
        utils.search_to_qf()
    end
    return "*"
end, { expr = true })

-- keymap("n", "<leader>cq", function()
--     vim.fn.setqflist({}, "r")
-- end)

keymap("n", "<leader>q", "<cmd>qall!<CR>", opts)
keymap("n", "<f17>", "<cmd>qall!<CR>", opts)
keymap("n", "Y", "y$", opts)

keymap("v", "<up>", ":MoveBlock(-1)<CR>", opts)
keymap("v", "<down>", ":MoveBlock(1)<CR>", opts)
keymap("n", "<up>", "<A-k>", { remap = true, desc = "Move Up" })
keymap("n", "<down>", "<A-j>", { remap = true, desc = "Move Down" })
keymap("v", "<up>", "<A-k>", { remap = true, desc = "Move Up" })
keymap("v", "<down>", "<A-j>", { remap = true, desc = "Move Down" })

keymap("n", "gs", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, opts)

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
    vim.g.neovide_underline_stroke_scale = 0
    vim.cmd("DiffviewOpen")
end, opts)

keymap("n", "<leader>cd", function()
    vim.g.neovide_underline_stroke_scale = 2
    pcall(function()
        vim.cmd("tabclose")
    end)
end, opts)

keymap("n", "<leader>ur", function()
    vim.o.relativenumber = vim.o.relativenumber == false and true or false
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

keymap("i", "<space>", function()
    utils.insert_mode_space()
end, opts)

keymap("i", "<Tab>", function()
    utils.insert_mode_tab()
end, opts)

keymap("n", "<Tab>", function()
    utils.normal_tab()
end, { desc = "swicth window" })

keymap("x", "<C-r>", '"', opts)

keymap({ "n", "o" }, "0", "^", opts)

keymap("n", "<D-a>", "ggVG", opts)

keymap({ "n" }, "q", function()
    utils.close_win()
end)

keymap("n", "<leader>vr", "<cmd>vsp<CR>")
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
keymap("i", "<D-v>", function()
    return '<C-g>u<C-r><C-o>"'
end, { expr = true })

-- don't messy up indent
keymap("i", "<C-r>", "<C-r><C-o>", opts)

keymap("n", "<D-z>", "u", opts)
keymap("i", "<D-z>", "<C-o>u", opts)

keymap("n", "<leader>j", function()
    vim.g.neovide_cursor_animation_length = 0.0
    vim.defer_fn(function()
        vim.g.neovide_cursor_animation_length = _G.CI
    end, 100)
    return "f{a<CR>"
end, { expr = true, remap = true })

keymap("n", "<M-w>", "<c-w>", opts)
keymap("n", "<leader>k", "<C-i>", opts)

-- Command line mapping
keymap("c", "<C-d>", "<C-w>", opts)
keymap("c", "<C-p>", "<up>", opts)
keymap("c", "<C-n>", "<down>", opts)
keymap("c", "<c-f>", "<S-Right>", opts)
keymap("c", "<c-b>", "<S-Left>", opts)
keymap("c", "<c-a>", "<Home>", opts)
keymap("c", "<D-v>", "<C-r>+<CR>", opts)

-- Terminal mapping
keymap("t", "<c-f>", "<M-right>", opts)
keymap("t", "<c-b>", "<M-left>", opts)
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
keymap("n", "<C-f>", "<cmd>NvimTreeFocus<CR>")
keymap({ "n" }, "<leader>fn", '<cmd>lua require("nvim-tree.api").fs.create()<CR>', { desc = "create new file" })

keymap("n", "V", function()
    keymap("v", "J", "j", { buffer = 0 })
    vim.defer_fn(function()
        keymap("v", "J", "4j", { buffer = 0 })
    end, 150)
    return "V"
end, { expr = true })

keymap("x", "<bs>", function()
    FeedKeys("holo", "t")
end, opts)

keymap({ "s", "i", "n" }, "<C-7>", function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success and win_config.relative ~= "" then
            print(vim.inspect(win))
            print(vim.inspect(win_config))
            vim.api.nvim_win_close(win, true)
        end
    end
end, opts)

keymap("n", "]q", function()
    vim.cmd("cnext")
end, opts)
keymap("n", "[q", function()
    vim.cmd("cprev")
end, opts)

keymap("n", "<leader>d", function()
    ST = vim.uv.hrtime()
    vim.cmd("Glance definitions")
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
