return {
    "andrewferrier/debugprint.nvim",
    enabled = false,
    opts = {
        create_keymaps = false,
        create_commands = false,
        display_counter = false,
        print_tag = "[DEBUG]",
        move_to_debugline = false,
    },
    -- not just the formal releases
    version = false,
    config = function(_, opts)
        require("debugprint").setup(opts)
        vim.keymap.set("n", "<Leader>vp", function()
            -- Note: setting `expr=true` and returning the value are essential
            return require("debugprint").debugprint({ variable = true })
        end, {
            expr = true,
        })
        vim.keymap.set("v", "<Leader>vp", function()
            -- Note: setting `expr=true` and returning the value are essential
            return require("debugprint").debugprint({ variable = true })
        end, {
            expr = true,
        })
        vim.keymap.set("n", "<Leader>cc", function()
            return require("debugprint").deleteprints()
        end)
    end,
}
