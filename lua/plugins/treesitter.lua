return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "graphql", -- add this
        "json",
        "jsonc",
        "lua",
        "typescript",
        "yaml",
        "bash",
        "html",
        "css",
      },
      highlight = { enable = true },
    },
  },
}
