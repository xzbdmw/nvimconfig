return {
    "echasnovski/mini.operators",
    version = false,
    config = function()
        require("mini.operators").setup(
            -- No need to copy this inside `setup()`. Will be used automatically.
            {
                -- Each entry configures one operator.
                -- `prefix` defines keys mapped during `setup()`: in Normal mode
                -- to operate on textobject and line, in Visual - on selection.

                -- Evaluate text and replace with output
                evaluate = {
                    prefix = "g=",

                    -- Function which does the evaluation
                    func = nil,
                },

                -- Exchange text regions
                exchange = {
                    prefix = "g3",

                    -- Whether to reindent new text to match previous indent
                    reindent_linewise = true,
                },

                -- Multiply (duplicate) text
                multiply = {
                    prefix = "gm",

                    -- Function which can modify text before multiplying
                    func = nil,
                },

                -- Replace text with register
                replace = {
                    prefix = "g2",

                    -- Whether to reindent new text to match previous indent
                    reindent_linewise = true,
                },

                -- Sort text
                sort = {
                    prefix = "g1",

                    -- Function which does the sort
                    func = nil,
                },
            }
        )
    end,
}
