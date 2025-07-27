return {
  "dense-analysis/ale",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Detect project root and files
    local root = require("lazyvim.util").root.get()
    local function has_file(name)
      local fs = vim.loop.fs_stat
      return fs(root .. "/" .. name) ~= nil
    end

    local has_biome = has_file("biome.json") or has_file("biome.config.json")
    local has_eslint = has_file(".eslintrc.js")
      or has_file(".eslintrc.cjs")
      or has_file(".eslintrc.json")
      or has_file("eslint.config.js")
      or has_file("eslint.config.mjs")
    local has_prettier = has_file(".prettierrc")
      or has_file(".prettierrc.js")
      or has_file(".prettierrc.cjs")
      or has_file("prettier.config.js")

    -- Dynamic configuration
    if has_biome then
      vim.g.ale_linters = {
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
      }

      vim.g.ale_fixers = {
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
      }
    else
      local linters = {}
      local fixers = {}

      if has_eslint then
        linters = { "eslint" }
        table.insert(fixers, "eslint")
      end

      if has_prettier then
        table.insert(fixers, "prettier")
      end

      vim.g.ale_linters = {
        javascript = linters,
        javascriptreact = linters,
        typescript = linters,
        typescriptreact = linters,
        json = {},
      }

      vim.g.ale_fixers = {
        javascript = fixers,
        javascriptreact = fixers,
        typescript = fixers,
        typescriptreact = fixers,
        json = {},
      }
    end

    vim.g.ale_fix_on_save = 1
    vim.g.ale_completion_enabled = 0 -- Keep LSP completion
  end,
}
