return {
    "L3MON4D3/LuaSnip",
    version = false,
    keys = function()
        return {
            {
                "<C-n>",
                mode = { "i", "s", "n" },
                function()
                    require("luasnip").jump(1)
                end,
                { silent = true },
            },
            -- {
            --     "<C->",
            --     mode = { "i", "s", "n" },
            --     function()
            --         require("luasnip").jump(-1)
            --     end,
            --     { silent = true },
            -- },
        }
    end,

    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    -- lazy = false,
    config = function()
        local types = require("luasnip.util.types")
        local ls = require("luasnip")
        local sn = ls.snippet_node
        local s = ls.s
        local i = ls.insert_node
        local f = ls.function_node
        local t = ls.text_node
        local d = ls.dynamic_node
        local a = "2123"
        local rep = require("luasnip.extras").rep
        local fmt = require("luasnip.extras.fmt").fmt
        local postfix = require("luasnip.extras.postfix").postfix
        -- ls.add_snippets("lua", { ls.parser.parse_snippet("expand", "kkkkkk") })
        -- ls.add_snippets("lua", { s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })) })
        -- ls.add_snippets("lua", { ls.parser.parse_snippet("lf", "local $1 = function($2)\n $0\nend") })
        ls.add_snippets("go", {
            postfix(".byte", {
                f(function(_, parent)
                    return "[]byte(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                end, {}),
            }),
            postfix(".u32", {
                f(function(_, parent)
                    return "uint32(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                end, {}),
            }),
            postfix(".u64", {
                f(function(_, parent)
                    return "uint64(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                end, {}),
            }),
            postfix(".i32", {
                f(function(_, parent)
                    return "int32(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                end, {}),
            }),
            postfix(".i64", {
                f(function(_, parent)
                    return "int64(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                end, {}),
            }),
        })
        ls.setup({
            ext_base_prio = 200,
            ext_prio_increase = 2,
            history = true,
            updateevents = "TextChanged,TextChangedI",
            ext_opts = {
                [types.insertNode] = {
                    active = {
                        -- highlight the text inside the node red.
                        hl_group = "LualineCursorLine",
                        priority = 1,
                    },
                    --[[ these ext_opts are applied when the node is not active, but
                the snippet still is.
                passive = {
                    hl_group = "Unvisited",
                    -- add virtual text on the line of the node, behind all text.
                    -- virt_text = { { "virtual text!!", "GruvboxBlue" } },
                }, ]]
                    unvisited = {
                        hl_group = "Unvisited",
                        priority = 1,
                    },
                    --[[ visited = {
                    hl_group = "Unvisited",
                }, ]]
                },
                -- Add this to also have a placeholder in the final tabstop.
                -- See the discussion below for more context.
                [types.exitNode] = {
                    unvisited = {
                        virt_text = { { "|", "Conceal" } },
                        virt_text_pos = "inline",
                    },
                },
            },
        })
    end,
}
