return {
    "echasnovski/mini.pairs",
    version = false,
    config = function()
        -- No need to copy this inside `setup()`. Will be used automatically.
        require("mini.pairs").setup({
            -- In which modes mappings from this `config` should be created
            modes = { insert = true, command = false, terminal = false },

            -- Global mappings. Each right hand side should be a pair information, a
            -- table with at least these fields (see more in |MiniPairs.map|):
            -- - <action> - one of 'open', 'close', 'closeopen'.
            -- - <pair> - two character string for pair to be used.
            -- By default pair is not inserted after `\`, quotes are not recognized by
            -- `<CR>`, `'` does not insert pair after a letter.
            -- Only parts of tables can be tweaked (others will use these defaults).
            mappings = {
                ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

                ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
            },
        })
    end,
}
