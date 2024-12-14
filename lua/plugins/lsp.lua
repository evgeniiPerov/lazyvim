return {
  "neovim/nvim-lspconfig",
  opts = {
    -- Add other LSP servers here if needed, but exclude TypeScript/JavaScript servers
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
    },
  },
}
