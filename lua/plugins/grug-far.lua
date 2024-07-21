return {
    "MagicDuck/grug-far.nvim",
    version = false,
    config = function()
        require("grug-far").setup({
            -- debounce milliseconds for issuing search while user is typing
            -- prevents excessive searching
            debounceMs = 10,

            -- minimum number of chars which will cause a search to happen
            -- prevents performance issues in larger dirs
            minSearchChars = 2,

            -- disable automatic debounced search and trigger search when leaving insert mode instead
            searchOnInsertLeave = false,

            -- max number of parallel replacements tasks
            maxWorkers = 4,

            -- ripgrep executable to use, can be a different path if you need to configure
            rgPath = "rg",

            -- extra args that you always want to pass to rg
            -- like for example if you always want context lines around matches
            extraRgArgs = "",

            -- specifies the command to run (with `vim.cmd(...)`) in order to create
            -- the window in which the grug-far buffer will appear
            -- ex (horizontal bottom right split): 'botright split'
            -- ex (open new tab): 'tabnew %'
            windowCreationCommand = "vsplit",

            -- buffer line numbers + match line numbers can get a bit visually overwhelming
            -- turn this off if you still like to see the line numbers
            disableBufferLineNumbers = true,

            -- maximum number of search chars to show in buffer and quickfix list titles
            -- zero disables showing it
            maxSearchCharsInTitles = 30,

            -- static title to use for grug-far buffer, as opposed to the dynamically generated title.
            -- Note that nvim does not allow multiple buffers with the same name, so this option is meant more
            -- as something to be speficied for a particular instance as opposed to something set in the setup function
            -- nil or '' disables it
            staticTitle = nil,

            -- whether to start in insert mode,
            -- set to false for normal mode
            startInInsertMode = true,

            -- row in the window to position the cursor at at start
            startCursorRow = 3,

            -- shortcuts for the actions you see at the top of the buffer
            -- set to '' or false to unset. Mappings with no normal mode value will be removed from the help header
            -- you can specify either a string which is then used as the mapping for both normmal and insert mode
            -- or you can specify a table of the form { [mode] = <lhs> } (ex: { i = '<C-enter>', n = '<localleader>gr'})
            -- it is recommended to use <localleader> though as that is more vim-ish
            -- see https://learnvimscriptthehardway.stevelosh.com/chapters/11.html#local-leader
            keymaps = {
                replace = { n = "<localleader>r" },
                qflist = { n = "<localleader>q" },
                syncLocations = { n = "<localleader>s" },
                syncLine = { n = "<localleader>l" },
                close = { n = "<localleader>c" },
                historyOpen = { n = "<localleader>t" },
                historyAdd = { n = "<localleader>a" },
                refresh = { n = "<localleader>f" },
                openLocation = { n = "<localleader>o" },
                gotoLocation = { n = "<enter>" },
                pickHistoryEntry = { n = "<enter>" },
                abort = { n = "<localleader>b" },
                help = { n = "g?" },
                toggleShowRgCommand = { n = "<localleader>p" },
            },

            -- separator between inputs and results, default depends on nerdfont
            resultsSeparatorLineChar = "",

            -- highlight the results with TreeSitter, if available
            resultsHighlight = true,

            -- spinner states, default depends on nerdfont, set to false to disable
            spinnerStates = {
                "󱑋 ",
                "󱑌 ",
                "󱑍 ",
                "󱑎 ",
                "󱑏 ",
                "󱑐 ",
                "󱑑 ",
                "󱑒 ",
                "󱑓 ",
                "󱑔 ",
                "󱑕 ",
                "󱑖 ",
            },

            -- whether to report duration of replace/sync operations
            reportDuration = true,

            -- icons for UI, default ones depend on nerdfont
            -- set individual ones to '' to disable, or set enabled = false for complete disable
            icons = {
                -- whether to show icons
                enabled = true,

                actionEntryBullet = " ",

                searchInput = " ",
                replaceInput = " ",
                filesFilterInput = " ",
                flagsInput = "󰮚 ",

                resultsStatusReady = "󱩾 ",
                resultsStatusError = " ",
                resultsStatusSuccess = "󰗡 ",
                resultsActionMessage = "  ",
                resultsChangeIndicator = "┃",

                historyTitle = "   ",
                helpTitle = " 󰘥  ",
            },

            -- placeholders to show in input areas when they are empty
            -- set individual ones to '' to disable, or set enabled = false for complete disable
            placeholders = {
                -- whether to show placeholders
                enabled = true,

                search = "ex: foo    foo([a-z0-9]*)    fun\\(",
                replacement = "ex: bar    ${1}_foo    $$MY_ENV_VAR ",
                filesFilter = "ex: *.lua     *.{css,js}    **/docs/*.md",
                flags = "ex: --help --ignore-case (-i) <relative-file-path> --replace= (empty replace) --multiline (-U)",
            },

            -- strings to auto-fill in each input area at start
            -- those are not necessarily useful as global defaults but quite useful as overrides
            -- when launching through the lua api. For example, this is how you would launch grug-far.nvim
            -- with the current word under the cursor as the search string
            --
            -- require('grug-far').grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
            --
            prefills = {
                search = "",
                replacement = "",
                filesFilter = "",
                flags = "",
            },

            -- search history settings
            history = {
                -- maximum number of lines in history file, end of file will be smartly truncated
                -- to remove oldest entries
                maxHistoryLines = 10000,

                -- directory where to store history file
                historyDir = vim.fn.stdpath("state") .. "/grug-far",

                -- configuration for when to auto-save history entries
                autoSave = {
                    -- whether to auto-save at all, trumps all other settings below
                    enabled = true,

                    -- auto-save after a replace
                    onReplace = true,

                    -- auto-save after sync all
                    onSyncAll = true,

                    -- auto-save after buffer is deleted
                    onBufDelete = true,
                },
            },

            -- unique instance name. This is used as a handle to refer to a particular instance of grug-far when
            -- toggling visibility, etc.
            -- As this needs to be unique per instance, this option is meant to be speficied for a particular instance
            -- as opposed to something set in the setup function
            instanceName = nil,
        })
    end,
}
