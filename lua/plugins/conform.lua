return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local fs = vim.loop.fs_stat
    local root = require("lazyvim.util").root.get()

    local function has_file(filename)
      return fs(root .. "/" .. filename) ~= nil
    end

    local has_biome = has_file("biome.json")
    local has_eslint = has_file(".eslintrc.js")
      or has_file(".eslintrc.cjs")
      or has_file(".eslintrc.json")
      or has_file("eslint.config.js")
      or has_file("eslint.config.mjs")
    local has_prettier = has_file(".prettierrc")
      or has_file(".prettierrc.js")
      or has_file(".prettierrc.cjs")
      or has_file("prettier.config.js")

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

    -- JS/TS/React logic
    local js_ts_formatters = {}
    if has_biome then
      js_ts_formatters = { "biome" }
    elseif (has_eslint and eslint_config_is_safe()) or has_prettier then
      if has_eslint and eslint_config_is_safe() then
        table.insert(js_ts_formatters, "eslint")
      end
      if has_prettier then
        table.insert(js_ts_formatters, "prettier")
      end
    end

    opts.formatters_by_ft.javascript = js_ts_formatters
    opts.formatters_by_ft.javascriptreact = js_ts_formatters
    opts.formatters_by_ft.typescript = js_ts_formatters
    opts.formatters_by_ft.typescriptreact = js_ts_formatters

    -- JSON/JSONC logic
    local json_formatters = {}
    if has_biome then
      json_formatters = { "biome" }
    elseif has_prettier then
      json_formatters = { "prettier" }
    end
    opts.formatters_by_ft.json = json_formatters
    opts.formatters_by_ft.jsonc = json_formatters

    -- Configure formatters
    opts.formatters.biome = {
      command = "biome",
      args = { "format", "-", "--stdin-file-path", "$FILENAME" },
      stdin = true,
    }
    opts.formatters.eslint = {
      command = "eslint",
      args = { "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
      stdin = true,
      require_cwd = true,
      prefer_local = "node_modules/.bin",
    }

    local local_prettier = root .. "/node_modules/.bin/prettier"
    opts.formatters.prettier = {
      command = local_prettier,
      args = { "--stdin-filepath", "$FILENAME", "--config", root .. "/prettier.config.js" },
      stdin = true,
      prefer_local = "node_modules/.bin",
    }
  end,
}
