-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

vim.api.nvim_create_autocmd("FileType", {
  pattern = "",
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if bufname:match("%.env$") or bufname:match("%.env%.[^/\\]+$") then
      vim.b[args.buf].autoformat = false
    end
  end,
})

-- Remove LazyVim's default format autocmd to prevent double formatting
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_format_notify")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({
      bufnr = args.buf,
      timeout_ms = 1000,
      async = false,
      quiet = true,
    })
  end,
})
