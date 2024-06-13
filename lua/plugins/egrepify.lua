return {
    "fdschmidt93/telescope-egrepify.nvim",
    -- dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup({
            extensions = {
                egrepify = {
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            prompt_position = "top",
                            width = 0.5,
                            height = 0.9,
                            mirror = true,
                            preview_cutoff = 0,
                            preview_height = 0.45,
                        },
                    },
                    -- intersect tokens in prompt ala "str1.*str2" that ONLY matches
                    -- if str1 and str2 are consecutively in line with anything in between (wildcard)
                    AND = true, -- default
                    permutations = false, -- opt-in to imply AND & match all permutations of prompt tokens
                    lnum = true, -- default, not required
                    lnum_hl = "ChangedCmpItemKindInterface", -- default, not required, links to `Constant`
                    col = false, -- default, not required
                    col_hl = "ChangedCmpItemKindInterface", -- default, not required, links to `Constant`
                    title = false, -- default, not required, show filename as title rather than inline
                    filename_hl = "ChangedCmpItemKindInterface", -- default, not required, links to `Title`
                    -- suffix = long line, see screenshot
                    -- EXAMPLE ON HOW TO ADD PREFIX!
                    prefixes = {
                        -- filter for (partial) file names
                        -- example prompt: &egrep $MY_PROMPT
                        -- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
                        -- i.e. rg --glob="*egrep*" -- $MY_PROMPT
                        ["@"] = {
                            flag = "glob",
                            cb = function(input)
                                return string.format([[*{%s}]], input)
                            end,
                        },
                        ["`"] = {
                            -- #$REMAINDER
                            -- # is caught prefix
                            -- `input` becomes $REMAINDER
                            -- in the above example #lua,md -> input: lua,md
                            flag = "glob",
                            cb = function(input)
                                return string.format([[*.{%s}]], input)
                            end,
                        },
                        -- ADDED ! to invert matches
                        -- example prompt: ! sorter
                        -- matches all lines that do not comprise sorter
                        -- rg --invert-match -- sorter
                        ["!"] = {
                            flag = "invert-match",
                        },
                        -- HOW TO OPT OUT OF PREFIX
                        -- ^ is not a default prefix and safe example
                        ["^"] = false,
                    },
                },
            },
        })
        require("telescope").load_extension("egrepify")
    end,
}
