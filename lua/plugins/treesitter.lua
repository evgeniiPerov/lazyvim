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
        "javascript",
        "tsx",
        "jsx",
        "yaml",
        "bash",
        "html",
        "css",
        "rust",
        "toml",
        "ron",
      },
      highlight = { enable = true },
    },
  },
}
