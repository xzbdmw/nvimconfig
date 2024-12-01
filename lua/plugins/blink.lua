return {
    "saghen/blink.cmp",
    enabled = false,
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",

    -- use a release tag to download pre-built binaries
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- On musl libc based systems you need to add this flag
    -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',

    opts = {
        highlight = {
            -- sets the fallback highlight groups to nvim-cmp's highlight groups
            -- useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release, assuming themes add support
            use_nvim_cmp_as_default = true,
        },
        trigger = {
            completion = {
                keyword_range = "full",
            },
        },
        menu = {
            enabled = true,
            max_height = 30,
        },
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal",

        -- experimental auto-brackets support
        -- accept = { auto_brackets = { enabled = true } }

        -- experimental signature help support
        -- trigger = { signature_help = { enabled = true } }
    },
}
