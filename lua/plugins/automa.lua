return {
    "hrsh7th/nvim-automa",
    enabled = false,
    config = function()
        local automa = require("automa")
        automa.setup({
            mapping = {
                ["."] = {
                    queries = {
                        -- for `diwi***<Esc>`
                        automa.query_v1({ "n", "no+", "n", "i*" }),
                        -- for `x`
                        automa.query_v1({ "n#" }),
                        -- for `i***<Esc>`
                        automa.query_v1({ "n", "i*" }),
                        -- for `vjjj>`
                        automa.zzz({ "n", "v*" }),
                    },
                },
            },
        })
    end,
}
