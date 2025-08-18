local util = require("lspconfig.util")

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

local HAS_BIOME = has_file_at_root("biome.json")
-- HAS_ESLINT computed but unused; keep if you’ll use later
-- local HAS_ESLINT = ...

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
          -- We format via Conform; prevent LSP formatting
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end,

    opts = {
      servers = {
        -- ✅ JSON LSP without format-on-save
        jsonls = {
          root_dir = root_dir,
          filetypes = { "json", "jsonc" },
          settings = {
            json = {
              format = { enable = false }, -- keep formatter off
              validate = { enable = true }, -- turn diagnostics on (set false if you want none)
              schemas = ok_schemastore and schemastore.json.schemas() or {},
            },
          },
          on_new_config = function(new_config)
            -- ensure schemas table exists even if schemastore missing
            new_config.settings = new_config.settings or {}
            new_config.settings.json = new_config.settings.json or {}
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          end,
        },

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
