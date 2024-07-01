vim.g.root_spec = { "cwd" }
vim.o.shell = "/opt/homebrew/bin/fish"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.synmaxcol = 300
vim.o.scrollback = 100000
vim.o.fillchars = "diff:/,fold:-,foldclose:+,eob: "
vim.o.sessionoptions = "folds,curdir,help,terminal,winsize,winpos,resize" -- https://github.com/Shatur/neovim-session-manager/issues/47#issuecomment-1195760661
vim.o.termsync = false
vim.o.foldtext = ""
vim.o.incsearch = true
vim.opt.relativenumber = false
vim.opt.pumblend = 0
vim.opt.shiftwidth = 4
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.list = false
vim.opt.backupcopy = "yes"
vim.g.editorconfig = false
vim.opt.backupdir = "/Users/xzb/.local/state/nvim/backup//"
vim.opt.tabstop = 4
vim.opt.jumpoptions = "stack,view"
vim.opt.linespace = 5
vim.o.concealcursor = "nc"
vim.opt.guicursor = "n-sm-ve:block,i-c-ci:ver16,r-cr-v-o:hor7"
vim.opt.laststatus = 0
vim.o.scrolloff = 6
vim.g.neovide_text_gamma = 1.4
vim.opt.timeoutlen = 500
vim.opt.swapfile = false
vim.o.background = "light"
local str = string.rep(" ", api.nvim_win_get_width(0))
vim.opt.statusline = str
vim.o.cinkeys = "0{,0},0),0],0#,!^F,o,O,e"
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
vim.g.neovide_padding_left = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_floating_shadow = true
vim.g.neovide_underline_stroke_scale = 2
vim.g.neovide_flatten_floating_zindex = "20,21,22,23,30,35,31,32,51,52,1002,1003"
vim.g.neovide_floating_z_height = 18
vim.g.neovide_light_angle_degrees = 180
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
                -- trace = {
                --     server = "verbose",
                -- },
                -- server = {
                --     extraEnv = {
                --         RA_LOG = "info",
                --         RA_LOG_FILE = "/Users/xzb/Downloads/ra.log",
                --     },
                -- },
                completion = {
                    -- callable = {
                    --     snippets = "add_parentheses",
                    -- },
                    fullFunctionSignatures = {
                        enable = true,
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
            border = "none",
            max_width = 140,
            max_height = 15,
            auto_focus = false,
            winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalFloat",
        },
    },
}
