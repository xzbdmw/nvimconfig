return {
    "danielfalk/smart-open.nvim",
    keys = {
        {
            "<D-e>",
            function()
                require("telescope").extensions.smart_open.smart_open({
                    on_complete = {
                        function()
                            if vim.o.lines == 31 or vim.o.lines == 30 then
                                require("config.utils").on_complete(
                                    "                                       ",
                                    "                                       ",
                                    16
                                )
                            else
                                require("config.utils").on_complete(
                                    "                                                     ",
                                    "                                                     ",
                                    18
                                )
                            end
                        end,
                    },
                    cwd_only = true,
                    default_text = "'",
                    show_scores = false,
                    ignore_patterns = { "*.git/*", "*/tmp/*" },
                    match_algorithm = "fzf",
                    disable_devicons = false,
                    open_buffer_indicators = { previous = "󱝂 ", others = "󰫣 " },
                    prompt_title = "",
                    initial_mode = "insert",
                    layout_strategy = "horizontal",
                    previewer = false,
                    layout_config = {
                        horizontal = {
                            width = (vim.o.lines == 31 or vim.o.lines == 30) and 0.30 or 0.32,
                            height = 0.7,
                        },
                        mirror = false,
                    },
                })
            end,
        },
    },
    lazy = true,
    -- lazy = false,
    version = false,
    config = function()
        require("telescope").load_extension("smart_open")
    end,
    dependencies = {
        "kkharji/sqlite.lua",
    },
}
