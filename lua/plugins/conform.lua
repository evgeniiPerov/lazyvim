return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local util = require("lspconfig.util")
    local fs = (vim.uv or vim.loop).fs_stat

    local function has_file(root, name)
      return fs(root .. "/" .. name) ~= nil
    end

    local function find_root(bufname)
      return util.root_pattern("turbo.json", "pnpm-workspace.yaml", "yarn.lock", "package.json", ".git")(bufname)
        or vim.loop.cwd()
    end

    local function detect_js_formatter(root)
      if has_file(root, "biome.json") then
        return { "biome" }
      end
      if
        has_file(root, ".prettierrc")
        or has_file(root, ".prettierrc.js")
        or has_file(root, ".prettierrc.cjs")
        or has_file(root, "prettier.config.js")
        or has_file(root, "prettier.config.cjs")
        or has_file(root, "prettier.config.mjs")
      then
        return { "prettier" }
      end
      return {}
    end

    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters = opts.formatters or {}

    -- Disable conform's built-in format_on_save (we use our own autocmd)
    opts.format_on_save = nil

    -- Dynamic JS/TS formatter detection per-buffer
    local js_ts_fts = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" }
    for _, ft in ipairs(js_ts_fts) do
      opts.formatters_by_ft[ft] = function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local root = find_root(bufname)
        return detect_js_formatter(root)
      end
    end

    -- Define formatters
    opts.formatters.biome = {
      command = "biome",
      args = {
        "check",
        "--write",
        "--stdin-file-path",
        "$FILENAME",
      },
      stdin = true,
      require_cwd = false,
      prefer_local = "node_modules/.bin",
    }

    -- ESLint is diagnostics-only (nvim-eslint). Do NOT add eslint as a formatter here.

    opts.formatters.prettier = {
      command = "prettier",
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
      prefer_local = "node_modules/.bin",
      require_cwd = false,
      cwd = require("conform.util").root_file({
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.js",
        "prettier.config.js",
        "package.json",
      }),
    }
  end,
}
