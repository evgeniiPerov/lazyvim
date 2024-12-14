return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      "biome",
      "vtsls", -- Add Volar TypeScript Server to Mason
      "prettier",
      "eslint_d",
      "graphql-language-service-cli",
    })
  end,
}
