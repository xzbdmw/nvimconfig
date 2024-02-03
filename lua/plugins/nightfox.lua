return {
    "EdenEast/nightfox.nvim",
    config = function()
        local options = {
            dim_inactive = false,
            -- module_default = false,
        }
        local palettes = {
            nightfox = {
                red = "#c94f6d",
            },
            nordfox = {
                comment = "#60728a",
            },
        }
        local specs = {
            dawnfox = {
                syntax = {
                    keyword = "#0033b3",
                    comment = "#7E7D7D",
                    conditional = "#0033b3",
                    func = "#215062",
                    number = "#0033B3",
                    operator = "#000000",
                    bracket = "#000000",
                    string = "#395C2A",
                    type = "#592479",
                    variable = "#000000",
                },
            },
        }
        local groups = {
            all = {
                IncSearch = { bg = "palette.cyan" },
            },
        }

        require("nightfox").setup({
            options = options,
            palettes = palettes,
            specs = specs,
            groups = groups,
        })
    end,
}
