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
    {
        dir = "/Users/xzb/.local/share/nvim/lazy/telescope-egrepify.nvim",
        keys = {
            { "<space>rg", "<CMD>Telescope egrepify<CR>", mode = { "n", "i", "v" } },
        },
    },
    {
        dir = "/Users/xzb/.local/share/nvim/lazy/telescope.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-e>"] = function(bufnr)
                                actions.close(bufnr)
                            end,
                        },
                    },
                },
            })
            require("telescope").load_extension("egrepify")
        end,
    },
    -- add any other pugins here
}
require("lazy").setup(plugins, {
    root = root .. "/plugins",
})

-- add anything else here
vim.opt.termguicolors = true
-- do not remove the colorscheme!
vim.cmd([[colorscheme tokyonight]])
