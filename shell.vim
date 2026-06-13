nmap J 6j
nmap K 6k
set ignorecase
set smartcase
highlight Normal guibg=#FBF7E6
lua << EOF
local lazy_path = vim.fn.stdpath("data") .. "/lazy"
vim.opt.runtimepath:append(lazy_path .. "/mini.ai")
vim.opt.runtimepath:append(lazy_path .. "/nvim-spider")
vim.opt.runtimepath:append(lazy_path .. "/substitute.nvim")
vim.o.laststatus = 0

local api = vim.api
local shell_utils = {}

function shell_utils.has_namespace(name_space, type)
  local ns = api.nvim_create_namespace(name_space)
  local extmarks
  if type then
    extmarks = api.nvim_buf_get_extmarks(0, ns, { 0, 0 }, { -1, -1 }, { type = type })
  else
    extmarks = api.nvim_buf_get_extmarks(0, ns, { 0, 0 }, { -1, -1 }, {})
  end
  return extmarks ~= nil and #extmarks ~= 0
end

package.preload["config"] = package.preload["config"] or function()
  return { utils = shell_utils }
end
package.preload["utils"] = package.preload["utils"] or function()
  return shell_utils
end
package.preload["config.utils"] = package.preload["config.utils"] or function()
  return shell_utils
end

local ok_ai, ai = pcall(require, "mini.ai")
if ok_ai then
  ai.setup({
    n_lines = 2000,
    custom_textobjects = {
      A = ai.gen_spec.treesitter({ i = "@parameter.inner", a = "@parameter.outer" }, {}),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
      c = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
      g = function()
        local from = { line = 1, col = 1 }
        local to = {
          line = vim.fn.line("$"),
          col = math.max(vim.fn.getline("$"):len(), 1),
        }
        return { from = from, to = to }
      end,
    },
  })
end

local ok_spider, spider = pcall(require, "spider")
if ok_spider then
  spider.setup({
    skipInsignificantPunctuation = false,
    subwordMovement = true,
    customPatterns = {},
  })
  vim.keymap.set({ "n", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
  vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
  vim.keymap.set({ "n", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
  vim.keymap.set({ "o" }, "b", "v<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
end

local ok_substitute, substitute = pcall(require, "substitute")
if ok_substitute then
  substitute.setup({
    yank_substituted_text = false,
    preserve_cursor_position = false,
    modifiers = nil,
    highlight_substituted_text = {
      enabled = true,
      timer = 130,
    },
    range = {},
    exchange = {
      motion = false,
      use_esc_to_cancel = false,
      preserve_cursor_position = true,
    },
  })

  vim.keymap.set("n", "s", function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_mark(0, "c", row, col, {})
    substitute.operator({
      modifiers = function(state)
        if state.vmode == "line" then
          vim.api.nvim_win_set_cursor(0, vim.api.nvim_buf_get_mark(0, "c"))
          return {}
        end
      end,
    })
  end)
  vim.keymap.set("n", "S", "s$", { remap = true })
  vim.keymap.set("o", "s", function()
    if vim.v.operator == "g@" and vim.o.operatorfunc:find("substitute") ~= nil then
      return "_"
    else
      return "S"
    end
  end, { expr = true, remap = true })
  vim.keymap.set("n", "ge", function()
    require("substitute.exchange").operator()
  end)
  vim.keymap.set("n", "gee", "ge_", { remap = true })
  vim.keymap.set("x", "ge", function()
    require("substitute.exchange").visual()
  end)
end
EOF
nmap 0 g^
nmap j gj
nmap k gk
nnoremap y "+y
nnoremap Y "+y$
xnoremap y "+y
nmap q :q!<CR>
nmap L g$
nmap e ea
nmap <Space>ow :setlocal wrap! wrap?<CR>
nmap <Space>w :wq<CR>
nmap <CR> :wq<CR>
nmap <Space>q :q!<CR>
nmap <D-v> <C-r>"
autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=200})
autocmd VimEnter * call feedkeys('G$', 'n')
