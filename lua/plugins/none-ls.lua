local util = require("lspconfig.util")

local root_dir_fn = util.root_pattern("turbo.json", "pnpm-workspace.yaml", ".git")
local has_biome = util.root_pattern("biome.json")(vim.fn.expand("%:p")) ~= nil

return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    opts = function(_, opts)
      local nls = require("null-ls")
      local eslint_d = require("none-ls.diagnostics.eslint_d")

      local function get_cwd()
        return root_dir_fn(vim.fn.expand("%:p")) or vim.fn.getcwd()
      end

      -- Priority: Biome first, fallback eslint_d + optional prettierd
      local sources = {}

      if has_biome then
        table.insert(sources, nls.builtins.formatting.biome)

        -- Biome LSP already provides diagnostics → this is optional and may not exist
        -- if nls.builtins.diagnostics.biome then
        --   table.insert(sources, nls.builtins.diagnostics.biome)
        -- end
      else
        table.insert(
          sources,
          eslint_d.with({
            cwd = function(_)
              return get_cwd()
            end,
          })
        )

        -- Optional: use prettierd only if installed
        -- table.insert(
        --   sources,
        --   nls.builtins.formatting.prettierd.with({
        --     cwd = function(_) return get_cwd() end,
        --   })
        -- )
      end

      opts.sources = sources
    end,
  },
}
