local sorters = require("telescope.sorters")
local conf = require("telescope.config").values
local fuzzy_sorter = sorters.get_generic_fuzzy_sorter()

-- sorter that moves less important entries to the bottom
local sorter = sorters.Sorter:new({
    scoring_function = function(_, prompt, line, entry, cb_add, cb_filter)
        local base_score = fuzzy_sorter:scoring_function(prompt, line, cb_add, cb_filter)

        if entry.value.is_test_file then
            base_score = base_score + 100
        end

        if entry.value.is_inside_import then
            base_score = base_score + 200
        end

        return base_score
    end,
    highlighter = conf.generic_sorter().highlighter,
})

local function filter_entries(results)
    local function should_include_entry(entry)
        -- if entry is closing tag - just before it there is a closing tag syntax '</'
        if entry.col > 2 and entry.text:sub(entry.col - 2, entry.col - 1) == "</" then
            return false
        end

        return true
    end

    return vim.tbl_filter(should_include_entry, vim.F.if_nil(results, {}))
end

--- @return table
local function add_metadata_to_locations(locations)
    return vim.tbl_map(function(location)
        if string.find(location.text, "^import") then
            location.is_inside_import = true
        end

        if string.find(location.filename, ".spec.") or string.find(location.filename, "TestBuilder") then
            location.is_test_file = true
        end

        return location
    end, locations)
end

local function gen_from_quickfix(opts)
    local utils = require("telescope.utils")
    local make_entry = require("telescope.make_entry")
    local entry_display = require("telescope.pickers.entry_display")
    opts = opts or {}

    local get_filename_fn = function()
        local bufnr_name_cache = {}
        return function(bufnr)
            bufnr = vim.F.if_nil(bufnr, 0)
            local c = bufnr_name_cache[bufnr]
            if c then
                return c
            end

            local n = vim.api.nvim_buf_get_name(bufnr)
            bufnr_name_cache[bufnr] = n
            return n
        end
    end

    local make_display = function(entry)
        local display_filename = utils.transform_path(opts, entry.filename)
        local text = entry.text
        text = vim.trim(text)
        text = text:gsub(".* | ", "")
        entry.text = text
        local displayer = entry_display.create({
            separator = " ",
            items = {
                { width = #display_filename },
                { remaining = true },
            },
        })
        return displayer({ { display_filename, "Comment" }, { entry.text, "TelescopeTitle" } })
    end

    local get_filename = get_filename_fn()
    return function(entry)
        local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))
        return make_entry.set_default_entry_mt({
            value = entry,
            ordinal = entry.text,
            display = make_display,
            bufnr = entry.bufnr,
            filename = filename,
            lnum = entry.lnum,
            col = entry.col,
            text = entry.text,
            start = entry.start,
            finish = entry.finish,
        }, opts)
    end
end
return {
    filter_entries = filter_entries,
    sorter = sorter,
    gen_from_quickfix = gen_from_quickfix,
    add_metadata_to_locations = add_metadata_to_locations,
}
