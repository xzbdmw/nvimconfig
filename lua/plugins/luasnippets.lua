return {
    "L3MON4D3/LuaSnip",
    version = false,
    -- lazy = false,
    enabled = false,
    event = "InsertEnter",
    keys = function()
        return {
            {
                "<C-n>",
                mode = { "s" },
                function()
                    local luasnip = require("luasnip")
                    if luasnip.jumpable(1) then
                        _G.no_animation(_G.CI)
                        luasnip.jump(1)
                    end
                end,
                { silent = true },
            },
            {
                "<C-n>",
                mode = { "i" },
                function()
                    local luasnip = require("luasnip")
                    if luasnip.jumpable(1) then
                        _G.no_animation(_G.CI)
                        luasnip.jump(1)
                    end
                end,
                { silent = true },
            },
            {
                "<C-p>",
                mode = { "i", "s" },
                function()
                    local luasnip = require("luasnip")
                    if luasnip.jumpable(-1) then
                        _G.no_animation(_G.CI)
                        luasnip.jump(-1)
                    end
                end,
                { silent = true },
            },
        }
    end,
    build = "make install_jsregexp",
    config = function()
        local types = require("luasnip.util.types")
        local ls = require("luasnip")

        local fmta = require("luasnip.extras.fmt").fmta
        local rep = require("luasnip.extras").rep

        local s = ls.snippet
        local c = ls.choice_node
        local d = ls.dynamic_node
        local i = ls.insert_node
        local f = ls.function_node
        local t = ls.text_node
        local sn = ls.snippet_node
        local postfix = require("luasnip.extras.postfix").postfix
        -- Map of default values for types.
        -- Some have a bit more complicated default values,
        -- but that's OK :) Lua is flexible enough!
        local default_values = {
            int = "0",
            bool = "false",
            string = '""',

            error = function(_, info)
                if info then
                    info.index = info.index + 1

                    return c(info.index, {
                        t(info.err_name),
                        t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
                    })
                else
                    return t("err")
                end
            end,

            -- Types with a "*" mean they are pointers, so return nil
            [function(text)
                return string.find(text, "*", 1, true) ~= nil
            end] = function(_, _)
                return t("nil")
            end,

            -- Convention: Usually no "*" and Capital is a struct type, so give the option
            -- to have it be with {} as well.
            [function(text)
                return not string.find(text, "*", 1, true)
                    and string.upper(string.sub(text, 1, 1)) == string.sub(text, 1, 1)
            end] = function(text, info)
                info.index = info.index + 1
                return c(info.index, {
                    t(text .. "{}"),
                    t(text),
                })
            end,
        }

        --- Transforms some text into a snippet node
        ---@param text string
        ---@param info table
        local transform = function(text, info)
            --- Determines whether the key matches the condition
            local condition_matches = function(condition, ...)
                if type(condition) == "string" then
                    return condition == text
                else
                    return condition(...)
                end
            end

            -- Find the matching condition to get the correct default value
            for condition, result in pairs(default_values) do
                if condition_matches(condition, text, info) then
                    if type(result) == "string" then
                        return t(result)
                    else
                        return result(text, info)
                    end
                end
            end

            -- If no matches are found, just return the text, can fix up easily
            return t(text)
        end

        -- Maps a node type to a handler function.
        local handlers = {
            parameter_list = function(node, info)
                local result = {}

                local count = node:named_child_count()
                for idx = 0, count - 1 do
                    local matching_node = node:named_child(idx)
                    local type_node = matching_node:field("type")[1]
                    table.insert(result, transform(vim.treesitter.get_node_text(type_node, 0), info))
                    if idx ~= count - 1 then
                        table.insert(result, t({ ", " }))
                    end
                end

                return result
            end,

            type_identifier = function(node, info)
                local text = vim.treesitter.get_node_text(node, 0)
                return { transform(text, info) }
            end,
        }

        --- Gets the corresponding result type based on the
        --- current function context of the cursor.
        ---@param info table
        local function go_result_type(info)
            local function_node_types = {
                function_declaration = true,
                method_declaration = true,
                func_literal = true,
            }

            -- Find the first function node that's a parent of the cursor
            local node = vim.treesitter.get_node()
            while node ~= nil do
                if function_node_types[node:type()] then
                    break
                end

                node = node:parent()
            end

            -- Exit if no match
            if not node then
                vim.notify("Not inside of a function")
                return t("")
            end
            -- This file is in `queries/go/return-snippet.scm`
            local query = assert(vim.treesitter.query.get("go", "return-snippet"), "No query")
            for _, capture in query:iter_captures(node, 0) do
                if handlers[capture:type()] then
                    return handlers[capture:type()](capture, info)
                end
            end
        end

        local go_return_values = function(args)
            return sn(
                nil,
                go_result_type({
                    index = 0,
                    err_name = "err",
                    func_name = args[1][1],
                })
            )
        end

        -- ls.add_snippets("go", {
        --     s(
        --         "efi",
        --         fmta(
        --             [[
        --            <val>, err := <f>
        --            if err != nil {
        --             return <result>
        --            }
        --            <finish>
        --            ]],
        --             {
        --                 val = i(1, "v"),
        --                 f = i(2),
        --                 result = d(3, go_return_values, { 2 }),
        --                 finish = i(0),
        --             }
        --         )
        --     ),
        --     s("ie", fmta("if err != nil {\n\treturn <err>\n}", { err = i(1, "err") })),
        -- })
        ls.add_snippets("lua", {
            s(
                "block",
                fmta(
                    [[
                    if vim.g.<start> then
                        local n = 1
                        for i = 1, 1000000000 do
                            n = n + 1
                        end
                    end
                    <finish>
                    ]],
                    {
                        start = i(1),
                        ["finish"] = i(0),
                    }
                )
            ),
        })
        ls.add_snippets("lua", {
            s(
                "can",
                fmta(
                    [[
                    _G.set_cursor_animation(<finish>)
                    ]],
                    {
                        ["finish"] = i(0, "0.0"),
                    }
                )
            ),
        })
        ls.add_snippets("lua", {
            s(
                "cursor",
                fmta(
                    [[
                    vim.g.neovide_cursor_animation_length = 0.0
                    vim.defer_fn(function()
                        vim.g.neovide_cursor_animation_length = 0.06
                    end, 100)<finish>
                    ]],
                    {
                        ["finish"] = i(0),
                    }
                )
            ),
        })
        ls.add_snippets("lua", {
            s(
                "lo",
                fmta(
                    [[
                    local <finish>
                    ]],
                    {
                        ["finish"] = i(0),
                    }
                )
            ),
        })
        ls.add_snippets("lua", {
            s(
                "infer",
                fmta(
                    [[
                    require("plenary.profile").start("profilef.log", { flame = true })
                    <finish>
                    require("plenary.profile").stop()
                    ]],
                    {
                        finish = i(0),
                    }
                )
            ),
        })
        ls.add_snippets("lua", {
            s(
                "aver",
                fmta(
                    [[
	            <finish>local i = 0
	            local sum = 0

	            local time = vim.uv.hrtime()

	            i = i + 1
	            local duration = 0.000001 * (vim.loop.hrtime() - time)
	            sum = sum + duration
	            if i == <count> then
		                -- __AUTO_GENERATED_PRINT_VAR_START__
		                print([==[sum:]==], vim.inspect(sum / <rep>)) -- __AUTO_GENERATED_PRINT_VAR_END__
		                i = 0
		                sum = 0
	            end
                    ]],
                    {
                        count = i(1, "10"),
                        rep = rep(1),
                        finish = i(0),
                    }
                )
            ),
        })
        ls.add_snippets("lua", {
            s(
                "perf",
                fmta(
                    [[
                    local time = vim.uv.hrtime()
                    Time(time, "<finish>")
                    ]],
                    {
                        finish = i(0),
                    }
                )
            ),
        })
        ls.add_snippets("go", {
            s(
                "eff",
                fmta(
                    [[
                    <val>, err := <f>
                    <finish>
                    ]],
                    {
                        val = i(2, "val"),
                        f = i(1),
                        finish = i(0),
                    }
                )
            ),
            s("ie", fmta("if err != nil {\n\treturn <err>\n}", { err = i(1, "err") })),
        })
        ls.add_snippets("go", {
            postfix(".wrap", {
                d(1, function(_, parent)
                    return sn(
                        1,
                        fmta("<err>(" .. parent.snippet.env.POSTFIX_MATCH .. ")<finish>", {
                            err = i(1, "type"),
                            finish = i(0),
                        })
                    )
                end),
            }),
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
                    --[[ active = {
                        -- highlight the text inside the node red.
                        hl_group = "LualineCursorLine",
                        priority = 1,
                    }, ]]
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
                    -- visited = {
                    --     hl_group = "Unvisited",
                    -- },
                },
                -- Add this to also have a placeholder in the final tabstop.
                -- See the discussion below for more context.
                --[[ [types.exitNode] = {
                    unvisited = {
                        virt_text = { { "|", "Conceal" } },
                        virt_text_pos = "inline",
                    },
                }, ]]
            },
        })
    end,
}
