-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Show diagnostic in a focused float (works even with Claude Code split open)
vim.keymap.set("n", "gl", function()
  local float_opts = {
    focusable = true,
    focus = true,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = "rounded",
    source = true,
    scope = "cursor",
  }
  local bufnr, win_id = vim.diagnostic.open_float(float_opts)
  if win_id then
    vim.api.nvim_set_current_win(win_id)
  end
end, { desc = "Diagnostic float (focused)" })

-- Terminal mode escapes (general, not toggleterm-specific)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Window commands from terminal" })
