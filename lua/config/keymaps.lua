-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.hover = "gr"
require("custom.highlight")
-- require("custom.cmp_highlight")
vim.keymap.del("n", "<leader>w-")
vim.keymap.del("n", "<leader>ww")
vim.keymap.del("n", "<leader>wd")
vim.keymap.del("n", "<leader>w|")
-- hl(0, "MiniIndentscopeSymbol", { link = "@variable.member" })
-- hl(0, "IndentBlanklineContextChar", { fg = "#BDBFC9" })
keymap("n", "<leader>td", function()
    require("dapui").toggle()
end, { silent = true, noremap = true, desc = "toggle signature" })
keymap("n", "<F3>", function()
    require("dap").continue()
    require("dapui").toggle()
end)
keymap("n", "-", function()
    require("dap").step_over()
end)
keymap("n", "=", function()
    require("dap").step_into()
end)
keymap("n", "+", function()
    require("dap").step_out()
end)
keymap("n", "<Leader>bb", function()
    require("dap").toggle_breakpoint()
end)
keymap("n", "<Leader>B", function()
    require("dap").set_breakpoint()
end)
keymap("n", "<Leader>lp", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
-- vim.keymap.set("n", "<Leader>dr", function()
--     require("dap").repl.open()
-- end)
-- vim.keymap.set("n", "<Leader>dl", function()
--     require("dap").run_last()
-- end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
--     require("dap.ui.widgets").hover()
-- end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
--     require("dap.ui.widgets").preview()
-- end)
-- vim.keymap.set("n", "<Leader>df", function()
--     local widgets = require("dap.ui.widgets")
--     widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set("n", "<Leader>ds", function()
--     local widgets = require("dap.ui.widgets")
--     widgets.centered_float(widgets.scopes)
-- end)
-- keymap({ "i", "n" }, "<f8>", function()
--     vim.lsp.buf.signature_help()
-- end, opts)
-- keymap("n", "<CR>", "zo", opts)
keymap("n", "<CR>", function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0) -- 获取当前窗口的光标位置
    local line_num = cursor_pos[1] -- 光标所在的行号
    local fold_start = vim.fn.foldclosed(line_num)
    if fold_start == -1 then
        print("enter fold_start")
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zo", true, false, true), "n", true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
    end
end)
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set("n", "zp", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
        -- choose one of coc.nvim and nvim lsp
        vim.fn.CocActionAsync("definitionHover") -- coc.nvim
        vim.lsp.buf.hover()
    end
end)
keymap("n", "<down>", "<C-w>j", opts)
keymap("", "<D-a>", "ggVG", opts)
keymap("n", "<up>", "<C-w>k", opts)
keymap("n", "<left>", "<C-w>h", opts)
keymap("n", "<right>", "<C-w>l", opts)
keymap({ "n", "i" }, "<C-c>", "<C-w>w", opts)
keymap("n", "<leader>i", function()
    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
end, opts)
keymap({ "x", "v", "n", "i" }, "<f7>", function()
    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
end, opts)
keymap("n", "<D-w>", function()
    local win_amount = #vim.api.nvim_tabpage_list_wins(0)
    if win_amount == 1 then
        vim.cmd("BufDel")
    else
        vim.cmd("close")
    end
end)
--[[
keymap({ "i", "n", "x" }, "<M-p>", function()
    vim.lsp.buf.signature_help()
end, opts)
keymap({ "n", "i", "x" }, "<M-p>", function()
    require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "toggle signature" })
]]
local open = 0
keymap("n", "<Tab>", function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0) -- 获取当前窗口的光标位置
    local line_num = cursor_pos[1] -- 光标所在的行号
    local fold_start = vim.fn.foldclosed(line_num)
    if fold_start == -1 then
        vim.lsp.buf.hover()
        vim.defer_fn(function()
            vim.lsp.buf.hover()
        end, 100)
    else
        require("ufo").peekFoldedLinesUnderCursor()
    end
