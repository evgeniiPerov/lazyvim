return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        projects = {
          dev = {
            "~/projects",
            "~/projects/aihero",
            "~/projects/bagrat",
            "~/projects/cms-craft",
            "~/projects/cms-craft/projects",
            "~/projects/contributions",
            "~/projects/eos",
            "~/projects/notes",
            "~/projects/numazon",
            "~/projects/oriflame",
            "~/projects/rust",
            "~/.config",
          },
          ---@param item snacks.picker.Item
          transform = function(item)
            local path = item.file
            local home = os.getenv("HOME") or ""
            path = path:gsub("^" .. home, "~")

            -- Extract group (parent folder under ~/projects/)
            local group = path:match("~/projects/([^/]+)/")
            if group then
              item.group = group
              local name = path:match(".*/([^/]+)$") or path
              item.text = group .. "/" .. name
            end
            return item
          end,
        },
      },
    },
  },
  keys = {
    {
      "<leader>Pp",
      function()
        ---@type snacks.Config
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
  },
}
