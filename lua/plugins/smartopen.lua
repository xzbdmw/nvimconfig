return {
    "danielfalk/smart-open.nvim",
    event = "VeryLazy",
    branch = "0.2.x",
    config = function()
        require("telescope").load_extension("smart_open")
    end,
    dependencies = {
        "kkharji/sqlite.lua",
    },
}
