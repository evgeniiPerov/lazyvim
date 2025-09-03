local util = require("lspconfig.util")

-- Monorepo-friendly root
local root_dir = util.root_pattern("turbo.json", "pnpm-workspace.yaml", "yarn.lock", "package.json", ".git")

local function project_root()
  return root_dir(vim.fn.expand("%:p")) or vim.loop.cwd()
end

local function has_file_at_root(name)
  local root = project_root()
  return (vim.uv or vim.loop).fs_stat(root .. "/" .. name) ~= nil
end

local function get_tsdk()
  local dir = project_root()
  return vim.fs.joinpath(dir, "node_modules", "typescript", "lib")
end

-- Presence flags
local HAS_BIOME = has_file_at_root("biome.json")
local HAS_ESLINT = has_file_at_root(".eslintrc.js")
  or has_file_at_root(".eslintrc.cjs")
  or has_file_at_root(".eslintrc.json")
  or has_file_at_root("eslint.config.js")
  or has_file_at_root("eslint.config.mjs")

-- optional schemastore
local ok_schemastore, schemastore = pcall(require, "schemastore")

return {
  {
    "neovim/nvim-lspconfig",

    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("NoLspFormat_Save", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          -- Disable LSP formatting (use Conform instead)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end,

    opts = {
      servers = {
        eslint = false,

        biome = HAS_BIOME and {
          root_dir = root_dir,
          single_file_support = false,
        } or nil,

        tsserver = { enabled = false },
        ts_ls = { enabled = false },

        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_dir = root_dir,
          settings = {
            complete_function_calls = true,
            vtsls = {
              autoUseWorkspaceTsdk = false,
              tsdk = get_tsdk(),
              enableMoveToFileCodeAction = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = { enableServerSideFuzzyMatch = true },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
            javascript = {},
          },
        },

        graphql = {
          filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript" },
          root_dir = util.root_pattern("graphql.config.*", ".git"),
        },

        -- ✅ JSON LSP, no formatting
        jsonls = {
          root_dir = function(fname)
            return root_dir(fname) or vim.loop.cwd()
          end,
          filetypes = { "json", "jsonc" },
          settings = {
            json = {
              format = { enable = false }, -- disable LSP formatting
              validate = { enable = true }, -- keep diagnostics
              schemas = (ok_schemastore and schemastore.json.schemas()) or {},
            },
          },
        },
      },

      setup = {
        tsserver = function()
          return true
        end,
        ts_ls = function()
          return true
        end,
        eslint = function()
          return false
        end,
        vtsls = function(_, opts)
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },
}
