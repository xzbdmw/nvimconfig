return {
    "mrcjkb/rustaceanvim",
    init = function()
        local ns = vim.api.nvim_create_namespace("onTypeFormatting")
        vim.on_key(function(_, typed)
            if (typed == "<" or typed == "=") and vim.bo.filetype == "rust" then
                vim.schedule(function()
                    require("config.utils").onTypeFormatting()
                end)
            end
        end, ns)
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
                        typing = {
                            triggerChars = ".={<(",
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                        completion = {
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
                            closingBraceHints = {
                                enable = false,
                            },
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
    end,
    -- enabled = false,
    -- version = "^3", -- Recommended
    -- commit = "d08053f7fbda681b92a074a81e59d22539124cab",
    -- commit = "d6fd0b78e49ff4dd37070155e9f14fd26f2ef53f",
    ft = { "rust" },
}
