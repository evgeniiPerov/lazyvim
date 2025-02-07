return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    settings = {
      tsserver_plugins = {},
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeCompletionsForModuleExports = true,
      },
      tsserver_format_options = {
        allowIncompleteCompletions = false,
        allowRenameOfImportPath = false,
      },
    },
    -- Increase memory for TypeScript server
    handlers = {
      ["typescript-tools"] = function()
        return {
          cmd = { "node", "--max-old-space-size=8192", vim.fn.exepath("typescript-language-server"), "--stdio" },
        }
      end,
    },
  },
}
