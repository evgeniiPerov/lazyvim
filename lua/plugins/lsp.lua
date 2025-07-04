local util = require("lspconfig.util")

local root_dir = util.root_pattern("turbo.json", "pnpm-workspace.yaml", ".git")
local has_biome = util.root_pattern("biome.json")(vim.fn.expand("%:p")) ~= nil

local function get_tsdk()
  return vim.fs.joinpath(root_dir(vim.fn.expand("%:p")), "node_modules", "typescript", "lib")
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = false,
        biome = has_biome and {
          root_dir = root_dir,
          single_file_support = false,
        } or nil,

        tsserver = {
          enabled = false,
        },

        ts_ls = {
          enabled = false,
        },

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
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },

        graphql = {
          filetypes = {
            "graphql",
            "typescriptreact",
            "javascriptreact",
            "typescript",
            "javascript",
          },
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
          LazyVim.lsp.on_attach(function(client, buffer)
            -- Optional: moveToFileRefactoring can be added here
          end, "vtsls")

          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },
}
