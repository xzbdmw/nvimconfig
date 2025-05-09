return {
    "kevinhwang91/nvim-fundo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    build = function()
        require("fundo").install()
    end,
    config = function()
        require("fundo").setup()
    end,
}
