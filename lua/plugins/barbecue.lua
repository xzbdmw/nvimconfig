return {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    enabled = false,
    version = false,
    -- event = "VeryLazy",
    lazy = false,
    dependencies = {
        "SmiteshP/nvim-navic",
        -- "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function()
        require("barbecue").setup({
            theme = {
                -- this highlight is used to override other highlights
                -- you can take advantage of its `bg` and set a background throughout your winbar
                -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
                -- normal = { bg = "#FAF7E8", fg = "#3D4D56" },
                -- normal = { bg = "#24273A", fg = "#CAD3F5" },

                -- these highlights correspond to symbols table from config
                -- ellipsis = { fg = "#3D4D56" },
                -- separator = { fg = "#3D4D56" },
                -- modified = { fg = "#3D4D56" },

                -- these highlights represent the _text_ of three main parts of barbecue
                -- dirname = { fg = "#3D4D56" },
                -- basename = { bold = true, italic = true },
                -- context = { fg = "#ac8fe4" },
                --
                -- -- these highlights are used for context/navic icons
                -- context_file = { fg = "#ac8fe4" },
                -- context_module = { fg = "#ac8fe4" },
                -- context_namespace = { fg = "#ac8fe4" },
                -- context_package = { fg = "#ac8fe4" },
                -- context_class = { fg = "#ac8fe4" },
                -- context_method = { fg = "#ac8fe4" },
                -- context_property = { fg = "#ac8fe4" },
                -- context_field = { fg = "#ac8fe4" },
                -- context_constructor = { fg = "#ac8fe4" },
                -- context_enum = { fg = "#ac8fe4" },
                -- context_interface = { fg = "#ac8fe4" },
                -- context_function = { fg = "#ac8fe4" },
                -- context_variable = { fg = "#ac8fe4" },
                -- context_constant = { fg = "#ac8fe4" },
                -- context_string = { fg = "#ac8fe4" },
                -- context_number = { fg = "#ac8fe4" },
                -- context_boolean = { fg = "#ac8fe4" },
                -- context_array = { fg = "#ac8fe4" },
                -- context_object = { fg = "#ac8fe4" },
                -- context_key = { fg = "#ac8fe4" },
                -- context_null = { fg = "#ac8fe4" },
                -- context_enum_member = { fg = "#ac8fe4" },
                -- context_struct = { fg = "#ac8fe4" },
                -- context_event = { fg = "#ac8fe4" },
                -- context_operator = { fg = "#ac8fe4" },
                -- context_type_parameter = { fg = "#ac8fe4" },
            },
            show_navic = false,
            symbols = {
                separator = ">",
            },
            kinds = {
                Array = "  ",
                Boolean = " 󰨙 ",
                Class = " 󰯳 ",
                Codeium = " 󰘦 ",
                Color = "  ",
                Control = "  ",
                Collapsed = "  ",
                Constant = " 󰯱 ",
                Constructor = "  ",
                Copilot = "  ",
                Enum = " 󰯹 ",
                EnumMember = "  ",
                Event = "  ",
                Field = "  ",
                File = "  ",
                Folder = "  ",
                Function = " 󰊕 ",
                Interface = " 󰰅 ",
                Key = "  ",
                Keyword = " 󱕴 ",
                Method = " 󰰑 ",
                Module = " 󰆼 ",
                Namespace = " 󰰔 ",
                Null = "  ",
                Number = " 󰰔 ",
                Object = " 󰲟 ",
                Operator = "  ",
                Package = " 󰰚 ",
                Property = " 󰲽 ",
                Reference = " 󰰠 ",
                Snippet = "  ",
                String = "  ",
                Struct = " 󰰣 ",
                TabNine = " 󰏚 ",
                Text = " 󱜥 ",
                TypeParameter = " 󰰦 ",
                Unit = " 󱜥 ",
                Value = "  ",
                Variable = " 󰄛 ",
            },
        })
        vim.api.nvim_set_hl(0, "barbecue_dirname", { fg = "#8F98B8" })
        vim.api.nvim_set_hl(0, "barbecue_basename", { fg = "#CAD3F5" })
    end,
}
