-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.root_spec = { "cwd" }
vim.o.shell = "/opt/homebrew/bin/fish"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.opt.number = false
-- https://github.com/Shatur/neovim-session-manager/issues/47#issuecomment-1195760661
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,winsize,winpos"

-- vim.o.sessionoptions = "buffers,curdir"
-- vim.cmd("set sessionoptions=buffers,curdir")
vim.g.neovide_unlink_border_highlights = false
vim.opt.relativenumber = false
-- vim.opt.number = false
vim.opt.shiftwidth = 4
vim.opt.list = false
vim.opt.tabstop = 4
-- vim.opt.jumpoptions = "stack"
-- vim.o.guifont = "mcv sans mono,Symbols Nerd Font:h20"
-- vim.o.guifont = "JetBrains Mono light,Symbols Nerd Font:h19"
-- vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20:#e-subpixelantialias:#h-none"
-- vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20:#e-antialias:#h-normal"
-- vim.o.guifont = "hack,Symbols Nerd Font:h20:#e-subpixelantialias:#h-full"
-- vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20"
vim.opt.linespace = 5
vim.opt.guicursor = "n-sm-ve:block,i-c-ci:ver18,r-cr-v-o:hor7"
vim.opt.timeoutlen = 500
vim.opt.swapfile = false
-- vim.g.neovide_transparency = 0.95
vim.opt.laststatus = 0
-- vim.opt.linebreak = true
local str = string.rep(" ", vim.api.nvim_win_get_width(0))
vim.opt.statusline = str
-- vim.opt.statusline = str
vim.g.neovide_remember_window_size = true
vim.g.neovide_input_macos_alt_is_meta = true
-- vim.g.neovide_refresh_rate = 120
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
-- vim.g.neovide_cursor_animation_length = 0.08
-- vim.g.neovide_underline_stroke_scale = 1.0
vim.g.neovide_padding_left = 0
vim.o.scrolloff = 6
local keymap = vim.keymap.set
keymap({ "n", "v" }, "<D-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
keymap({ "n", "v" }, "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
keymap({ "n", "v" }, "<D-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_touch_deadzone = 0
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_hide_mouse_when_typing = true
vim.g.rustaceanvim = {
    server = {
        standalone = false,
        settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
                completion = {
                    callable = {
                        snippets = "add_parentheses",
                    },
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
            border = "rounded",
            max_width = 70,
            max_height = 12,
            auto_focus = false,
        },
    },
}
