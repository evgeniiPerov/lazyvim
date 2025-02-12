return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      "typescript-language-server", -- TypeScript server for React
      "biome",
      "prettier",
      "graphql-language-service-cli",
    })
  end,
}
