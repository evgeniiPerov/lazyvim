return {
  "karb94/neoscroll.nvim",
  keys = {
    {
      "<C-u>",
      function()
        require("neoscroll").ctrl_u({ duration = 120 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll half-page up",
    },
    {
      "<C-d>",
      function()
        require("neoscroll").ctrl_d({ duration = 120 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll half-page down",
    },
    {
      "<C-b>",
      function()
        require("neoscroll").ctrl_b({ duration = 160 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll full-page up",
    },
    {
      "<C-f>",
      function()
        require("neoscroll").ctrl_f({ duration = 160 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll full-page down",
    },
    {
      "zt",
      function()
        require("neoscroll").zt({ half_win_duration = 140 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll cursor to top",
    },
    {
      "zz",
      function()
        require("neoscroll").zz({ half_win_duration = 140 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll cursor to center",
    },
    {
      "zb",
      function()
        require("neoscroll").zb({ half_win_duration = 140 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll cursor to bottom",
    },
  },
  opts = {
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = true,
    cursor_scrolls_alone = true,
    easing = "quadratic",
    duration_multiplier = 1.0,
  },
}