end)
keymap("n", "<leader><leader>w", function()
    require("dropbar.api").pick()
end, opts)
keymap("n", "<leader>1", function()
    require("dropbar.api").pick(1)
end, opts)
keymap("n", "<leader>2", function()
    require("dropbar.api").pick(2)
end, opts)
keymap("n", "<leader>3", function()
    require("dropbar.api").pick(3)
end, opts)
keymap("n", "<leader>4", function()
    require("dropbar.api").pick(4)
end, opts)
keymap("n", "<leader>5", function()
    require("dropbar.api").pick(5)
end, opts)
keymap("n", "<leader>gz", function()
    vim.cmd("NoNeckPain")
    if open == 0 then
        vim.opt.number = false
        open = 1
    else
        vim.opt.number = true
        open = 0
    end
end, opts)
keymap("n", "<D-3>", function()
    open = 1
end, opts)
keymap({ "n", "v" }, "<D-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
keymap({ "n", "v" }, "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
keymap({ "n", "v" }, "<D-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
keymap({ "n", "i" }, "<D-2>", function()
    vim.cmd("NoNeckPain")
    if open == 0 then
        vim.opt.number = false
        open = 1
    else
        vim.opt.number = true
        open = 0
    end
end, opts)
--[[ recommended mappings
resizing splits
these keymaps will also accept a range,
for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)` ]]
keymap("n", "<leader>vr", "<cmd>vsp<CR>")
keymap("n", "<leader>vd", "<cmd>sp<CR>")
keymap("n", "<C-->", require("smart-splits").resize_left)
keymap("n", "<D-j>", require("smart-splits").resize_down)
-- keymap("n", "<f16>", require("smart-splits").resize_up)
keymap("n", "<C-=>", require("smart-splits").resize_right)
keymap("n", "<leader><leader>h", "<C-w>H", opts)
keymap("n", "<leader><leader>j", "<C-w>J", opts)
keymap("n", "<leader><leader>k", "<C-w>K", opts)
keymap("n", "<leader><leader>l", "<C-w>L", opts)
keymap({ "n", "v" }, "J", "4j", opts)
keymap({ "n", "v" }, "K", "4k", opts)
keymap("n", "<C-b>", "<C-v>", opts)
-- yanky
keymap({ "n", "i" }, "<C-p>", "<Plug>(YankyPreviousEntry)")
keymap({ "n", "i" }, "<C-n>", "<Plug>(YankyPreviousEntry)")
keymap({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
keymap({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
-- keymap({ "v" }, "p", '"_d<Plug>(YankyPutBefore)')
keymap({ "n", "x" }, "gp", "<Plug>(YankyPutAfterCharwiseJoined)")
keymap("x", "p", "<Plug>(YankyPutBefore)", { desc = "Paste without copying replaced text" })

keymap({ "v" }, "gp", '"_d<Plug>(YankyPutAfterCharwiseJoined)')
keymap("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
keymap("n", "<c-n>", "<Plug>(YankyNextEntry)")
keymap({ "n", "i" }, "<C-6>", function()
    require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
        initial_mode = "insert",
        layout_strategy = "horizontal",
        previewer = false,
        bufnr_width = 0,
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        layout_config = {
            horizontal = {
                width = 0.35,
                height = 0.7,
            },
            preview_cutoff = 0,
            mirror = false,
        },
    }))
end, opts)
keymap("n", "<space>fa", ":Telescope file_browser<CR>", opts)
keymap("n", "<space>ha", function()
    require("harpoon.mark").add_file()
end, opts)
keymap("n", "<space>hd", function()
    require("harpoon.mark").add_file()
end, opts)
keymap("n", "<space>hl", function()
    require("harpoon.ui").toggle_quick_menu()
end, opts)
--[[ keymap("n", "<space>1", function()
    require("harpoon.ui").nav_file(1)
end, opts)
keymap("n", "<space>2", function()
    require("harpoon.ui").nav_file(2)
end, opts)
keymap("n", "<space>3", function()
    require("harpoon.ui").nav_file(3)
end, opts) ]]
keymap("n", "<space>hn", function()
    require("harpoon.ui").nav_next()
end, opts)
keymap("n", "<space>hp", function()
    require("harpoon.ui").nav_prev()
end, opts)
keymap("n", "<leader>uz", "<Cmd>Telescope frecency<CR>")
keymap("c", "<Tab>", "<CR>", opts)
keymap({ "n", "i" }, "<D-e>", function()
    require("telescope").extensions.smart_open.smart_open(require("telescope.themes").get_dropdown({
        initial_mode = "insert",
        layout_strategy = "horizontal",
        previewer = false,
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        layout_config = {
            horizontal = {
                width = 0.35,
                height = 0.7,
            },
            preview_cutoff = 0,
            mirror = false,
        },
    }))
end, { noremap = true, silent = true, desc = "find files in cwd" })
keymap("c", "<CR>", "<Nop>", opts)
keymap("c", "<f8>", "<CR>", opts)
keymap("n", "<leader>nh", function()
    require("noice").cmd("telescope")
end)
keymap("c", "<D-CR>", "<CR>", opts)
keymap({ "i", "n" }, "<C-e>", function()
    vim.diagnostic.goto_next()
end, opts)
keymap("n", "ga", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "go to sticky scroll" })
keymap("n", "<D-s>", ":w<CR>", opts)
-- keymap("n", "<C-a>", "<C-w>", opts)
keymap("i", "<D-s>", "<Esc>:w<CR>a", opts)
keymap({ "n", "v", "i" }, "<D-c>", "y", opts)
keymap("n", "<D-v>", "hp", opts)
keymap("i", "<D-v>", "<Esc>pa", opts)
keymap("c", "<D-v>", "<C-r>+<CR>", opts)
-- keymap({ "n", "i" }, "<D-w>", ":BufDel<CR>", opts)
keymap("n", "<D-z>", "u", opts)
keymap("i", "<D-z>", "<esc>ua", opts)
-- keymap({ "n", "i" }, "<D-1>", ":Neotree filesystem reveal left<CR>", opts)
keymap({ "n", "i", "c" }, "<D-1>", ":NvimTreeToggle<CR>", opts)
keymap("n", "<C-f>", ":NvimTreeFocus<CR>", opts)
keymap("n", "<leader>j", "<C-o>", opts)
--[[ keymap("n", "<D-f>", function()
    local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes("/", true, false, true)
    vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "m", false)
end, { noremap = false, silent = true })
keymap("n", "<D-f>", function() end, opts) ]]
keymap("n", "<D-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
--[[ keymap("n", "<C-p>", function()
    local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes(":", true, false, true)
    vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "m", false)
end, { noremap = false, silent = true }) ]]
keymap("i", "<D-f>", "<Esc>/", { noremap = false, silent = true })
keymap({ "n", "i" }, "<f11>", "<C-o>", opts)
keymap("n", "<leader>k", "<C-i>", opts)
keymap({ "n", "i" }, "<f18>", "<C-i>", opts)
keymap("n", "<leader>d", require("definition-or-references").definition_or_references, opts)
keymap({ "s", "i", "n" }, "<C-7>", function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            -- print(vim.inspect(win_config))
            if win_config.relative ~= "" then
                vim.api.nvim_win_close(win, true)
            end
        end
    end
end, opts)
--[[ keymap({ "s", "i", "n" }, "<esc>", function()
    -- for _, win in pairs(vim.api.nvim_list_wins()) do
    --     local success, win_config = pcall(vim.api.nvim_win_get_config, win)
    --     if success then
    --         -- print(vim.inspect(win_config))
    --         if win_config.relative ~= "" then
    --             vim.api.nvim_win_close(win, true)
    --         end
    --     end
    -- end
    for _, win in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "win" then
            vim.api.nvim_win_close(win, false)
        end
    end
    return "<cmd>noh<cr><esc>"
end, { expr = true, desc = "closing floating windows" }) ]]
