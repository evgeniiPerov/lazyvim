return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Ensure plenary is installed
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "%.git/" }, -- Optional: Ignore .git folder explicitly
          hidden = true, -- Show hidden files by default
        },
        pickers = {
          find_files = {
            hidden = true, -- Include hidden files when using find_files
          },
        },
        extensions = {
          file_browser = {
            hidden = true, -- Show hidden files in the file browser
          },
        },
      })

      require("telescope").load_extension("file_browser")
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" }, -- Ensure telescope.nvim is a dependency
    keys = {
      {
        "<leader>sB",
        ":Telescope file_browser path=%:p:h=%:p:h<cr>",
        desc = "Browse Files",
      },
    },
  },
}
