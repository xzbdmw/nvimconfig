return {
    {
        "echasnovski/mini.surround",
        lazy = false,
        -- enabled = false,
        keys = function(plugin, keys)
            -- Populate the keys based on the user's options
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            local mappings = {
                { opts.mappings.add, desc = "Add surrounding", mode = { "n", "x" } },
                { opts.mappings.delete, desc = "Delete surrounding" },
                { opts.mappings.find, desc = "Find right surrounding" },
                { opts.mappings.find_left, desc = "Find left surrounding" },
                { opts.mappings.replace, desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            return vim.tbl_deep_extend("keep", mappings, keys)
        end,
        opts = function()
            return {
                custom_surroundings = {
                    f = {
                        input = { { "%f[%w_%.][%w_%.]+%b<>", "%f[%w_%.][%w_%.]+%b()" }, "^.-[<%(]().*()[>%)]$" },
                        output = function()
                            local fun_name = MiniSurround.user_input("Function name")
                            if fun_name == nil then
                                return nil
                            end
                            return { left = ("%s("):format(fun_name), right = ")" }
                        end,
                    },
                    ["("] = { input = { "%b()", "^.().*().$" }, output = { left = "(", right = ")" } },
                    ["["] = { input = { "%b[]", "^.().*().$" }, output = { left = "[", right = "]" } },
                    ["{"] = { input = { "%b{}", "^.().*().$" }, output = { left = "{", right = "}" } },
                    ["<"] = { input = { "%b<>", "^.().*().$" }, output = { left = "<", right = ">" } },
                    ["s"] = {
                        input = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
                        output = { left = "(", right = ")" },
                    },
                },
                mappings = {
                    add = "ma",
                    delete = "md",
                    find = "mf",
                    find_left = "mF",
                    highlight = "mH",
                    replace = "mc",
                    update_n_lines = "mN",
                },
            }
        end,
        config = function(_, opts)
            require("mini.surround").setup(opts)
            local keymap = vim.keymap.set
            local keymap_ops = { remap = true, silent = true }
            keymap("x", '"', 'ma"', keymap_ops)
            keymap("x", "'", "ma'", keymap_ops)
            keymap("x", "[[", "ma[", keymap_ops)
            keymap("x", "{", "ma{", keymap_ops)
            keymap("x", "(", "ma(", keymap_ops)
            keymap("x", "`", "ma`", keymap_ops)
        end,
    },
}
