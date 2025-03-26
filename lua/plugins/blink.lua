return {
    "saghen/blink.cmp",
    enabled = false,
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },

    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- On musl libc based systems you need to add this flag
    -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',
    config = function()
        require("blink.cmp").setup({
            snippets = {
                expand = function(snippet)
                    if require("multicursor-nvim").numCursors() > 1 then
                        vim.snippet.expand(snippet)
                        return
                    end
                    require("mini.snippets").default_insert(
                        { body = snippet },
                        { empty_tabstop = "", empty_tabstop_final = "" }
                    )
                end,
            },
            keymap = {
                preset = "enter",
                ["<d-d>"] = { "show_documentation" },
                ["<c-e>"] = { "fallback" },
                ["<c-c>"] = { "hide" },
            },
            cmdline = {
                keymap = {
                    preset = "none",
                    -- stylua: ignore start
                    ["<c-n>"] = { function() FeedKeys("<down>", "n") end },
                    ["<c-p>"] = { function() FeedKeys("<up>", "n") end },
                    ["<Tab>"] = { function() FeedKeys("<CR>", "n") end },
                    -- stylua: ignore end
                    ["<down>"] = { "select_next" },
                    ["<up>"] = { "select_prev" },
                    ["<cr>"] = {
                        function()
                            if vim.fn.getcmdtype() == ":" then
                                require("blink.cmp").accept()
                            else
                                FeedKeys("<cr>", "n")
                            end
                        end,
                    },
                },
                completion = {
                    menu = {
                        auto_show = true,
                    },
                },
            },
            fuzzy = {
                sorts = {
                    -- (optionally) always prioritize exact matches
                    "exact",

                    -- pass a function for custom behavior
                    function(item_a, item_b)
                        return require("config.cmpformat").sort(item_a.kind, item_b.kind)
                    end,

                    "score",
                    "sort_text",
                },
            },
            sources = {
                default = { "lsp", "buffer", "snippets", "path" },
                providers = {
                    lsp = {
                        name = "LSP",
                        module = "blink.cmp.sources.lsp",
                        fallbacks = { "buffer" },
                        transform_items = function(_, items)
                            -- filter out text items, since we have the buffer source
                            return vim.tbl_filter(function(item)
                                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
                            end, items)
                        end,
                    },
                    path = {
                        module = "blink.cmp.sources.path",
                        score_offset = 3,
                        fallbacks = { "buffer" },
                    },
                    buffer = {
                        opts = {
                            -- or (recommended) filter to only "normal" buffers
                            get_bufnrs = function()
                                return { vim.api.nvim_get_current_buf() }
                            end,
                        },
                    },
                },
            },
            completion = {
                ghost_text = { enabled = true },
                menu = {
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 2 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
            },
        })
    end,
}
