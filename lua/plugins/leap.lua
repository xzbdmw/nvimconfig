return {
    "ggandor/leap.nvim",
    enabled = true,
    opts = {
        case_sensitive = false,
        equivalence_classes = { " \t\r\n" },
        max_phase_one_targets = nil,
        highlight_unlabeled_phase_one_targets = false,
        max_highlighted_traversal_targets = 10,
        substitute_chars = {},
        safe_labels = "sfnut/SFNLHMUGTZ?",
        labels = "sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?",
        special_keys = {
            next_target = ";",
            prev_target = ",",
            -- next_group = "<space>",
            -- prev_group = "<tab>",
        },
    },
    config = function(_, opts)
        local leap = require("leap")
        for k, v in pairs(opts) do
            leap.opts[k] = v
        end
        leap.add_default_mappings(true)
        vim.keymap.del({ "x", "o" }, "x")
        vim.keymap.del({ "x", "o" }, "X")
    end,
}
