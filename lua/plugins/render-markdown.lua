return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = { "markdown" },
  keys = {
    {
      "<leader>mr",
      "<cmd>RenderMarkdown toggle<cr>",
      desc = "Toggle Render Markdown",
    },
  },
  opts = {
    preset = "lazy",
  },
}
