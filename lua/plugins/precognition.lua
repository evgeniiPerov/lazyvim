return {
  "tris203/precognition.nvim",
  event = "VeryLazy",
  opts = {
    startVisible = true,
    showBlankVirtLine = true,
    highlightColor = { link = "Comment" },
    targetedMotionHints = { enabled = false },
    hints = {
      Caret = { text = "^", prio = 2 },
      Dollar = { text = "$", prio = 1 },
      MatchingPair = { text = "%", prio = 5 },
      Zero = { text = "0", prio = 1 },
      w = { text = "w", prio = 10 },
      b = { text = "b", prio = 9 },
      e = { text = "e", prio = 8 },
      W = { text = "W", prio = 7 },
      B = { text = "B", prio = 6 },
      E = { text = "E", prio = 5 },
    },
    gutterHints = {
      G = { text = "G", prio = 10 },
      gg = { text = "gg", prio = 9 },
      PrevParagraph = { text = "{", prio = 8 },
      NextParagraph = { text = "}", prio = 8 },
    },
    disabled_fts = { "startify", "neo-tree", "alpha", "dashboard" },
  },
  keys = {
    { "<leader>up", "<cmd>Precognition toggle<cr>", desc = "Toggle Precognition" },
    { "<leader>uP", "<cmd>Precognition peek<cr>", desc = "Peek Precognition" },
  },
}
