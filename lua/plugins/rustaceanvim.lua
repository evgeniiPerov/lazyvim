return {
  "mrcjkb/rustaceanvim",
  opts = {
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
            extraArgs = { "--all-targets" },
          },
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = { enable = true },
          },
          procMacro = { enable = true },
          inlayHints = {
            closingBraceHints = { enable = true, minLines = 10 },
            parameterHints = { enable = true },
            typeHints = { enable = true },
          },
        },
      },
    },
  },
}
