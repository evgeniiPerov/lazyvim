return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local util = require("lspconfig.util")
    local root = (
      util.root_pattern("turbo.json", "pnpm-workspace.yaml", "yarn.lock", "package.json", ".git")(vim.fn.expand("%:p"))
    ) or vim.loop.cwd()
    local fs = (vim.uv or vim.loop).fs_stat

    local function has_file(name)
      return fs(root .. "/" .. name) ~= nil
    end

    local HAS_BIOME = has_file("biome.json")
    local HAS_ESLINT = has_file(".eslintrc.js")
      or has_file(".eslintrc.cjs")
      or has_file(".eslintrc.json")
      or has_file("eslint.config.js")
      or has_file("eslint.config.mjs")
    local HAS_PRETTIER = has_file(".prettierrc")
      or has_file(".prettierrc.js")
      or has_file(".prettierrc.cjs")
      or has_file("prettier.config.js")
      or has_file("prettier.config.cjs")
      or has_file("prettier.config.mjs")

    -- Set up once
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters = opts.formatters or {}

    opts.format_on_save = {
      lsp_fallback = false,
      timeout_ms = 5000,
    }

    -- JS/TS/React formatting policy
    local js_ts_fmt
    if HAS_BIOME then
      js_ts_fmt = { "biome" }
    elseif HAS_PRETTIER then
      js_ts_fmt = { "prettier" }
    else
      js_ts_fmt = {} -- nothing → no accidental formatting
    end

    opts.formatters_by_ft.javascript = js_ts_fmt
    opts.formatters_by_ft.javascriptreact = js_ts_fmt
    opts.formatters_by_ft.typescript = js_ts_fmt
    opts.formatters_by_ft.typescriptreact = js_ts_fmt

    -- JSON/JSONC too
    local json_fmt = HAS_BIOME and { "biome" } or (HAS_PRETTIER and { "prettier" } or {})
    opts.formatters_by_ft.json = json_fmt
    opts.formatters_by_ft.jsonc = json_fmt

    -- Define formatters
    opts.formatters.biome = {
      command = "biome",
      args = { "format", "-", "--stdin-file-path", "$FILENAME" },
      stdin = true,
      require_cwd = false,
      -- prefer local biome if present
      prefer_local = "node_modules/.bin",
    }

    -- ESLint is diagnostics-only (nvim-eslint). Do NOT add eslint as a formatter here.

    local local_prettier = root .. "/node_modules/.bin/prettier"
    opts.formatters.prettier = {
      command = (vim.uv or vim.loop).fs_stat(local_prettier) and local_prettier or "prettier",
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
      prefer_local = "node_modules/.bin",
      require_cwd = false,
    }
  end,
}
