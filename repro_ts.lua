local root = vim.fn.fnamemodify("./.repro", ":p")
-- set stdpaths to use .repro
for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end
-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)
-- install plugins
local plugins = {
    -- do not remove the colorscheme!
    "folke/tokyonight.nvim",
    -- add any other pugins here
}

require("lazy").setup(plugins, {
    root = root .. "/plugins",
})

-- add anything else here
-- vim.opt.termguicolors = true
-- do not remove the colorscheme!
vim.cmd([[colorscheme tokyonight]])
vim.keymap.set("n", "gt", function()
    local col = vim.fn.screencol()
    local row = vim.fn.screenrow()
    local char = vim.fn.screenstring(row, col)
    -- __AUTO_GENERATED_PRINT_VAR_START__
    print([==[function#if#function char:]==], vim.inspect(char)) -- __AUTO_GENERATED_PRINT_VAR_END__
end)
