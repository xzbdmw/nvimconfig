return {
    "altermo/ultimate-autopair.nvim",
    enabled = false,
    lazy = false,
    config = function()
        require("ultimate-autopair").setup({
            fastwarp = { -- *ultimate-autopair-map-fastwarp-config*
                enable = true,
                enable_normal = true,
                enable_reverse = true,
                hopout = false,
                --{(|)} > fastwarp > {(}|)
                map = "<d-y>", --string or table
                rmap = "<d-u>", --string or table
                cmap = "<A-e>", --string or table
                rcmap = "<A-E>", --string or table
                multiline = true,
                --(|) > fastwarp > (\n|)
                nocursormove = true,
                --makes the cursor not move (|)foo > fastwarp > (|foo)
                --disables multiline feature
                --only activates if prev char is start pair, otherwise fallback to normal
                do_nothing_if_fail = true,
                --add a module so that if fastwarp fails
                --then an `e` will not be inserted
                no_filter_nodes = { "string", "raw_string", "string_literals", "character_literal" },
                --which nodes to skip for tsnode filtering
                faster = false,
                --only enables jump over pair, goto end/next line
                --useful for the situation of:
                --{|}M.foo('bar') > {M.foo('bar')|}
                conf = {},
                --contains extension config
                multi = false,
                --use multiple configs (|ultimate-autopair-map-multi-config|)
            },
        })
    end,
}
