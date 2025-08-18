local util = require("lspconfig.util")

local root_dir = util.root_pattern(
  -- eslint configs (flat first)
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  -- legacy configs
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  -- monorepo markers
  "turbo.json",
  "pnpm-workspace.yaml",
  "yarn.lock",
  "package.json",
  ".git"
)

local function project_root()
  return root_dir(vim.fn.expand("%:p")) or vim.loop.cwd()
end

local function has(root, name)
  return (vim.uv or vim.loop).fs_stat(root .. "/" .. name) ~= nil
end

return {
  "esmuellert/nvim-eslint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local root = project_root()
    local is_flat = has(root, "eslint.config.js") or has(root, "eslint.config.mjs") or has(root, "eslint.config.cjs")
    local has_biome = has(root, "biome.json")

    -- If biome.json exists at this root, let Biome handle linting (avoid duplicate/contradicting rules)
    if has_biome then
      vim.notify("nvim-eslint disabled: biome.json detected at " .. root, vim.log.levels.DEBUG)
      return
    end

    require("nvim-eslint").setup({
      bin = "eslint",
      prefer_local = "node_modules/.bin",
      code_actions = false, -- diagnostics only; formatting via conform
      debounce = 100,
      diagnostics_format = "[eslint] ${message} [${ruleId}]",
      root = root,

      -- VSCode-equivalent behavior in monorepos
      settings = {
        useFlatConfig = is_flat, -- auto-detect
        workingDirectory = { mode = "auto" }, -- walk up to the right config like VSCode
        nodePath = nil, -- resolve local node_modules
        options = {
          cwd = root, -- important for shared presets
          resolvePluginsRelativeTo = root, -- resolve plugins/presets from repo root
        },
        run = "onType",
        format = false,
      },

      -- less noise
      extra_args = { "--no-warn-ignored" },
    })
  end,
}
