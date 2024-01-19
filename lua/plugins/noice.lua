return {
    "folke/noice.nvim",
    opts = {
        lsp = {
            signature = {
                auto_open = {
                    enabled = true,
                    trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                    luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                    throttle = 0, -- Debounce lsp signature help request by 50ms
                },
                enabled = false,
                opts = {
                    size = {
                        max_height = 10,
                    },
                },
            },
            hover = {
                opts = {
                    size = {
                        max_height = 15,
                    },
                },
            },
        },
    },
}
