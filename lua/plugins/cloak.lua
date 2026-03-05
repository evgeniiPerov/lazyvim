return {
  "laytan/cloak.nvim",
  event = "BufRead .env*",
  opts = {
    cloak_character = "*",
    highlight_group = "Comment",
    patterns = {
      {
        file_pattern = ".env*",
        cloak_pattern = "=.+",
        replace = nil,
      },
    },
  },
  keys = {
    { "<leader>uE", "<cmd>CloakToggle<cr>", desc = "Toggle Env Cloak" },
    { "<leader>uP", "<cmd>CloakPreviewLine<cr>", desc = "Preview Cloaked Line" },
  },
}
