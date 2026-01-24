return {
  "folke/lazydev.nvim",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "lazy.nvim", words = { "LazyVim" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      -- Always load cord.nvim types when CordConfig is mentioned
      { path = "cord.nvim", words = { "Cord" } },
    },
    -- Enable type checking for all files
    enabled = function()
      return true
    end,
  },
}
