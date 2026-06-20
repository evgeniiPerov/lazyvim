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
        "yaml",
        "bash",
        "html",
        "css",
        "rust",
        "toml",
        "ron",
      },
    },
  },
}
