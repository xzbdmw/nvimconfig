return {
    "kevinhwang91/nvim-fundo",
    enabled = false,
    dependencies = { {
        "kevinhwang91/promise-async",
    } },
    config = function()
        require("fundo").setup()
    end,
    -- enabled = false,
}
