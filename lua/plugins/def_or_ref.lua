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
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    prompt_position = "top",
                    width = 0.55,
                    height = 0.9,
                    mirror = true,
                    preview_cutoff = 0,
                    preview_height = 0.55,
                },
            },
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
    "xzbdmw/definition-or-references.nvim",
    lazy = false,
    enabled = false,
    keys = {
        {
            "<leader>d",
            function()
                require("definition-or-references").definition_or_references()
            end,
        },
    },
    opts = {
        notify_options = true,
        on_references_result = function()
            vim.cmd("Glance references")
        end,
    },
}
