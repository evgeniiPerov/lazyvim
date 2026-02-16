return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  opts = {
    defaults = {
      wrap_results = true,
      layout_config = {
        horizontal = {
          width = 0.95,
          preview_width = 0.65,
        },
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true,
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("live_grep_args")
  end,
  keys = {
    {
      "<leader><leader>",
      LazyVim.pick("files", { hidden = true }),
      desc = "Find Files (Root Dir, incl. hidden)",
    },
    {
      "<leader>/",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          additional_args = {
            "--hidden",
            "--glob=!.git/*",
            "--glob=!*.json",
            "--glob=!*mock*",
            "--glob=!*test*",
            "--glob=!*stories*",
            "--glob=!*.mdx",
            "--glob=!*.spec*",
          },
        })
      end,
      desc = "Grep main files (Root Dir, incl. hidden)",
    },
    {
      "<leader>?",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          additional_args = {
            "--hidden",
            "--glob=!.git/*",
            "--glob=*.json",
            "--glob=*mock*",
            "--glob=*test*",
            "--glob=*stories*",
            "--glob=*.mdx",
            "--glob=*.spec*",
          },
        })
      end,
      desc = "Grep tests/mock/stories/json (Root Dir, incl. hidden)",
    },
    {
      "<leader>se",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          additional_args = {
            "--hidden",
            "--no-ignore",
            "--glob=!.git/*",
            "--glob=!node_modules/*",
            "--glob=!pnpm-lock.yaml",
            "--glob=!*.lock",
          },
        })
      end,
      desc = "Grep (hidden + gitignored)",
    },
    {
      "<leader>sg",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Grep with args",
    },
  },
}
