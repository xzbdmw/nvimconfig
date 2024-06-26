-- api.nvim_create_autocmd("FileType", {
--     pattern = "TelescopeResults",
--     callback = function(ctx)
--         api.nvim_buf_call(ctx.buf, function()
--             vim.fn.matchadd("TelescopeParent", "\t\t.*$")
--             api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
--         end)
--     end,
-- })

local function filenameFirst(_, path)
    -- print("path" .. path)
    local tail = vim.fs.basename(path)
    -- print("tail: " .. tail)
    local parent = vim.fs.dirname(path)
    -- print("parent: " .. parent)
    if parent == "." then
        return tail
    end
    return string.format("%s\t\t%s", tail, parent)
end

local function filenameFirstWithoutParent(_, path)
    -- print("path" .. path)
    local tail = vim.fs.basename(path)
    -- print("tail: " .. tail)
    local parent = vim.fs.dirname(path)
    -- print("parent: " .. parent)
    if parent == "." then
        return tail
    end
    return string.format("%s\t\t", tail)
end
local function filenameFirstForFrecency(_, path)
    -- print("Original path: " .. path)

    local cwd = vim.fn.getcwd() .. "/"
    -- print("Current working directory: " .. cwd)
    local relative_path = path:gsub("^" .. vim.pesc(cwd), "")
    -- print("Relative path: " .. relative_path)

    local tail = vim.fs.basename(relative_path)
    -- print("tail: " .. tail)
    local parent = vim.fs.dirname(relative_path)
    -- print("parent: " .. parent)

    if parent == "." then
        return tail
    end

    return string.format("%s\t\t%s", tail, parent)
end

return {
    filenameFirst = filenameFirst,
    filenameFirstForFrecency = filenameFirstForFrecency,
    filenameFirstWithoutParent = filenameFirstWithoutParent,
}
