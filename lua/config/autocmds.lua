-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- auto close
--
vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")
vim.api.nvim_del_augroup_by_name("lazyvim_close_with_q")
vim.cmd("syntax off")
