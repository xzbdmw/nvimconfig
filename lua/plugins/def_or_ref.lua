local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("custom.make_entry")
local filter_entries = make_entry.filter_entries
local add_metadata_to_locations = make_entry.add_metadata_to_locations
local gen_from_quickfix = make_entry.gen_from_quickfix
local sorter = make_entry.sorter

local function handle_references_response(result)
    local locations = vim.lsp.util.locations_to_items(result, "utf-16")
    local filtered_entries = filter_entries(locations)

    pickers
        .new({
            layout_strategy = "cursor",
            -- layout_config = {
            --     width = 0.9,
            --     height = 0.6,
            --     preview_width = 0.5,
            -- },
        }, {
            prompt_title = "LSP References",
            finder = finders.new_table({
                results = add_metadata_to_locations(filtered_entries),
                entry_maker = gen_from_quickfix({ trim_text = true }),
            }),
            previewer = require("telescope.config").values.qflist_previewer({}),
            sorter = sorter,
            push_cursor_on_edit = true,
            push_tagstack_on_edit = true,
            initial_mode = "normal",
        })
        :find()
end

return {
    "KostkaBrukowa/definition-or-references.nvim",
    enabled = false,
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
