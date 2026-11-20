return {
  {
    "xzbdmw/telescope.nvim",
    name = "telescope.nvim",
    keys = {
      { "<leader>cA", function() require("config.codex_attach").attach() end, desc = "Attach window to Codex" },
      { "<leader>cS", function() require("config.codex_attach").send_selection() end, mode = "x", desc = "Send selection to Codex" },
    },
    init = function()
      vim.api.nvim_create_user_command("CodexAttach", function() require("config.codex_attach").attach() end, {})
      vim.api.nvim_create_user_command("CodexDetach", function() require("config.codex_attach").detach() end, {})
    end,
  },
}
