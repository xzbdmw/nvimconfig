let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
let VM_case_setting = ""
let NeovimProjectPayload__session_restore = "return { neotree_opened_directories = nil, }"
let VM_highlight_matches = "underline"
let NvimTreeSetup =  1 
let VM_mouse_mappings =  0 
let VM_debug =  0 
let VM_disable_syntax_in_imode =  0 
let VM_check_mappings =  1 
let VM_default_mappings =  1 
let VM_persistent_registers =  0 
let VM_live_editing =  1 
let NvimTreeRequired =  1 
let VM_use_python =  0 
let VM_reselect_first =  0 
let VM_use_first_cursor_in_line =  0 
silent only
silent tabonly
cd ~/.config/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +456 ~/.config/nvim/lua/plugins/cmp.lua
badd +64 lua/plugins/glance.lua
badd +4 lua/plugins/theme.lua
badd +310 lua/config/keymaps.lua
badd +175 ~/.config/nvim/lua/plugins/nighfox_neovide.lua
badd +80 lua/plugins/cat.lua
badd +250 lua/config/autocmds.lua
badd +220 init.lua
badd +55 lua/plugins/treesitter.lua
badd +11 lua/plugins/oil.lua
badd +66 lua/config/options.lua
argglobal
%argdel
set lines=35 columns=166
edit lua/config/autocmds.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
wincmd =
argglobal
enew
file NvimTree_1
balt lua/config/autocmds.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
argglobal
balt lua/config/keymaps.lua
setlocal fdm=manual
setlocal fde=v:lua.require'lazyvim.util'.ui.foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
5,24fold
5,25fold
26,34fold
40,44fold
38,46fold
49,53fold
62,63fold
60,64fold
68,69fold
66,70fold
57,71fold
56,72fold
78,79fold
76,80fold
83,91fold
100,101fold
99,103fold
105,109fold
112,129fold
131,133fold
111,134fold
140,141fold
138,142fold
146,152fold
162,163fold
166,167fold
170,171fold
173,174fold
161,175fold
158,176fold
156,177fold
186,187fold
185,188fold
193,195fold
183,197fold
200,201fold
202,203fold
180,204fold
209,211fold
207,212fold
216,219fold
215,221fold
228,233fold
227,234fold
225,235fold
238,241fold
245,252fold
244,253fold
let &fdl = &fdl
244
normal! zo
let s:l = 250 - ((19 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 250
normal! 016|
wincmd w
2wincmd w
wincmd =
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
