return {
    keys = {
        {
            "<c-u>",
            "<cmd>lua require('alternate-toggler').toggleAlternate()<CR>",
        },
    },
    "rmagatti/alternate-toggler",
    config = function()
        require("alternate-toggler").setup({
            alternates = {
                ["||"] = "&&",
                ["or"] = "and",
                ["=="] = function()
                    return vim.bo.filetype == "lua" and "~=" or "!="
                end,
                ["~="] = function()
                    return "=="
                end,
            },
        })
    end,
}
