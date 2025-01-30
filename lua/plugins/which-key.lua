return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>D", group = "🚀 Lazydocker" }, -- Group title
      {
        "<leader>DD",
        function()
          vim.cmd("LazyDocker")
        end,
        desc = "Open Lazydocker (Floating)",
      },
      {
        "<leader>Db",
        function()
          vim.cmd("tabnew | term lazydocker")
        end,
        desc = "Open Lazydocker (Buffer)",
      },
    },
  },
}
