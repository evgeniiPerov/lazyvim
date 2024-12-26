return {
  {
    "vuki656/package-info.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim", -- Required dependency for package-info.nvim
    },
    config = function()
      require("package-info").setup({
        autostart = true, -- Automatically start the plugin
      })
    end,
  },
}
