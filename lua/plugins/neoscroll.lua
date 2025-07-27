return {
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({
        -- Optional custom settings
        easing_function = "quadratic", -- Easing: "linear", "quadratic", "cubic"
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at the end of the file
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
      })
    end,
  },
}
