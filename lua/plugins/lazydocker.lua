return {
  "crnvl96/lazydocker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- Ensure plenary is installed
  cmd = "LazyDocker",
  config = function()
    require("lazydocker").setup({
      float = {
        border = "rounded",
        height = 0.9,
        width = 0.9,
      },
      keymaps = {
        close = "q",
      },
    })
  end,
}
