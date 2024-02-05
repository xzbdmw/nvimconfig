local types = require("luasnip.util.types")
return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    opts = {
        ext_opts = {
            [types.insertNode] = {
                active = {
                    -- highlight the text inside the node red.
                    hl_group = "LualineCursorLine",
                },
                -- these ext_opts are applied when the node is not active, but
                -- the snippet still is.
                passive = {
                    hl_group = "Unvisited",
                    -- add virtual text on the line of the node, behind all text.
                    -- virt_text = { { "virtual text!!", "GruvboxBlue" } },
                },
                -- unvisited = {
                --     --     -- virt_text = { { "|", "Conceal" } },
                --     hl_group = "CmpItemKindProperty",
                --     --     -- virt_text_pos = "inline",
                -- },
                visited = {
                    hl_group = "Unvisited",
                },
            },
            -- Add this to also have a placeholder in the final tabstop.
            -- See the discussion below for more context.
            [types.exitNode] = {
                unvisited = {
                    virt_text = { { "│", "Conceal" } },
                    virt_text_pos = "inline",
                },
            },
        },
    },
}
