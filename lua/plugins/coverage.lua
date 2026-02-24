return {
  "andythigpen/nvim-coverage",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    auto_reload = true,
    signs = {
      covered = { hl = "CoverageCovered", text = "▎" },
      uncovered = { hl = "CoverageUncovered", text = "▎" },
    },
    summary = {
      min_coverage = 80.0,
    },
  },
  keys = {
    { "<leader>tC", "<cmd>Coverage<cr>", desc = "Load & Show Coverage" },
    { "<leader>tg", "<cmd>CoverageToggle<cr>", desc = "Toggle Coverage Signs" },
    { "<leader>tp", "<cmd>CoverageSummary<cr>", desc = "Coverage Summary" },
    { "<leader>tx", "<cmd>CoverageClear<cr>", desc = "Clear Coverage" },
  },
}
