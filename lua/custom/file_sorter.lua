local sorters = require("telescope.sorters")
local fzy_sorter = sorters.get_fzy_sorter()
local filter = vim.tbl_filter

-- Copied from:
-- https://github.com/nvim-telescope/telescope.nvim/blob/dc192faceb2db64231ead71539761e055df66d73/lua/telescope/builtin/__internal.lua#L17-L29
local function apply_cwd_only_aliases(opts)
    local has_cwd_only = opts.cwd_only ~= nil
    local has_only_cwd = opts.only_cwd ~= nil
    if has_only_cwd and not has_cwd_only then
        -- Internally, use cwd_only
        opts.cwd_only = opts.only_cwd
        opts.only_cwd = nil
    end

    return opts
end
-- Copied from:
-- https://github.com/nvim-telescope/telescope.nvim/blob/dc192faceb2db64231ead71539761e055df66d73/lua/telescope/builtin/__internal.lua#L872-L923
local get_buffers = function(opts)
    opts = opts or {}
    opts = apply_cwd_only_aliases(opts)
    local bufnrs = filter(function(b)
        if 1 ~= vim.fn.buflisted(b) then
            return false
        end
        -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
        if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(b) then
            return false
        end
        if opts.ignore_current_buffer and b == vim.api.nvim_get_current_buf() then
            return false
        end
        if opts.cwd_only and not string.find(vim.api.nvim_buf_get_name(b), vim.loop.cwd(), 1, true) then
            return false
        end
        if not opts.cwd_only and opts.cwd and not string.find(vim.api.nvim_buf_get_name(b), opts.cwd, 1, true) then
            return false
        end
        return true
    end, vim.api.nvim_list_bufs())
    if not next(bufnrs) then
        return
    end
    if opts.sort_mru then
        table.sort(bufnrs, function(a, b)
            return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
        end)
    end

    local buffers = {}
    for _, bufnr in ipairs(bufnrs) do
        local flag = bufnr == vim.fn.bufnr("") and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " ")

        local element = {
            bufnr = bufnr,
            flag = flag,
            info = vim.fn.getbufinfo(bufnr)[1],
        }
        -- print("hello")
        -- print(vim.inspect(element))
        -- vim.pretty_print(element)
        if opts.sort_lastused and (flag == "#" or flag == "%") then
            local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
            -- print(vim.inspect(element.info))
            -- print(element.flag)
            -- print(vim.inspect(vim.api.nvim_get_mode()))
            table.insert(buffers, idx, element)
        else
            -- print(vim.inspect(element.info))
            -- print("Hello")
            -- print(vim.inspect(vim.api.nvim_get_mode()))
            -- print(element.info)
            table.insert(buffers, element)
        end
    end
    -- for _, buffer in ipairs(buffers) do
    --     print("Buffer Number: " .. buffer.bufnr)
    --     print("Flag: " .. buffer.flag)
    --     print("Info: ")
    --     for k, v in pairs(buffer.info) do
    --         print("  " .. k .. ": " .. tostring(v))
    --     end
    -- end
    return buffers
end

local is_file_open = function(line)
    local buffers = get_buffers()
    if not buffers then
        return false
    end
    -- TODO: This may not be performant if there are many open buffers.
    -- We could implement a map / lookup table instead.
    for _, buffer in ipairs(buffers) do
        local buffer_name = buffer.info.name
        if vim.endswith(buffer_name, line) then
            return true
        end
    end
    return false
end

-- Copied from:
-- https://github.com/nvim-telescope/telescope.nvim/blob/dc192faceb2db64231ead71539761e055df66d73/lua/telescope/sorters.lua#L437-L466
-- Sorter using the fzy algorithm
local file_sorter = function(opts)
    opts = opts or {}
    local fzy = opts.fzy_mod or require("telescope.algos.fzy")
    local OFFSET = -fzy.get_score_floor()

    return sorters.Sorter:new({
        discard = fzy_sorter.discard,
        scoring_function = function(_, prompt, line)
            if prompt == "" then
                if is_file_open(line) then
                else
                end
            end
            -- Check for actual matches before running the scoring alogrithm.
            if not fzy.has_match(prompt, line) then
                return -1
            end

            local fzy_score = fzy.score(prompt, line)

            -- The fzy score is -inf for empty queries and overlong strings.  Since
            -- this function converts all scores into the range (0, 1), we can
            -- convert these to 1 as a suitable "worst score" value.
            if fzy_score == fzy.get_score_min() then
                return 1
            end

            -- CUSTOM CODE ADDED HERE 👇
            -- Double score if file is open.
            -- TODO: Score boost could take into account sort order of buffers.
            -- Like which one was last used.
            if is_file_open(line) then
                -- print(fzy_score)
                -- print("hello" .. fzy_score)
                fzy_score = fzy_score * 2
            end
            -- END CUSTOM CODE

            -- Poor non-empty matches can also have negative values. Offset the score
            -- so that all values are positive, then invert to match the
            -- telescope.Sorter "smaller is better" convention. Note that for exact
            -- matches, fzy returns +inf, which when inverted becomes 0.
            return 1 / (fzy_score + OFFSET)
        end,

        highlighter = fzy_sorter.highlighter,
    })
end
return { file_sorter = file_sorter }
