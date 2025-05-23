-- https://www.lazyvim.org/extras/lang/typescript#nvim-lspconfig
-- https://www.lazyvim.org/configuration/recipes#add-eslint-and-use-it-for-formatting
local util = require("lazyvim.util")
local fs = vim.loop.fs_stat

return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = { eslint = {} }, -- still declare for conditional handling
    setup = {
      eslint = function()
        -- Only attach eslint if biome.json is not found
        local biome_config = fs(util.root.get() .. "/biome.json")
        if not biome_config then
          util.lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
          return false -- continue with default setup
        end
        return true -- skip eslint if biome.json is found
      end,
    },
  },
}
