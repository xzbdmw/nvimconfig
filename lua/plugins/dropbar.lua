return {
    "Bekaboo/dropbar.nvim",
    dependencies = {
        "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {
        bar = {
            pick = {
                pivots = "hjkl;abcdefgmnopqrstuvwxyz",
            },
        },
        icons = {
            enable = true,
            kinds = {
                use_devicons = false,
                symbols = {
                    Array = "  ",
                    Boolean = " 󰨙 ",
                    Class = " 󰯳 ",
                    Codeium = " 󰘦 ",
                    Color = "  ",
                    Control = "  ",
                    Collapsed = " > ",
                    Constant = " 󰯱 ",
                    Constructor = "  ",
                    Copilot = "  ",
                    Enum = " 󰯹 ",
                    EnumMember = "  ",
                    Event = "  ",
                    Field = "  ",
                    File = "  ",
                    Folder = "  ",
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
            },
            ui = {
                bar = {
                    separator = " > ",
                    extends = "",
                },
                menu = {
                    separator = "",
                    indicator = ">",
                },
            },
        },
        menu = {
            keymaps = {
                ["h"] = "<C-w>c",
                ["left"] = "<C-w>c",
                ["p"] = "<C-w>c",
            },
            entry = {
                padding = {
                    left = 0,
                },
            },
        },
    },
}
