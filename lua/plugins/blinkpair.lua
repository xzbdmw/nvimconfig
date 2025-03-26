return {
    "saghen/blink.pairs",
    enabled = false,
    -- version = "*", -- (recommended) only required with prebuilt binaries

    -- download prebuilt binaries from github releases
    dependencies = "saghen/blink.download",
    -- OR build from source
    build = "cargo build --release",
    -- OR build from source with nix
    build = "nix build .#build-plugin",

    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
        mappings = {
            enabled = true,
            pairs = {
                ["("] = ")",
                ["["] = "]",
                ["{"] = "}",
                ["'"] = { closing = "'", enter = false },
                ['"'] = { closing = '"', enter = false },
                ["`"] = { closing = "`", enter = false },
            },
        },
        highlights = {
            enabled = true,
            groups = {
                "BlinkPairsOrange",
                "BlinkPairsPurple",
                "BlinkPairsBlue",
            },
            priority = 200,
            ns = vim.api.nvim_create_namespace("blink.pairs"),
        },
        debug = false,
    },
}
