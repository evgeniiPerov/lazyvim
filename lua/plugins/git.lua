return {
  -- Inline current-line blame (virtual text at EOL) via gitsigns.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
    },
  },

  -- Git permalinks (copy/open links to lines on the remote host).
  -- Switched from the unmaintained ruifm/gitlinker.nvim to the maintained fork.
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Copy git permalink" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git permalink" },
    },
  },
}
