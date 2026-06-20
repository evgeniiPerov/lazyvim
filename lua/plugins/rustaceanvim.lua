return {
  "mrcjkb/rustaceanvim",
  -- rustaceanvim does NOT use setup(opts); it reads vim.g.rustaceanvim.
  -- (Plain `opts = {...}` is silently ignored without the LazyVim rust extra.)
  init = function()
    vim.g.rustaceanvim = vim.tbl_deep_extend("force", vim.g.rustaceanvim or {}, {
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
    })
  end,
}
