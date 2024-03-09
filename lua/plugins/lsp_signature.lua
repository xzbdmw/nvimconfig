return {
    "ray-x/lsp_signature.nvim",
    enabled = false,
    dependencies = {
        "RRethy/vim-illuminate",
    },
    keys = {
        {
            "<M-p>",
            function()
                require("lsp_signature").toggle_float_win()
            end,
            mode = { "n" },
        },
    },
    lazy = false,
    event = "VeryLazy",
    version = false,
    opts = {
        debug = false, -- set to true to enable debug logging
        log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
        -- default is  ~/.cache/nvim/lsp_signature.log
        verbose = false, -- show debug line number
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        -- If you want to hook lspsaga or other signature handler, pls set to false
        doc_lines = 0, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
        -- set to 0 if you DO NOT want any API comments be shown
        -- This setting only take effect in insert mode, it does not affect signature help in normal
        -- mode, 10 by default

        max_height = 10, -- max height of signature floating_window
        max_width = 40, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        -- the value need >= 40
        wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
        floating_window = false, -- show hint in a floating window, set to false for virtual text only mode

        floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
        -- will set to true when fully tested, set to false will use whichever side has more space
        -- this setting will be helpful if you do not want the PUM and floating win overlap

        -- floating_window_off_x = -11, -- adjust float windows x position.
        floating_window_off_x = 0, -- adjust float windows x position.
        -- can be either a number or function
        floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
        -- can be either number or function, see examples
        close_timeout = 4000, -- close floating window after ms when laster parameter is entered
        fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = false, -- virtual hint enable
        hint_prefix = "", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
        hint_scheme = "String",
        hint_inline = function()
            return true
        end, -- should the hint be inline(nvim 0.10 only)?  default false
        -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
        -- return 'right_align' to display hint right aligned in the current line
        hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
        handler_opts = {
            border = "none", -- double, rounded, single, shadow, none, or a table of borders
        },

        always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

        auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
        extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
        zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

        padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

        transparency = 0, -- disabled by default, allow floating win transparent value 1~100
        shadow_blend = 36, -- if you using shadow as border use this set the opacity
        shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
        timer_interval = 1, -- default timer check interval set to lower value if you want to reduce latency
        toggle_key = "<M-p>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
        toggle_key_flip_floatwin_setting = true, -- true: toggle floating_windows: true|false setting after toggle key pressed
        -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
        -- may not popup when typing depends on floating_window setting

        select_signature_key = "<C-5>", -- cycle to next signature, e.g. '<M-n>' function overloading
        move_cursor_key = "<f7>", -- imap, use nvim_set_current_win to move cursor between current win and floating
    },
    config = function(_, opts)
        vim.keymap.del("n", "<M-p>")
        require("lsp_signature").setup(opts)
    end,
}
