local function handle_references_response(result)
    require("telescope.pickers")
        .new({}, {
            initial_mode = "normal",
            path_display = require("custom.path_display").filenameFirstWithoutParent,
            layout_strategy = "horizontal",
            prompt_title = "LSP References",
            finder = require("telescope.finders").new_table({
                results = vim.lsp.util.locations_to_items(result, "utf-16"),
                entry_maker = require("telescope.make_entry").gen_from_quickfix(),
            }),
            layout_config = {
                horizontal = {
                    width = 0.8,
                    height = 0.8,
                    preview_cutoff = 0,
                    prompt_position = "top",
                    preview_width = 0.6,
                },
            },
            previewer = require("telescope.config").values.qflist_previewer({}),
            push_cursor_on_edit = true,
        })
        :find()
end
return {
    "KostkaBrukowa/definition-or-references.nvim",
    lazy = false,
    keys = {
        {
            "<leader>d",
            function()
                require("definition-or-references").definition_or_references()
            end,
        },
    },
    opts = { notify_options = false, on_references_result = handle_references_response },
}
