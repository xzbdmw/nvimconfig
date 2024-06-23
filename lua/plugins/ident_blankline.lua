return {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        local highlight = {}
        for i, color in pairs({ "#F4F1E9", "#F0F4E6", "#F7F6E3", "#FBF3E4" }) do
            local name = "IndentBlanklineIndent" .. i
            api.nvim_set_hl(0, name, { bg = color })
            table.insert(highlight, name)
        end
        require("ibl").setup({
            indent = {
                priority = 1,
                highlight = highlight,
                char = "",
            },
            whitespace = {
                highlight = highlight,
                remove_blankline_trail = false,
            },
            scope = { enabled = false },
        })
    end,
}
