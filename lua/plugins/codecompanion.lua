--
-- ~/.config/nvim/lua/plugins/codecompanion.lua
--

-- This configuration is designed for a plugin manager like lazy.nvim.
-- It returns a Lua table that specifies the plugin to be loaded and its configuration.
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    -- Chat
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Chat", mode = { "n", "v" } },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Actions Menu", mode = { "n", "v" } },
    { "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "New Chat", mode = { "n", "v" } },
    -- Quick actions (visual mode - select code first)
    { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", desc = "Explain Code", mode = "v" },
    { "<leader>af", "<cmd>CodeCompanion /fix<cr>", desc = "Fix Code", mode = "v" },
    { "<leader>at", "<cmd>CodeCompanion /tests<cr>", desc = "Generate Tests", mode = "v" },
    { "<leader>al", "<cmd>CodeCompanion /lsp<cr>", desc = "Explain LSP Error", mode = "v" },
    { "<leader>am", "<cmd>CodeCompanion /commit<cr>", desc = "Commit Message", mode = "n" },
    -- Inline
    { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "Inline Prompt", mode = { "n", "v" } },
    -- Claude Code CLI (terminal)
    { "<leader>aC", function()
        vim.cmd("terminal claude")
        vim.cmd("startinsert")
      end, desc = "Claude Code CLI", mode = "n" },
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        http = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://127.0.0.1:11434",
              },
              schema = {
                model = { default = "qwen2.5-coder:7b" },
                num_ctx = { default = 16384 },
              },
            })
          end,
        },
      },
      strategies = {
        chat = { adapter = "ollama" },
        inline = { adapter = "ollama" },
        cmd = { adapter = "ollama" },
      },
    })
  end,
}
