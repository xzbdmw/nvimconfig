return {
    "chrisgrieser/nvim-chainsaw",
    enabled = false,
    event = "VeryLazy",
    keys = {
        {
            "<d-y>",
            function()
                require("chainsaw").variableLog()
            end,
            mode = "o",
        },
    },
    opts = {}, -- required even if left empty
}
