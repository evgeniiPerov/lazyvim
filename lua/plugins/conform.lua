-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local util = require("lazyvim.util")
    local fs = vim.loop.fs_stat
    local has_biome = fs(util.root.get() .. "/biome.json")

    opts.formatters_by_ft = opts.formatters_by_ft or {}

    if has_biome then
      opts.formatters_by_ft.javascript = { "biome" }
      opts.formatters_by_ft.javascriptreact = { "biome" }
      opts.formatters_by_ft.typescript = { "biome" }
      opts.formatters_by_ft.typescriptreact = { "biome" }
    else
      -- fallback (example: prettier or eslint)
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.typescript = { "prettier" }
    end
  end,
}
