local Path = require("plenary.path")
local utils = require("telescope.utils")
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

            local n = api.nvim_buf_get_name(bufnr)
            bufnr_name_cache[bufnr] = n
            return n
        end
    end

    local make_display = function(entry)
        local display_filename = utils.transform_path(opts, entry.filename)
        -- print(display_filename)
        local text = entry.text
        -- print(text)
        text = vim.trim(text)
        text = text:gsub(".* | ", "")
        entry.text = text
        display_filename = vim.trim(display_filename) .. " -> " .. entry.lnum .. "  "
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
        -- print(vim.inspect(entry))
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

local handle_entry_index = function(opts, t, k)
    local override = ((opts or {}).entry_index or {})[k]
    if not override then
        return
    end

    local val, save = override(t, opts)
    if save then
        rawset(t, k, val)
    end
    return val
end
local function gen_from_vimgrep(opts)
    local lookup_keys = {
        display = 1,
        ordinal = 1,
        value = 1,
    }
    opts = opts or {}

    local parse_with_col = function(t)
        local _, _, filename, lnum, col, text = string.find(t.value, [[(..-):(%d+):(%d+):(.*)]])

        local ok
        ok, lnum = pcall(tonumber, lnum)
        if not ok then
            lnum = nil
        end

        ok, col = pcall(tonumber, col)
        if not ok then
            col = nil
        end

        t.filename = filename
        t.lnum = lnum
        t.col = col
        t.text = text

        return { filename, lnum, col, text }
    end

    local parse_without_col = function(t)
        local _, _, filename, lnum, text = string.find(t.value, [[(..-):(%d+):(.*)]])

        local ok
        ok, lnum = pcall(tonumber, lnum)
        if not ok then
            lnum = nil
        end

        t.filename = filename
        t.lnum = lnum
        t.col = nil
        t.text = text

        return { filename, lnum, nil, text }
    end

    local parse_only_filename = function(t)
        t.filename = t.value
        t.lnum = nil
        t.col = nil
        t.text = ""

        return { t.filename, nil, nil, "" }
    end
    local mt_vimgrep_entry
    local parse = parse_with_col
    if opts.__matches == true then
        parse = parse_only_filename
    elseif opts.__inverted == true then
        parse = parse_without_col
    end

    local disable_devicons = opts.disable_devicons
    local disable_coordinates = opts.disable_coordinates
    local only_sort_text = opts.only_sort_text

    local execute_keys = {
        path = function(t)
            if Path:new(t.filename):is_absolute() then
                return t.filename, false
            else
                return Path:new({ t.cwd, t.filename }):absolute(), false
            end
        end,

        filename = function(t)
            return parse(t)[1], true
        end,

        lnum = function(t)
            return parse(t)[2], true
        end,

        col = function(t)
            return parse(t)[3], true
        end,

        text = function(t)
            return parse(t)[4], true
        end,
    }

    -- For text search only, the ordinal value is actually the text.
    if only_sort_text then
        execute_keys.ordinal = function(t)
            return t.text
        end
    end

    local display_string = "%s%s%s"

    mt_vimgrep_entry = {
        cwd = vim.fn.expand(opts.cwd or vim.loop.cwd()),

        display = function(entry)
            local display_filename = utils.transform_path(opts, entry.filename)

            local coordinates = ":"
            if not disable_coordinates then
                if entry.lnum then
                    coordinates = string.format(":%s", entry.lnum)
                end
            end

            local display, hl_group, icon = utils.transform_devicons(
                entry.filename,
                string.format(display_string, display_filename, coordinates, entry.text),
                disable_devicons
            )
            print("display_string:")
            print(display_string)
            print("display_filename: ")
            print(display_filename)
            print("coordinates: ")
            print(coordinates)
            print("entry.text: ")
            print(entry.text)
            print("display: ")
            print(vim.inspect(display))

            print("hl_group: ")
            print(vim.inspect(hl_group))
            print("icon: ")
            print(vim.inspect(icon))
            --
            -- local entry_display = require("telescope.pickers.entry_display")
            -- local displayer = entry_display.create({
            --     separator = " ",
            --     items = {
            --         { width = 1 },
            --         { width = #display_filename },
            --         { remaining = true },
            --     },
            -- })
            -- return displayer({ { icon, hl_group }, { display_filename, "Comment" }, { entry.text, "TelescopeTitle" } })

            if hl_group then
                return display, { { { 0, #icon }, hl_group } }
            else
                return display
            end
        end,

        __index = function(t, k)
            local override = handle_entry_index(opts, t, k)
            if override then
                return override
            end

            local raw = rawget(mt_vimgrep_entry, k)
            if raw then
                return raw
            end

            local executor = rawget(execute_keys, k)
            if executor then
                local val, save = executor(t)
                if save then
                    rawset(t, k, val)
                end
                return val
            end

            return rawget(t, rawget(lookup_keys, k))
        end,
    }

    return function(line)
        return setmetatable({ line }, mt_vimgrep_entry)
    end
end
local M = {}
do
    local lookup_keys = {
        value = 1,
        ordinal = 1,
    }

    -- Gets called only once to parse everything out for the vimgrep, after that looks up directly.
    local parse_with_col = function(t)
        local _, _, filename, lnum, col, text = string.find(t.value, [[(..-):(%d+):(%d+):(.*)]])

        local ok
        ok, lnum = pcall(tonumber, lnum)
        if not ok then
            lnum = nil
        end

        ok, col = pcall(tonumber, col)
        if not ok then
            col = nil
        end

        t.filename = filename
        t.lnum = lnum
        t.col = col
        t.text = text

        return { filename, lnum, col, text }
    end

    local parse_without_col = function(t)
        local _, _, filename, lnum, text = string.find(t.value, [[(..-):(%d+):(.*)]])

        local ok
        ok, lnum = pcall(tonumber, lnum)
        if not ok then
            lnum = nil
        end

        t.filename = filename
        t.lnum = lnum
        t.col = nil
        t.text = text

        return { filename, lnum, nil, text }
    end

    local parse_only_filename = function(t)
        t.filename = t.value
        t.lnum = nil
        t.col = nil
        t.text = ""

        return { t.filename, nil, nil, "" }
    end

    function M.gen_from_vimgrep_lib(opts)
        opts = opts or {}

        local mt_vimgrep_entry
        local parse = parse_with_col
        if opts.__matches == true then
            parse = parse_only_filename
        elseif opts.__inverted == true then
            parse = parse_without_col
        end

        local disable_devicons = opts.disable_devicons
        local disable_coordinates = opts.disable_coordinates
        local only_sort_text = opts.only_sort_text

        local execute_keys = {
            path = function(t)
                if Path:new(t.filename):is_absolute() then
                    return t.filename, false
                else
                    return Path:new({ t.cwd, t.filename }):absolute(), false
                end
            end,

            filename = function(t)
                return parse(t)[1], true
            end,

            lnum = function(t)
                return parse(t)[2], true
            end,

            col = function(t)
                return parse(t)[3], true
            end,

            text = function(t)
                return parse(t)[4], true
            end,
        }

        -- For text search only, the ordinal value is actually the text.
        if only_sort_text then
            execute_keys.ordinal = function(t)
                return t.text
            end
        end

        local display_string = "%s%s%s"

        mt_vimgrep_entry = {
            cwd = vim.fn.expand(opts.cwd or vim.loop.cwd()),

            display = function(entry)
                local display_filename = utils.transform_path(opts, entry.filename)

                local coordinates = ":"
                if not disable_coordinates then
                    if entry.lnum then
                        if entry.col then
                            coordinates = string.format(":%s:%s:", entry.lnum, entry.col)
                        else
                            coordinates = string.format(":%s:", entry.lnum)
                        end
                    end
                end

                local display, hl_group, icon = utils.transform_devicons(
                    entry.filename,
                    string.format(display_string, display_filename, coordinates, entry.text),
                    disable_devicons
                )

                if hl_group then
                    return display, { { { 0, #icon }, hl_group } }
                else
                    return display
                end
            end,

            __index = function(t, k)
                local override = handle_entry_index(opts, t, k)
                if override then
                    return override
                end

                local raw = rawget(mt_vimgrep_entry, k)
                if raw then
                    return raw
                end

                local executor = rawget(execute_keys, k)
                if executor then
                    local val, save = executor(t)
                    if save then
                        rawset(t, k, val)
                    end
                    return val
                end

                return rawget(t, rawget(lookup_keys, k))
            end,
        }

        return function(line)
            return setmetatable({ line }, mt_vimgrep_entry)
        end
    end
end
return {
    filter_entries = filter_entries,
    sorter = sorter,
    gen_from_quickfix = gen_from_quickfix,
    add_metadata_to_locations = add_metadata_to_locations,
    gen_from_vimgrep = gen_from_vimgrep,
    gen_from_vimgrep_lib = M.gen_from_vimgrep_lib,
}
