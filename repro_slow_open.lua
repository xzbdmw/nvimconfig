local root = vim.fn.fnamemodify("./.repro", ":p")
_G.Time1 = function(start, msg)
    msg = msg or ""
    local duration = 0.000001 * (vim.loop.hrtime() - start)
    -- __AUTO_GENERATED_PRINT_VAR_START__
    print(msg .. [==[: ]==], duration) -- __AUTO_GENERATED_PRINT_VAR_END__
end

-- set stdpaths to use .repro
for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end
-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- install plugins
local plugins = {
    --     -- do not remove the colorscheme!
    "folke/tokyonight.nvim",
}
--     -- add any other pugins here
--     "neovim/nvim-lspconfig",
--     {
--         "nvim-treesitter/nvim-treesitter",
--         config = function(_, opts)
--             require("nvim-treesitter.configs").setup({
--                 -- A list of parser names, or "all" (the five listed parsers should always be installed)
--                 ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
--
--                 -- Install parsers synchronously (only applied to `ensure_installed`)
--                 sync_install = false,
--
--                 -- Automatically install missing parsers when entering buffer
--                 -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
--                 auto_install = true,
--
--                 -- List of parsers to ignore installing (or "all")
--                 ignore_install = { "javascript" },
--
--                 ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
--                 -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
--
--                 highlight = {
--                     enable = true,
--
--                     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
--                     -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
--                     -- the name of the parser)
--                     -- list of language that will be disabled
--                     disable = { "c", "rust" },
--                     -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
--                     disable = function(lang, buf)
--                         local max_filesize = 100 * 1024 -- 100 KB
--                         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--                         if ok and stats and stats.size > max_filesize then
--                             return true
--                         end
--                     end,
--
--                     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--                     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--                     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--                     -- Instead of true it can also be a list of languages
--                     additional_vim_regex_highlighting = false,
--                 },
--             })
--         end,
--     },
--     { -- Autocompletion
--         dir = "/Users/xzb/.local/share/nvim/lazy/nvim-cmp",
--         event = "InsertEnter",
--         dependencies = {
--             -- Snippet Engine & its associated nvim-cmp source
--             {
--                 dir = "/Users/xzb/.local/share/nvim/lazy/LuaSnip",
--                 build = (function()
--                     -- Build Step is needed for regex support in snippets.
--                     -- This step is not supported in many windows environments.
--                     -- Remove the below condition to re-enable on windows.
--                     if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
--                         return
--                     end
--                     return "make install_jsregexp"
--                 end)(),
--                 dependencies = {
--                     -- `friendly-snippets` contains a variety of premade snippets.
--                     --    See the README about individual language/framework/plugin snippets:
--                     --    https://github.com/rafamadriz/friendly-snippets
--                     -- {
--                     --   'rafamadriz/friendly-snippets',
--                     --   config = function()
--                     --     require('luasnip.loaders.from_vscode').lazy_load()
--                     --   end,
--                     -- },
--                 },
--             },
--             "saadparwaiz1/cmp_luasnip",
--
--             -- Adds other completion capabilities.
--             --  nvim-cmp does not ship with all sources by default. They are split
--             --  into multiple repos for maintenance purposes.
--             "hrsh7th/cmp-nvim-lsp",
--             "hrsh7th/cmp-path",
--         },
--         config = function()
--             -- See `:help cmp`
--             local cmp = require("cmp")
--             local luasnip = require("luasnip")
--             luasnip.config.setup({})
--
--             cmp.setup({
--                 window = {
--                     completion = cmp.config.window.bordered({
--                         border = "none",
--                         side_padding = 0,
--                         col_offset = -3,
--                         winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalFloat",
--                     }),
--                     documentation = cmp.config.window.bordered({
--                         border = "none",
--                         winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalDocFloat",
--                         col_offset = 0,
--                         side_padding = 0,
--                     }),
--                 },
--                 snippet = {
--                     expand = function(args)
--                         luasnip.lsp_expand(args.body)
--                     end,
--                 },
--                 completion = { completeopt = "menu,menuone,noinsert" },
--
--                 -- For an understanding of why these mappings were
--                 -- chosen, you will need to read `:help ins-completion`
--                 --
--                 -- No, but seriously. Please read `:help ins-completion`, it is really good!
--                 mapping = cmp.mapping.preset.insert({
--                     -- Select the [n]ext item
--                     ["<C-n>"] = cmp.mapping.select_next_item(),
--                     -- Select the [p]revious item
--                     ["<C-p>"] = cmp.mapping.select_prev_item(),
--
--                     -- Scroll the documentation window [b]ack / [f]orward
--                     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--                     ["<C-f>"] = cmp.mapping.scroll_docs(4),
--
--                     -- Accept ([y]es) the completion.
--                     --  This will auto-import if your LSP supports it.
--                     --  This will expand snippets if the LSP sent a snippet.
--                     ["<Cr>"] = cmp.mapping.confirm({ select = true }),
--
--                     -- If you prefer more traditional completion keymaps,
--                     -- you can uncomment the following lines
--                     --['<CR>'] = cmp.mapping.confirm { select = true },
--                     --['<Tab>'] = cmp.mapping.select_next_item(),
--                     --['<S-Tab>'] = cmp.mapping.select_prev_item(),
--
--                     -- Manually trigger a completion from nvim-cmp.
--                     --  Generally you don't need this, because nvim-cmp will display
--                     --  completions whenever it has completion options available.
--                     ["<C-Space>"] = cmp.mapping.complete({}),
--
--                     ["<CR>"] = cmp.mapping(function(fallback)
--                         if cmp.visible() then
--                             ST = vim.uv.hrtime()
--                             vim.g.neovide_cursor_animation_length = 0.02
--                             vim.g.enter = true
--                             vim.g.no_redraw = true
--                             vim.defer_fn(function()
--                                 vim.g.enter = false
--                                 vim.g.neovide_cursor_animation_length = 0.06
--                             end, 100)
--                             -- Time(ST, "optionset")
--                             cmp.confirm({ select = true })
--                         else
--                             _G.no_delay(0)
--                             fallback()
--                         end
--                         vim.defer_fn(function()
--                             -- hlchunk
--                             ---@diagnostic disable-next-line: undefined-field
--                             pcall(_G.indent_update)
--                             -- mini-indentscope
--                             ---@diagnostic disable-next-line: undefined-field
--                             pcall(_G.mini_indent_auto_draw)
--                         end, 100)
--                         _G.has_moved_up = false
--                     end),
--                     -- Think of <c-l> as moving to the right of your snippet expansion.
--                     --  So if you have a snippet that's like:
--                     --  function $name($args)
--                     --    $body
--                     --  end
--                     --
--                     -- <c-l> will move you to the right of each of the expansion locations.
--                     -- <c-h> is similar, except moving you backwards.
--                     ["<C-l>"] = cmp.mapping(function()
--                         if luasnip.expand_or_locally_jumpable() then
--                             luasnip.expand_or_jump()
--                         end
--                     end, { "i", "s" }),
--                     ["<C-h>"] = cmp.mapping(function()
--                         if luasnip.locally_jumpable(-1) then
--                             luasnip.jump(-1)
--                         end
--                     end, { "i", "s" }),
--
--                     -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
--                     --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
--                 }),
--                 sources = {
--                     { name = "nvim_lsp" },
--                     { name = "luasnip" },
--                     { name = "path" },
--                 },
--             })
--         end,
--     },
-- }
require("lazy").setup(plugins, {
    root = root .. "/plugins",
})
-- local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- local capabilities = vim.tbl_deep_extend(
--     "force",
--     {},
--     vim.lsp.protocol.make_client_capabilities(),
--     has_cmp and cmp_nvim_lsp.default_capabilities() or {}
-- )
-- local function testsssssssssssssssssssssssssssssss(aaaaaaa, bbbbbbbb) end
-- require("lspconfig").lua_ls.setup({
--     capabilities = capabilities,
--     settings = {
--         Lua = {
--             runtime = {
--                 version = "LuaJIT",
--             },
--             completion = { callSnippet = "Both" },
--             hint = {
--                 enable = true,
--                 ["setType"] = true,
--                 ["paramType"] = true,
--             },
--         },
--     },
-- })

vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        -- if vim.g.gd then
        --     require("plenary.profile").start("profilef.log", { flame = true })
        -- end
        start_time = os.clock()
    end,
})
vim.keymap.set("n", "gd", function()
    vim.g.gd = true
    vim.defer_fn(function()
        vim.g.gd = false
    end, 100)
    -- vim.lsp.buf.definition()
end)
-- local origin = vim.api.nvim_exec2
-- vim.api.nvim_exec2 = function(src, opts)
--     if vim.g.gd then
--         -- __AUTO_GENERATED_PRINT_VAR_START__
--         print([==[function opts:]==], vim.inspect(opts)) -- __AUTO_GENERATED_PRINT_VAR_END__
--         -- __AUTO_GENERATED_PRINT_VAR_START__
--         print([==[function src:]==], vim.inspect(src)) -- __AUTO_GENERATED_PRINT_VAR_END__
--         Time(ST, "exec2")
--     end
--     origin(src, opts)
-- end
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- if vim.g.gd then
        -- print(debug.traceback())
        -- end
        end_time = os.clock()
        if start_time then
            local elapsed_time = end_time - start_time
        end
    end,
})
-- add anything else here
vim.opt.termguicolors = true
-- do not remove the colorscheme!
vim.cmd([[colorscheme tokyonight]])
