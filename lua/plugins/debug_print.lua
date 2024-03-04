return {
    "andrewferrier/debugprint.nvim",
    enabled = false,
    opts = {
        create_keymaps = false,
        create_commands = false,
        display_counter = false,
        print_tag = "[D]",
        move_to_debugline = true,
    },
    -- Dependency only needed for NeoVim 0.8
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    -- Remove the following line to use development versions,
    -- not just the formal releases
    version = false,
    config = function(_, opts)
        require("debugprint").setup(opts)
        vim.keymap.set("n", "<Leader>d", function()
            -- Note: setting `expr=true` and returning the value are essential
            return require("debugprint").debugprint()
        end, {
            expr = true,
        })
        vim.keymap.set("n", "<Leader>D", function()
            -- Note: setting `expr=true` and returning the value are essential
            return require("debugprint").debugprint({ above = true })
        end, {
            expr = true,
        })
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
        vim.keymap.set("n", "<Leader>Dq", function()
            -- Note: setting `expr=true` and returning the value are essential
            return require("debugprint").debugprint({ above = true, variable = true })
        end, {
            expr = true,
        })
        vim.keymap.set("n", "<Leader>do", function()
            -- Note: setting `expr=true` and returning the value are essential
            -- It's also important to use motion = true for operator-pending motions
            return require("debugprint").debugprint({ motion = true })
        end, {
            expr = true,
        })
        vim.keymap.set("n", "<Leader>vc", function()
            return require("debugprint").deleteprints()
        end)
    end,
}
