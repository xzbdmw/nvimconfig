return {
    "numToStr/Comment.nvim",
    init = function()
        vim.keymap.del("n", "gcc")
    end,
    keys = {
        { "gc", mode = { "n", "o" }, desc = "comment toggle linewise" },
        { "gc", mode = "x", desc = "comment toggle linewise (visual)" },
        { "gbc", mode = "n", desc = "comment toggle current block" },
        { "gb", mode = { "n", "o" }, desc = "comment toggle blockwise" },
        { "gb", mode = "x", desc = "comment toggle blockwise (visual)" },
    },
    opts = {
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            ---Line-comment toggle keymap
            line = "<NOP>",
            ---Block-comment toggle keymap
            block = "gbc",
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = "gc",
            ---Block-comment keymap
            block = "gb",
        },
        ---LHS of extra mappings
        extra = {
            ---Add comment on the line above
            above = "<NOP>",
            ---Add comment on the line below
            below = "<NOP>",
            ---Add comment at the end of line
            eol = "<NOP>",
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
    },
    -- config = function(_, opts)
    --     -- vim.keymap.del("n", "gc", opts?)
    --     -- require("Comment").setup()
    -- end,
}
