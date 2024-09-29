return {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    event = "InsertEnter",
    config = function()
        require("copilot_cmp").setup()
    end,
}
