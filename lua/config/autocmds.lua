-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

vim.filetype.add({
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
    ["%.env"] = "sh",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "",
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if bufname:match("%.env$") or bufname:match("%.env%.[^/\\]+$") then
      vim.b[args.buf].autoformat = false
    end
  end,
})

-- Big-file LSP degrade: on huge buffers (generated codegen like src/codegen/graphql.tsx,
-- ~19k lines), the lag is LSP semantic tokens + inlay hints rendered every keystroke/scroll,
-- not a "slow server" (vtsls = same TS engine as VSCode). Kill those features per-buffer.
-- Go-to-def / completion / diagnostics still work.
local BIGFILE_LINES = 5000

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("bigfile_lsp_degrade", { clear = true }),
  callback = function(args)
    local buf = args.buf
    if vim.api.nvim_buf_line_count(buf) < BIGFILE_LINES then
      return
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    -- Stop semantic tokens for THIS buffer only. Deferred so it runs after core's
    -- auto-start on attach. Do NOT nil client.server_capabilities — that object is
    -- shared across every buffer of this client, so it would kill semantic tokens
    -- project-wide, not just on the big file.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      pcall(vim.lsp.semantic_tokens.stop, buf, client.id)
      -- inlay hints off for this buffer (also deferred, same attach-ordering reason)
      pcall(vim.lsp.inlay_hint.enable, false, { bufnr = buf })
    end)
  end,
})

-- Remove LazyVim's default format autocmd to prevent double formatting
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_format_notify")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if vim.b[args.buf].autoformat == false then
      return
    end
    require("conform").format({
      bufnr = args.buf,
      timeout_ms = 1000,
      async = false,
      quiet = true,
      lsp_format = "never",
    })
  end,
})
