--
-- ~/.config/nvim/lua/plugins/codecompanion.lua
--
-- Claude Code integration via toggleterm
-- All AI keybindings under <leader>a

-- Ollama/CodeCompanion disabled for now — uncomment to re-enable
-- return {
--   "olimorris/codecompanion.nvim",
--   dependencies = { "nvim-lua/plenary.nvim" },
--   keys = { ... },
--   config = function()
--     require("codecompanion").setup({
--       adapters = {
--         http = {
--           ollama = function()
--             return require("codecompanion.adapters").extend("ollama", {
--               env = { url = "http://127.0.0.1:11434" },
--               schema = {
--                 model = { default = "qwen2.5-coder:7b" },
--                 num_ctx = { default = 16384 },
--               },
--             })
--           end,
--         },
--       },
--       strategies = {
--         chat = { adapter = "ollama" },
--         inline = { adapter = "ollama" },
--         cmd = { adapter = "ollama" },
--       },
--     })
--   end,
-- }

local claude_term = nil

local function claude_toggle()
  if claude_term and claude_term:is_open() then
    claude_term:toggle()
  else
    local Terminal = require("toggleterm.terminal").Terminal
    claude_term = Terminal:new({
      cmd = "claude",
      direction = "vertical",
      size = 80,
      close_on_exit = true,
      on_open = function()
        vim.cmd("startinsert")
      end,
    })
    claude_term:toggle()
  end
end

local function claude_with_context(prompt_prefix)
  return function()
    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")
    local cmd = "claude"
    if prompt_prefix then
      cmd = string.format("claude '%s %s:%d'", prompt_prefix, file, line)
    end
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new({
      cmd = cmd,
      direction = "vertical",
      size = 80,
      close_on_exit = true,
      on_open = function()
        vim.cmd("startinsert")
      end,
    })
    term:toggle()
  end
end

return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>aa", claude_toggle, desc = "Toggle Claude Code" },
    { "<leader>ae", claude_with_context("Explain this file"), desc = "Claude: Explain file", mode = "n" },
    { "<leader>af", claude_with_context("Fix the issue in"), desc = "Claude: Fix file", mode = "n" },
    { "<leader>ar", claude_with_context("Refactor"), desc = "Claude: Refactor file", mode = "n" },
  },
}
