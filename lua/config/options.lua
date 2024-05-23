-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.root_spec = { "cwd" }
vim.o.shell = "/opt/homebrew/bin/fish"
vim.g.loaded_netrw = 1
-- vim.o.lazyredraw = true
vim.g.loaded_netrwPlugin = 1
vim.o.synmaxcol = 300
-- https://github.com/Shatur/neovim-session-manager/issues/47#issuecomment-1195760661
vim.o.sessionoptions = "folds,curdir,help,tabpages,terminal,winsize,winpos,resize"
vim.opt.relativenumber = true
-- vim.opt.inccommand = "split"
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
-- vim.o.guifont = "menlo,Symbols Nerd Font:h18.5"
--[[ vim.o.guifont = "mcv sans mono,Symbols Nerd Font:h18.5"
vim.o.guifont = "JetBrains Mono light,Symbols Nerd Font:h19"
vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20:#e-subpixelantialias:#h-none"
vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20:#e-antialias:#h-normal"
vim.o.guifont = "hack,Symbols Nerd Font:h20:#e-subpixelantialias:#h-full"
vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20"
vim.g.winblend = 0
vim.opt.linespace = 11 ]]
vim.opt.linespace = 5
vim.o.conceallevel = 0
vim.opt.guicursor = "n-sm-ve:block,i-c-ci:ver18,r-cr-v-o:hor7"
vim.opt.timeoutlen = 500
vim.opt.laststatus = 0
vim.o.scrolloff = 6
vim.g.neovide_text_gamma = 1.4
vim.opt.timeoutlen = 300
vim.opt.swapfile = false
-- vim.o.incsearch = false
-- vim.opt.inccommand = "split"
local str = string.rep(" ", vim.api.nvim_win_get_width(0))
vim.opt.statusline = str
vim.g.loaded_matchparen = 1
-- vim.opt.linebreak = true
vim.g.cmp_completion = true
-- Neovide
vim.g.neovide_unlink_border_highlights = false
vim.g.neovide_transparency = 1
vim.g.neovide_remember_window_size = true
vim.g.neovide_position_animation_length = 0
-- vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_floating_shadow = true
vim.g.neovide_underline_stroke_scale = 2
vim.g.neovide_flatten_floating_zindex = "20,21,30,31,51,52"
vim.g.neovide_floating_z_height = 18
vim.g.neovide_light_angle_degrees = 180
-- vim.g.neovide_light_radius = 90
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
