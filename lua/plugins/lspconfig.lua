local function lsp_references_with_jump()
    -- 在当前位置设置一个标记
    vim.cmd("normal! m'")

    -- 调用 Telescope lsp_references
    -- vim.cmd("Telescope lsp_references")

    require("telescope.builtin").lsp_references({
        layout_strategy = "cursor",
        -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        layout_config = {
            cursor = {
                width = 0.9,
                height = 0.5,
                preview_width = 0.5,
            },
        },
    })
end

return {
    {
        "neovim/nvim-lspconfig",
        -- lazy = false,
        init = function()
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            -- disable a keymap
            keys[#keys + 1] = { "K", false }
            keys[#keys + 1] = { "<leader>cr", false }
            keys[#keys + 1] = {
                "<leader>i",
                function()
                    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
                end,
            }
            keys[#keys + 1] = {
                "<f7>",
                function()
                    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
                end,
                mode = { "x", "v", "n", "i" },
            }
            keys[#keys + 1] = {
                "<C-a>",
                function()
                    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>ca", true, false, true), "t", true)
                    vim.cmd([[:stopinsert]])
                    vim.cmd("Lspsaga code_action")
                end,
                desc = "Code Action",
                mode = { "i", "n", "v" },
                has = "codeAction",
            }

            keys[#keys + 1] = {
                "<leader>ca",
                function()
                    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>ca", true, false, true), "t", true)
                    vim.cmd("Lspsaga code_action")
                end,
                desc = "Code Action",
                has = "codeAction",
            }
            keys[#keys + 1] = { "gr", lsp_references_with_jump }
            keys[#keys + 1] = {
                "gh",
                function()
                    vim.lsp.buf.hover()
                    --[[ vim.defer_fn(function()
                        vim.lsp.buf.hover()
                    end, 100) ]]
                end,
                desc = "hover in lsp",
            }
        end,
        opts = {
            diagnostics = {
                underline = false,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    -- prefix = "icons",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                    },
                },
            },
            -- add any global capabilities here
            capabilities = {},
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            inlay_hints = { enabled = false },
            servers = {
                pylance = {
                    settings = {
                        python = {
                            -- pythonPath = "/usr/bin/python3",
                            analysis = {
                                inlayHints = {
                                    variableTypes = true,
                                    functionReturnTypes = true,
                                    callArgumentNames = true,
                                    pytestParameters = true,
                                },
                            },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            -- completion = {
                            --     callSnippet = "Disable",
                            -- },
                            --[[ runtime = {
                                -- LuaJIT in the case of Neovim
                                version = "LuaJIT",
                                pathStrict = true,
                                path = {
                                    "lua/?.lua",
                                },
                            }, ]]
                            workspace = {
                                library = {
                                    -- "/Users/xzb/.local/share/nvim/lazy/neodev.nvim/types/stable",
                                    -- "/Users/xzb/.local/share/nvim/lazy/neodev.nvim/types/nightly",
                                    "/Users/xzb/Downloads/nvim-macos/share/nvim/runtime/lua/",
                                    -- "/Users/xzb/.local/share/nvim/lazy/neoconf.nvim/types",
                                    -- "/Users/xzb/.local/share/nvim/lazy/nvim-cmp/lua/cmp/",
                                    -- "/Users/xzb/.local/share/nvim/lazy/nvim-cmp/",
                                    -- "/Users/xzb/.local/share/nvim/lazy/telescope.nvim/lua/telescope/",
                                    -- "/Users/xzb/.local/share/nvim/lazy/LuaSnip/lua/luasnip/",
                                },
                            },
                        },
                    },
                },
                --[[ rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = true,
                            check = {
                                enable = true,
                                command = "clippy",
                                features = "all",
                            },
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
                        },
                    },
                }, ]]
                tsserver = { enabled = false },
                gopls = {
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
                            experimentalPostfixCompletions = false,
                            analyses = {
                                unusedparams = true,
                                shadow = true,
                            },
                            staticcheck = false,
                        },
                    },
                },
            },
        },
        --[[ config = function(_, opts)
            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available through mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
            end
        end, ]]
    },
}
