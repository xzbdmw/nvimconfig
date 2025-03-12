vim.g.root_spec = { "cwd" }
vim.o.shell = "/opt/homebrew/bin/fish"
vim.g.loaded_netrw = 1
vim.o.cmdheight = 0
vim.o.syntax = "manual"
-- vim.o.timeout = false
vim.g.loaded_netrwPlugin = 1
vim.o.pumheight = 15
vim.o.showbreak = "↪ "
vim.o.synmaxcol = 300
vim.o.scrollback = 100000
vim.opt.diffopt:append({ "linematch:60", "indent-heuristic" })
vim.o.virtualedit = "block"
vim.o.fillchars = "diff:/,fold:-,foldclose:+,eob: "
vim.o.sessionoptions = "folds,curdir,help,terminal,winsize,winpos,resize" -- https://github.com/Shatur/neovim-session-manager/issues/47#issuecomment-1195760661
vim.o.termsync = true
vim.o.foldtext = ""
vim.o.expandtab = false
vim.o.foldmethod = "manual"
vim.o.incsearch = true
vim.o.relativenumber = false
vim.o.pumblend = 0
vim.o.shiftwidth = 4
vim.o.backup = true
vim.o.writebackup = true
vim.o.list = false
vim.o.backupcopy = "yes"
vim.g.editorconfig = false
vim.o.backupdir = "/Users/xzb/.local/state/nvim/backup//"
vim.o.tabstop = 4
vim.o.jumpoptions = "stack,view,clean"
vim.o.smarttab = false
-- vim.o.linespace = 7  mac, defaults write com.apple.dock tilesize -integer 7, font size 17
vim.o.linespace = 6 -- LG display, defaults write com.apple.dock tilesize -integer 11 font size 18
vim.o.numberwidth = 1
vim.o.whichwrap = "b,s,h,l"
vim.o.concealcursor = "nc"
vim.o.guicursor = "n-sm-ve:block-Cursor,i-c-ci-t:ver16-Cursor,r-cr-v-o:hor7-Cursor"
vim.o.laststatus = 0
vim.o.scrolloff = 6
vim.o.gdefault = true
vim.o.breakindent = true
vim.g.neovide_text_gamma = 1.5
vim.o.timeoutlen = 500
vim.o.swapfile = false
vim.o.background = "light"
local str = string.rep(" ", api.nvim_win_get_width(0))
vim.o.statusline = str
vim.o.cinkeys = "0{,0},0),0],0#,!^F,o,O,e"
vim.o.linebreak = true
vim.g.loaded_matchparen = 1
vim.g.cmp_completion = true

-- Neovide
vim.g.neovide_unlink_border_highlights = false
vim.g.neovide_remember_window_size = true
vim.g.neovide_position_animation_length = 0
vim.g.neovide_padding_top = 0
vim.g.neovide_refresh_rate = 120
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_input_macos_option_key_is_meta = "both"
vim.g.neovide_padding_left = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_floating_shadow = true
vim.g.neovide_underline_stroke_scale = 1.5
-- 152 oil, 800 git_commit, 1002,1003 cmp
vim.g.neovide_flatten_floating_zindex = "20,21,22,23,35,44,31,51,52,152,230,1002,1003"
vim.g.neovide_floating_z_height = 5
vim.g.neovide_light_angle_degrees = 30
vim.g.neovide_floating_blur_amount_x = 0
vim.g.neovide_floating_blur_amount_y = 0
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_touch_deadzone = 0
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00
vim.g.neovide_hide_mouse_when_typing = true
