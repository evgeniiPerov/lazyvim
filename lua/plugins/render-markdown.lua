-- In-buffer markdown rendering (headings, tables, code blocks, checkboxes).
-- Pure Lua, no browser/node/deno. Uses treesitter (already installed).
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "markdown.mdx" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {},
  keys = {
    { "<leader>uM", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render", ft = "markdown" },
  },
}
