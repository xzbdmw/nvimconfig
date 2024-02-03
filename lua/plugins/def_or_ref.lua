local function handle_references_response(result)
    require("telescope.pickers")
        .new(
            {},
            require("telescope.themes").get_dropdown({
                initial_mode = "normal",
                path_display = require("custom.path_display").filenameFirstWithoutParent,
                layout_strategy = "cursor",
                layout_config = {
                    width = 0.9,
                    height = 0.6,
                    preview_width = 0.6,
                },
                prompt_title = "LSP References",
                finder = require("telescope.finders").new_table({
                    results = vim.lsp.util.locations_to_items(result, "utf-16"),
                    entry_maker = require("telescope.make_entry").gen_from_quickfix(),
                }),
                previewer = require("telescope.config").values.qflist_previewer({}),
                push_cursor_on_edit = true,
            })
        )
        :find()
end
return {
    "KostkaBrukowa/definition-or-references.nvim",
    opts = { notify_options = false, on_references_result = handle_references_response },
}
