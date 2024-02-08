return {
    "danielfalk/smart-open.nvim",
    event = "VeryLazy",
    version = false,
    config = function()
        require("telescope").load_extension("smart_open")
    end,
    dependencies = {
        "kkharji/sqlite.lua",
    },
}
