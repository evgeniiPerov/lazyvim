return {
  "NStefan002/screenkey.nvim",
  lazy = false,
  version = "*", -- or branch = "main", to use the latest commit
  config = function()
    local screenkey = require("screenkey")
    screenkey.setup({
      win_opts = {
        relative = "editor",
        anchor = "SE", -- NW=top-left, NE=top-right, SW=bottom-left, SE=bottom-right
        row = vim.o.lines - vim.o.cmdheight - 1,
        col = 1, -- after comment this will be in right
      },
    })
    screenkey.toggle()
  end,
  keys = {
    {
      "<leader>tk",
      function()
        require("screenkey").toggle()
      end,
      desc = "Toggle Screenkey",
    },
  },
}
