--this just formatting only, not show warnings and errors
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local fs = vim.loop.fs_stat
    local root = require("lazyvim.util").root.get()

    local function has_file(path)
      return fs(root .. path) ~= nil
    end

    local has_biome = has_file("/biome.json")
    local has_eslint = has_file("/.eslintrc.js")
      or has_file("/.eslintrc.cjs")
      or has_file("/.eslintrc.json")
      or has_file("/eslint.config.js")
      or has_file("/eslint.config.mjs")
    local has_prettier = has_file("/.prettierrc")
      or has_file("/.prettierrc.js")
      or has_file("/.prettierrc.cjs")
      or has_file("/prettier.config.js")

    -- Skip eslint if the config file references missing shared config
    local function eslint_config_is_safe()
      local config_path = root .. "/.eslintrc.js"
      local f = io.open(config_path, "r")
      if not f then
        return true
      end
      local content = f:read("*a")
      f:close()
      return not content:match("packages/eslint%-config")
    end

    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters = opts.formatters or {}

    if has_biome then
      opts.formatters_by_ft.javascript = { "biome" }
      opts.formatters_by_ft.javascriptreact = { "biome" }
      opts.formatters_by_ft.typescript = { "biome" }
      opts.formatters_by_ft.typescriptreact = { "biome" }
    elseif has_eslint and eslint_config_is_safe() or has_prettier then
      local fallback = {}
      if has_eslint and eslint_config_is_safe() then
        table.insert(fallback, "eslint")
      end
      if has_prettier then
        table.insert(fallback, "prettier")
      end

      opts.formatters_by_ft.javascript = fallback
      opts.formatters_by_ft.javascriptreact = fallback
      opts.formatters_by_ft.typescript = fallback
      opts.formatters_by_ft.typescriptreact = fallback
    else
      -- No formatter
      opts.formatters_by_ft.javascript = {}
      opts.formatters_by_ft.javascriptreact = {}
      opts.formatters_by_ft.typescript = {}
      opts.formatters_by_ft.typescriptreact = {}
    end

    -- Configure formatters
    opts.formatters.biome = {
      command = "biome",
      args = { "check", "--apply", "--formatter-enabled=true", "--lint-enabled=false", "$FILENAME" },
      stdin = false,
    }

    opts.formatters.eslint = {
      command = "eslint",
      args = { "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
      stdin = true,
      require_cwd = true,
      prefer_local = "node_modules/.bin", -- ✅ use local eslint
    }

    opts.formatters.prettier = {
      command = "prettier",
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
      prefer_local = "node_modules/.bin", -- ✅ use local prettier
    }
  end,
}
