vim.g.root_spec = { "cwd" }
vim.o.shell = "/opt/homebrew/bin/fish"
vim.g.loaded_netrw = 1
vim.o.cmdheight = 0
vim.o.syntax = "manual"
-- vim.o.timeout = false
vim.g.loaded_netrwPlugin = 1
vim.o.pumheight = 15
vim.o.synmaxcol = 300
vim.o.scrollback = 100000
vim.o.fillchars = "diff:/,fold:-,foldclose:+,eob: "
vim.o.sessionoptions = "folds,curdir,help,terminal,winsize,winpos,resize" -- https://github.com/Shatur/neovim-session-manager/issues/47#issuecomment-1195760661
vim.o.termsync = true
vim.o.foldtext = ""
vim.o.expandtab = false
vim.o.foldmethod = "manual"
vim.o.incsearch = true
vim.opt.relativenumber = false
vim.opt.pumblend = 0
vim.opt.shiftwidth = 4
vim.opt.backup = true
vim.opt.writebackup = true
vim.o.list = false
vim.opt.backupcopy = "yes"
vim.g.editorconfig = false
vim.opt.backupdir = "/Users/xzb/.local/state/nvim/backup//"
vim.opt.tabstop = 4
vim.opt.jumpoptions = "stack,view"
vim.opt.linespace = 7
vim.o.numberwidth = 1
vim.o.whichwrap = "b,s,h,l"
vim.o.concealcursor = "nc"
vim.o.guicursor = "n-sm-ve:block-Cursor,i-c-ci:ver16-Cursor,r-cr-v-o:hor7-Cursor"
vim.opt.laststatus = 0
vim.o.scrolloff = 6
vim.o.gdefault = true
vim.o.breakindent = true
vim.g.neovide_text_gamma = 1.5
vim.opt.timeoutlen = 500
vim.opt.swapfile = false
vim.o.background = "light"
local str = string.rep(" ", api.nvim_win_get_width(0))
vim.opt.statusline = str
vim.o.cinkeys = "0{,0},0),0],0#,!^F,o,O,e"
vim.o.linebreak = true
vim.g.loaded_matchparen = 1
vim.g.cmp_completion = true

-- Neovide
vim.g.neovide_unlink_border_highlights = false
vim.g.neovide_transparency = 1
vim.g.neovide_remember_window_size = true
vim.g.neovide_position_animation_length = 0
vim.g.neovide_padding_top = 0
vim.g.neovide_refresh_rate = 120
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_input_macos_option_key_is_meta = true
vim.g.neovide_padding_left = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_floating_shadow = true
vim.g.neovide_underline_stroke_scale = 1.5
-- 152 oil, 800 git_commit, 1002,1003 cmp
vim.g.neovide_flatten_floating_zindex = "20,21,22,23,35,31,51,52,152,800,1002,1003"
vim.g.neovide_floating_z_height = 5
vim.g.neovide_light_angle_degrees = 30
vim.g.neovide_floating_blur = false
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_touch_deadzone = 0
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00
vim.g.neovide_hide_mouse_when_typing = true

vim.g.rustaceanvim = {
    server = {
        cmd = function()
            return { "rust-analyzer" }
        end,
        -- trace = {
        --     server = "verbose",
        -- },
        settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
                completion = {
                    -- callable = {
                    --     snippets = "add_parentheses",
                    -- },
                    fullFunctionSignatures = {
                        enable = false,
                    },
                    privateEditable = {
                        enable = true,
                    },
                },
                procMacro = {
                    ignored = {
                        tokio_macros = {
                            "main",
                            "test",
                        },
                        tracing_attributes = {
                            "instrument",
                        },
                    },
                },
                inlayHints = {
                    parameterHints = false,
                    closureReturnTypeHints = "with_block",
                },
                workspace = {
                    symbol = {
                        search = {
                            -- scope = "workspace_and_dependencies",
                            -- scope = "workspace",
                        },
                    },
                },
            },
        },
    },
    tools = {
        hover_actions = {
            replace_builtin_hover = true,
        },
        float_win_config = {
            border = "solid",
            auto_focus = false,
            winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalFloat",
        },
    },
}
