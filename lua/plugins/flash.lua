return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- enabled = false,
    -- -- stylua: ignore
    keys = {
        {
            "s",
            false,
        },
        {
            "S",
            mode = { "o" },
            function()
                vim.g.treesitter_search = true
                vim.o.scrolloff = 0
                vim.g.flash_winbar = vim.wo.winbar
                require("flash").treesitter({
                    filter = function(matches)
                        for i = #matches, 2, -1 do
                            matches[i].label = matches[i - 1].label
                        end
                        table.remove(matches, 1)
                    end,
                })
            end,
            desc = "Flash Treesitter",
        },
        {
            "x",
            mode = "o",
            function()
                vim.o.scrolloff = 0
                vim.g.flash_winbar = vim.wo.winbar
                require("flash").remote()
            end,
            desc = "Remote Flash",
        },
        {
            ";",
            mode = { "n", "x", "o" },
            function()
                if vim.g.disable_flash then
                    return
                end
                vim.cmd([[normal! m']])
                vim.g.disable_flash = true
                vim.o.scrolloff = 0
                vim.g.flash_winbar = vim.wo.winbar
                vim.on_key(nil, vim.api.nvim_create_namespace("f_search"))
                require("flash").jump()
            end,
            desc = "Flash",
        },
        {
            "S",
            false,
        },
        -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
    config = function()
        require("flash").setup({
            -- labels = "abcdefghijklmnopqrstuvwxyz",
            labels = "asdfjklqwertyuiopzxcvbnm",
            search = {
                -- search/jump in all windows
                multi_window = false,
                -- search direction
                forward = true,
                -- when `false`, find only matches in the given direction
                wrap = true,
                -- Each mode will take ignorecase and smartcase into account.
                -- * exact: exact match
                -- * search: regular search
                -- * fuzzy: fuzzy search
                -- * fun(str): custom function that returns a pattern
                --   For example, to only match at the beginning of a word:
                --   mode = function(str)
                --     return "\\<" .. str
                --   end,
                mode = "search",
                -- behave like `incsearch`
                incremental = false,
                -- Excluded filetypes and custom window filters
                exclude = {
                    "notify",
                    "cmp_menu",
                    "noice",
                    "flash_prompt",
                    function(win)
                        -- exclude non-focusable windows
                        return not vim.api.nvim_win_get_config(win).focusable
                    end,
                },
                -- Optional trigger character that needs to be typed before
                -- a jump label can be used. It's NOT recommended to set this,
                -- unless you know what you're doing
                trigger = "",
                -- max pattern length. If the pattern length is equal to this
                -- labels will no longer be skipped. When it exceeds this length
                -- it will either end in a jump or terminate the search
                max_length = false, ---@type number|false
            },
            jump = {
                -- save location in the jumplist
                jumplist = false,
                -- jump position
                pos = "start", ---@type "start" | "end" | "range"
                -- add pattern to search history
                history = false,
                -- add pattern to search register
                register = false,
                -- clear highlight after jump
                nohlsearch = false,
                -- automatically jump when there is only one match
                autojump = false,
                -- You can force inclusive/exclusive jumps by setting the
                -- `inclusive` option. By default it will be automatically
                -- set based on the mode.
                inclusive = false, ---@type boolean?
                -- jump position offset. Not used for range jumps.
                -- 0: default
                -- 1: when pos == "end" and pos < current position
                offset = nil, ---@type number
            },
            label = {
                -- allow uppercase labels
                uppercase = false,
                -- add any labels with the correct case here, that you want to exclude
                exclude = "",
                -- add a label for the first match in the current window.
                -- you can always jump to the first match with `<CR>`
                current = true,
                -- show the label after the match
                after = false, ---@type boolean|number[]
                -- show the label before the match
                before = true, ---@type boolean|number[]
                -- position of the label extmark
                style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
                -- flash tries to re-use labels that were already assigned to a position,
                -- when typing more characters. By default only lower-case labels are re-used.
                reuse = "lowercase", ---@type "lowercase" | "all" | "none"
                -- for the current window, label targets closer to the cursor first
                distance = true,
                -- minimum pattern length to show labels
                -- Ignored for custom labelers.
                min_pattern_length = 1,
                -- Enable this to use rainbow colors to highlight labels
                -- Can be useful for visualizing Treesitter ranges.
                rainbow = {
                    enabled = true,
                    -- number between 1 and 9
                    shade = 2,
                },
                -- With `format`, you can change how the label is rendered.
                -- Should return a list of `[text, highlight]` tuples.
                ---@class Flash.Format
                ---@field hl_group string
                ---@field after boolean
                ---@type fun(opts:Flash.Format): string[][]
                format = function(opts)
                    return { { opts.match.label, opts.hl_group } }
                end,
            },
            highlight = {
                -- show a backdrop with hl FlashBackdrop
                backdrop = false,
                -- Highlight the search matches
                matches = true,
                -- extmark priority
                priority = 5000,
                groups = {
                    match = "FlashMatch",
                    current = "FlashCurrent",
                    backdrop = "FlashBackdrop",
                    label = "FlashLabel",
                },
            },
            -- action to perform when picking a label.
            -- defaults to the jumping logic depending on the mode.
            action = nil,
            -- initial pattern to use when opening flash
            pattern = "",
            -- When `true`, flash will try to continue the last search
            continue = false,
            -- Set config to a function to dynamically change the config
            config = nil,
            -- You can override the default options for a specific mode.
            -- Use it with `require("flash").jump({mode = "forward"})`
            modes = {
                char = {
                    enabled = false,
                },
                -- options used when flash is activated through
                -- a regular search with `/` or `?`
                search = {
                    -- when `true`, flash will be activated during regular search by default.
                    -- You can always toggle when searching with `require("flash").toggle()`
                    enabled = false,
                    highlight = { backdrop = false },
                    jump = { history = true, register = true, nohlsearch = true },
                    search = {
                        -- `forward` will be automatically set to the search direction
                        -- `mode` is always set to `search`
                        -- `encremental` is set to `true` when `incsearch` is enabled
                    },
                },
                -- options used when flash is activated through
                -- `f`, `F`, `t`, `T`, `;` and `,` motions
                -- options used for treesitter selections
                -- `require("flash").treesitter()`
                treesitter = {
                    labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                    jump = { pos = "range", autojump = true },
                    search = { incremental = false },
                    label = { before = true, after = true, style = "inline" },
                    highlight = {
                        backdrop = false,
                        matches = false,
                    },
                },
                treesitter_search = {
                    jump = { pos = "range" },
                    search = { multi_window = true, wrap = true, incremental = false },
                    remote_op = { restore = true },
                    label = { before = true, after = true, style = "inline" },
                },
                -- options used for remote flash
                remote = {
                    remote_op = { restore = true, motion = true },
                },
            },
            -- options for the floating window that shows the prompt,
            -- for regular jumps
            -- `require("flash").prompt()` is always available to get the prompt text
            prompt = {
                enabled = true,
                prefix = { { "", "FlashPromptIcon" } },
                win_config = {
                    relative = "cursor",
                    width = 1, -- when <=1 it's a percentage of the editor width
                    height = 1,
                    row = -1, -- when negative it's an offset from the bottom
                    col = 0, -- when negative it's an offset from the right
                    zindex = 1000,
                },
            },
            -- options for remote operator pending mode
            remote_op = {
                -- restore window views and cursor position
                -- after doing a remote operation
                restore = false,
                -- For `jump.pos = "range"`, this setting is ignored.
                -- `true`: always enter a new motion when doing a remote operation
                -- `false`: use the window's cursor position and jump target
                -- `nil`: act as `true` for remote windows, `false` for the current window
                motion = false,
            },
        })
    end,
}
