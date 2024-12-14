-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Example: Resume Telescope picker
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" }
)

-- LSP Keymaps for vtsls (TypeScript/JavaScript)
local lsp = vim.lsp.buf

-- Add missing imports
vim.keymap.set("n", "<leader>cM", lsp.code_action, { noremap = true, silent = true, desc = "Add Missing Imports" })

-- Organize imports
vim.keymap.set("n", "<leader>co", function()
  lsp.execute_command({ command = "_typescript.organizeImports" })
end, { noremap = true, silent = true, desc = "Organize Imports" })

-- Remove unused imports
vim.keymap.set("n", "<leader>cu", function()
  lsp.code_action({ diagnostics = vim.lsp.diagnostic.get_line_diagnostics() })
end, { noremap = true, silent = true, desc = "Remove Unused Imports" })

-- Go to Definition
vim.keymap.set("n", "gd", lsp.definition, { noremap = true, silent = true, desc = "Go to Definition" })

-- Go to Declaration
vim.keymap.set("n", "gD", lsp.declaration, { noremap = true, silent = true, desc = "Go to Declaration" })

-- Hover Documentation
vim.keymap.set("n", "K", lsp.hover, { noremap = true, silent = true, desc = "Hover Documentation" })

-- Format Document
vim.keymap.set("n", "<leader>cf", lsp.format, { noremap = true, silent = true, desc = "Format Document" })

-- Go to Implementation
vim.keymap.set("n", "gi", lsp.implementation, { noremap = true, silent = true, desc = "Go to Implementation" })

-- Rename Symbol
vim.keymap.set("n", "<leader>cr", lsp.rename, { noremap = true, silent = true, desc = "Rename Symbol" })

-- View References
vim.keymap.set("n", "gr", lsp.references, { noremap = true, silent = true, desc = "View References" })

-- Open Diagnostic Float
vim.keymap.set(
  "n",
  "<leader>cd",
  vim.diagnostic.open_float,
  { noremap = true, silent = true, desc = "Show Diagnostics" }
)

-- Next Diagnostic
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next Diagnostic" })

-- Previous Diagnostic
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Previous Diagnostic" })
