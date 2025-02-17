return {
    "saghen/blink.cmp",
    enabled = false,
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- On musl libc based systems you need to add this flag
    -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',
    config = function()
        require("blink.cmp").setup({
            snippets = {
                -- Function to use when expanding LSP provided snippets
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
                ["<c-n>"] = {},
                ["<c-p>"] = {},
            },
            cmdline = {
                sources = {},
            },
            completion = {
                menu = {
                    draw = {
                        -- We don't need label_description now because label and label_description are already
                        -- conbined together in label by colorful-menu.nvim.
                        columns = { { "kind_icon" }, { "label", gap = 2 }, { "provider" } },
                        components = {
                            label = {
                                -- width = { fill = true, max = 110 },
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                            provider = {
                                text = function(ctx)
                                    return "[" .. ctx.item.source_name:sub(1, 3):upper() .. "]"
                                end,
                                highlight = "BlinkCmpKindLabel",
                            },
                        },
                    },
                },
            },
        })
    end,
}
