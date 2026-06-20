return {
  -- Inline git blame is already provided by gitsigns (LazyVim default,
  -- `current_line_blame`), so f-person/git-blame.nvim was removed as redundant.

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
