return {
  "NStefan002/screenkey.nvim",
  lazy = false,
  version = "*", -- or branch = "main", to use the latest commit
  config = function()
    require("screenkey").setup({
      win_opts = {
        relative = "editor",
      },
    })
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
