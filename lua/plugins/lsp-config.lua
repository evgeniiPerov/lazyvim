return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tsserver = {
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayVariableTypeHints = true,
            },
          },
        },
      },
      -- vtsls = {
      --   settings = {
      --     typescript = {
      --       format = { enable = true },
      --       inlayHints = {
      --         parameterNames = { enabled = "all" },
      --         variableTypes = { enabled = true },
      --       },
      --     },
      --   },
      -- },
    },
    setup = {
      tsserver = function(_, opts)
        opts.cmd = {
          "node",
          "--max-old-space-size=4096",
          vim.fn.stdpath("data")
            .. "/mason/packages/typescript-language-server/node_modules/.bin/typescript-language-server",
          "--stdio",
        }
        return false
      end,
      -- vtsls = function(_, opts)
      --   opts.cmd = { "node", "--max-old-space-size=4096", vim.fn.stdpath("data") ..
      --   "/mason/packages/vtsls/node_modules/.bin/vtsls", "--stdio" }
      --   return false
      -- end,
    },
  },
}
