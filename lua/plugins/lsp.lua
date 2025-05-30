local util = require("lspconfig.util")
local root_patterns = { "biome.json", "package.json", "tsconfig.json", ".git" }

-- this must be declared BEFORE using it!
local function has_biome_json()
  return util.root_pattern("biome.json")(vim.fn.expand("%:p")) ~= nil
end
return {
  -- no need to declare biome → loaded dynamically
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = has_biome_json() and {
          root_dir = util.root_pattern("biome.json", ".git"),
          single_file_support = false,
        } or nil,
        eslint = {
          root_dir = util.root_pattern(unpack(root_patterns)),
          single_file_support = false,
          settings = {
            workingDirectories = { mode = "auto" },
            codeActionOnSave = {
              enable = true,
              mode = "all",
            },
          },
        },
        tsserver = {
          cmd = { "typescript-language-server", "--stdio" },
          root_dir = util.root_pattern(unpack(root_patterns)),
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
    },
  },
}
