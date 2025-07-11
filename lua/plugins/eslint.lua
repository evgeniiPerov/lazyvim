return {
  "esmuellert/nvim-eslint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local fs = vim.loop.fs_stat
    local util = require("lspconfig.util")

    local root = util.root_pattern(
      ".eslintrc.js",
      ".eslintrc.cjs",
      "eslint.config.js",
      "eslint.config.mjs",
      "package.json",
      ".git"
    )(vim.fn.expand("%:p")) or vim.loop.cwd()

    local function has_file(name)
      return fs(root .. "/" .. name) ~= nil
    end

    local has_biome = has_file("biome.json")
    if has_biome then
      vim.g.eslint_disable = true
      return
    end

    require("nvim-eslint").setup({
      bin = "eslint",
      code_actions = false,
      debounce = 100,
      diagnostics_format = "[eslint] ${message} [${ruleId}]",
      diagnostic_config = {
        virtual_text = true,
        signs = true,
        underline = true,
      },
      root_patterns = {
        ".eslintrc.js",
        ".eslintrc.cjs",
        "eslint.config.js",
        "eslint.config.mjs",
        "package.json",
        ".git",
      },
      settings = {
        workingDirectory = {
          mode = "auto",
        },
        -- 🟡 Add nodePath to support monorepo shared configs:
        nodePath = root .. "/node_modules",
      },
    })
  end,
}
