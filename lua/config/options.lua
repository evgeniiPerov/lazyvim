-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false

vim.o.scroll = 5 -- for neoscroll

vim.g.conform_format_on_save = { -- optional, override behavior
  lsp_fallback = false,
  timeout_ms = 500,
}
