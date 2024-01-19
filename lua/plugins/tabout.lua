-- https://github.com/abecodes/tabout.nvim

return {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
    },
    config = function()
        -- https://github.com/abecodes/tabout.nvim#more-complex-keybindings

        require("tabout").setup({
            tabkey = "", --'<Tab>',
            backwards_tabkey = "", --'<S-Tab>',
            act_as_tab = true,
            act_as_shift_tab = false,
            default_tab = "<C-t>",
            default_shift_tab = "<C-d>",
            enable_backwards = true,
            completion = true,
            tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = "`", close = "`" },
                { open = "(", close = ")" },
                { open = "[", close = "]" },
                { open = "{", close = "}" },
                { open = "<", close = ">" },
            },
            ignore_beginning = false,
            exclude = {},
        })

        -- handle <Tab> key to prioritize LuaSnip over Tabout

        local ls = require("luasnip")

        local function replace_keycodes(c)
            return vim.api.nvim_replace_termcodes(c, true, true, true)
        end

        function _G.tab_binding()
            if ls.expand_or_jumpable() then
                return replace_keycodes("<Plug>luasnip-expand-or-jump")
            else
                return replace_keycodes("<Plug>(Tabout)")
            end
        end

        function _G.s_tab_binding()
            if ls.jumpable(-1) then
                return replace_keycodes("<Plug>luasnip-jump-prev")
            else
                return replace_keycodes("<Plug>(TaboutBack)")
            end
        end

        vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_binding()", { expr = true })
        vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_binding()", { expr = true })
    end,
}
