return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  ft = "json",
  opts = {},
  keys = {
    { "<leader>ns", function() require("package-info").show() end, desc = "Show package versions" },
    { "<leader>np", function() require("package-info").change_version() end, desc = "Change package version" },
  },
}
