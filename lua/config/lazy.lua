local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Load LazyVim core and its default plugin set
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Language extras
    -- You can uncomment the built-in TypeScript extras if you wish,
    -- but note that we already use "pmizio/typescript-tools.nvim"
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },

    -- Formatters/Linters: choose what you prefer
    -- Prioritize Biome:
    { import = "lazyvim.plugins.extras.formatting.biome" },
    -- Also load ESLint + Prettier if you want them:
    -- (LazyVim has extras for these if you prefer automatic setup)
    -- { import = "lazyvim.plugins.extras.linting.eslint" },
    -- { import = "lazyvim.plugins.extras.formatting.prettier" },

    -- If you rely on null-ls for certain code actions
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.util.rest" },

    -- Import your custom plugin specs (like the files above)
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false,
  },
  performance = {
    rtp = {
      -- Disable some default runtime plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
