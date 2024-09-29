return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        keys = {
            {
                "<leader>xb",
                function()
                    require("dap").toggle_breakpoint()
                end,
            },
        },
        config = function() end,
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        dependencies = { {
            "nvim-neotest/nvim-nio",
        } },
        keys = {
            {
                "<c-u>",
                function()
                    require("dapui").toggle()
                end,
            },
        },
        config = function()
            require("dapui").setup({
                controls = {
                    element = "repl",
                    enabled = true,
                    icons = {
                        disconnect = "",
                        pause = "",
                        play = "",
                        run_last = "",
                        step_back = "",
                        step_into = "",
                        step_out = "",
                        step_over = "",
                        terminate = "",
                    },
                },
                element_mappings = {},
                expand_lines = true,
                floating = {
                    border = "single",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                force_buffers = true,
                icons = {
                    collapsed = "󱦰",
                    current_frame = "󱦰",
                    expanded = "󱞩",
                },
                layouts = {
                    -- {
                    --     elements = {
                    --         {
                    --             id = "scopes",
                    --             size = 0.25,
                    --         },
                    --         {
                    --             id = "breakpoints",
                    --             size = 0.25,
                    --         },
                    --         {
                    --             id = "stacks",
                    --             size = 0.25,
                    --         },
                    --         {
                    --             id = "watches",
                    --             size = 0.25,
                    --         },
                    --     },
                    --     position = "left",
                    --     size = 40,
                    -- },
                    {
                        elements = {
                            {
                                id = "repl",
                                size = 0.21,
                            },
                            {
                                id = "scopes",
                                size = 0.4,
                            },
                            {
                                id = "stacks",
                                size = 0.39,
                            },
                        },
                        position = "bottom",
                        size = 10,
                    },
                },
                mappings = {
                    edit = "e",
                    expand = { "<CR>" },
                    open = { "o", "<2-LeftMouse>" },
                    remove = "d",
                    repl = "r",
                    toggle = "t",
                },
                render = {
                    indent = 0,
                    max_value_lines = 100,
                },
            })
        end,
    },
    {
        "leoluz/nvim-dap-go",
        config = function()
            require("dap-go").setup({
                -- Additional dap configurations can be added.
                -- dap_configurations accepts a list of tables where each entry
                -- represents a dap configuration. For more details do:
                -- :help dap-configuration
                dap_configurations = {
                    {
                        -- Must be "go" or it will be ignored by the plugin
                        type = "go",
                        name = "Attach remote",
                        mode = "remote",
                        request = "attach",
                    },
                },
                -- delve configurations
                delve = {
                    -- the path to the executable dlv which will be used for debugging.
                    -- by default, this is the "dlv" executable on your PATH.
                    path = "/Users/xzb/go/bin/dlv",
                    -- time to wait for delve to initialize the debug session.
                    -- default to 20 seconds
                    initialize_timeout_sec = 20,
                    -- a string that defines the port to start delve debugger.
                    -- default to string "${port}" which instructs nvim-dap
                    -- to start the process in a random available port.
                    -- if you set a port in your debug configuration, its value will be
                    -- assigned dynamically.
                    port = "${port}",
                    -- additional args to pass to dlv
                    args = {},
                    -- the build flags that are passed to delve.
                    -- defaults to empty string, but can be used to provide flags
                    -- such as "-tags=unit" to make sure the test suite is
                    -- compiled during debugging, for example.
                    -- passing build flags using args is ineffective, as those are
                    -- ignored by delve in dap mode.
                    -- avaliable ui interactive function to prompt for arguments get_arguments
                    build_flags = {},
                    -- whether the dlv process to be created detached or not. there is
                    -- an issue on Windows where this needs to be set to false
                    -- otherwise the dlv server creation will fail.
                    -- avaliable ui interactive function to prompt for build flags: get_build_flags
                    detached = vim.fn.has("win32") == 0,
                    -- the current working directory to run dlv from, if other than
                    -- the current working directory.
                    cwd = nil,
                },
                -- options related to running closest test
                tests = {
                    -- enables verbosity when running the test.
                    verbose = false,
                },
            })
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
        event = "User ToggleDebug",
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true, -- enable this plugin (the default)
                enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true, -- show stop reason when stopped for exceptions
                commented = false, -- prefix virtual text with comment string
                only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
                all_references = false, -- show virtual text on all all references of the variable (not only definitions)
                clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
                --- A callback that determines how a variable is displayed or whether it should be omitted
                display_callback = function(variable, buf, stackframe, node, options)
                    if options.virt_text_pos == "inline" then
                        return " = " .. variable.value
                    else
                        return variable.name .. " = " .. variable.value
                    end
                end,
                -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
                virt_text_pos = "eol",

                -- experimental features:
                all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
                virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
                -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
            })
        end,
    },
}
