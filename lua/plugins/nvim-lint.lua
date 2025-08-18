return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}
    -- Remove JS/TS linting to avoid conflicts with nvim-eslint
    opts.linters_by_ft.javascript = nil
    opts.linters_by_ft.javascriptreact = nil
    opts.linters_by_ft.typescript = nil
    opts.linters_by_ft.typescriptreact = nil
  end,
}
