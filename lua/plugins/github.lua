return {
    "trevorhauter/gitportal.nvim",
    keys = {
        {
            "gX",
            function()
                require("gitportal").open_file_in_browser()
            end,
            mode = { "n", "x" },
        },
    },
    config = function()
        require("gitportal").setup({
            -- When opening generating permalinks, whether to always include the current line in
            -- the URL, regardless of visual mode.
            always_include_current_line = false,

            -- When ingesting permalinks, should gitportal always switch to the specified
            -- branch or commit?
            -- Can be "always", "ask_first", or "never"
            switch_branch_or_commit_upon_ingestion = "ask_first",
        })
    end,
}
