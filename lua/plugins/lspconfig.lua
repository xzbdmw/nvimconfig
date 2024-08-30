_G.reference = false
return {
    {
        "neovim/nvim-lspconfig",
        init = function()
            vim.lsp.handlers["textDocument/signatureHelp"] = require("config.utils").signature_help
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            -- disable a keymap
            keys[#keys + 1] = { "K", false }
            keys[#keys + 1] = { "<leader>cr", false }
            keys[#keys + 1] = { "<leader>rn", false }
            keys[#keys + 1] = {
                "<leader>i",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = nil }))
                end,
            }
            keys[#keys + 1] = {
                "<leader>cc",
                false,
            }
            keys[#keys + 1] = {
                "<leader>ca",
                false,
                mode = { "n", "v" },
            }
            keys[#keys + 1] = {
                "<f7>",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = nil }))
                end,
                mode = { "x", "v", "n", "i" },
            }
            keys[#keys + 1] = {
                "gI",
                function()
                    vim.cmd("Glance implementations")
                end,
            }
            keys[#keys + 1] = {
                "<leader><C-i>",
                function()
                    vim.cmd("Telescope lsp_implementations")
                end,
            }
            keys[#keys + 1] = {
                "<leader><C-d>",
                function()
                    _G.reference = true
                    vim.cmd("Glance references")
                end,
            }
            keys[#keys + 1] = {
                "gt",
                vim.lsp.buf.type_definition,
            }
            keys[#keys + 1] = {
                "gh",
                vim.lsp.buf.hover,
                desc = "hover in lsp",
            }
        end,
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "E",
                        [vim.diagnostic.severity.WARN] = "W",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                    },
                },
                virtual_text = false,
            },
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            inlay_hints = { enabled = false },
            servers = {
                volar = {
                    init_options = {
                        typescript = {
                            tsdk = "/Users/xzb/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib",
                        },
                    },
                },
                pylance = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                            },
                            -- semantic = {
                            --     enable = false,
                            -- },
                            workspace = {
                                library = {
                                    "${3rd}/luv/library",
                                    "/usr/local/share/nvim/runtime",
                                    "~/.config/nvim/lua",
                                },
                            },
                            hint = {
                                enable = true,
                                ["setType"] = true,
                                ["paramType"] = true,
                            },
                        },
                    },
                },
                tsserver = {
                    enabled = true,
                    -- cmd = lsp_containers.command("tsserver"),
                    init_options = {
                        plugins = {
                            {
                                name = "@vue/typescript-plugin",
                                location = "/Users/xzb/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server",
                                languages = { "typescript", "vue" },
                            },
                        },
                    },
                    filetypes = {
                        "javascript",
                        "typescript",
                        "vue",
                    },
                },
                gopls = {
                    mason = false,
                    settings = {
                        gopls = {
                            usePlaceholders = true,
                            completeFunctionCalls = true,
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                -- parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            semanticTokens = true,
                            experimentalPostfixCompletions = true,
                            analyses = {
                                unusedparams = true,
                                shadow = true,
                            },
                            staticcheck = false,
                        },
                        --[[ init_options = {
                            usePlaceholders = true,
                            completeFunctionCalls = true,
                        }, ]]
                    },
                },
                clangd = {
                    cmd = { "clangd", "--completion-style=detailed" },
                },
            },
        },
    },
}
