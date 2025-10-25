return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "MCPStart", "MCPStop", "MCPStatus", "MCPHub" },
    keys = {
      { "<leader>umh", "<cmd>MCPHub<cr>", desc = "MCP: Hub UI" },
      { "<leader>ums", "<cmd>MCPStart<cr>", desc = "MCP: Start" },
      { "<leader>umS", "<cmd>MCPStop<cr>", desc = "MCP: Stop" },
      { "<leader>umr", "<cmd>MCPStatus<cr>", desc = "MCP: Status" },
      {
        "<leader>umR",
        function()
          vim.cmd("MCPStop")
          vim.defer_fn(function()
            vim.cmd("MCPStart")
          end, 150)
        end,
        desc = "MCP: Restart",
      },
      {
        "<leader>umc",
        function()
          local cfg = vim.fn.expand("~/.config/mcphub/servers.json")
          if vim.fn.filereadable(cfg) == 1 then
            vim.cmd("edit " .. cfg)
          else
            vim.notify("servers.json not found at " .. cfg, vim.log.levels.WARN)
          end
        end,
        desc = "MCP: Edit servers.json",
      },
    },
    config = function()
      require("mcphub").setup({
        cmd = "/usr/local/bin/mcp-hub", -- your detected path
        auto_start = true,
        log_level = "info",
      })

      -- Optional: extra buffer-local mappings inside the Hub UI
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mcphub",
        callback = function(ev)
          local opts = { buffer = ev.buf, nowait = true, silent = true }
          -- Quick exit and restart from the UI
          vim.keymap.set("n", "Q", "<cmd>quit<cr>", opts)
          vim.keymap.set("n", "R", function()
            vim.cmd("MCPStop")
            vim.defer_fn(function()
              vim.cmd("MCPStart")
            end, 150)
          end, opts)
        end,
      })
    end,
  },
}
