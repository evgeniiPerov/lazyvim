--
-- ~/.config/nvim/lua/plugins/claude.lua
-- Custom "Claude with context" actions via toggleterm: prompt the current
-- file:line into a one-shot `claude` terminal.
--
-- NOTE: the native claudecode.nvim integration (ai.claudecode extra) already owns
-- <leader>ac (toggle), af (focus), ar (resume), aC (continue), aa/ab/as/ad (diff/buffer/send).
-- These custom actions live on FREE keys (aE/aF/aR) to avoid colliding with it.
--

local function claude_with_context(prompt_prefix)
  return function()
    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")
    -- shellescape the whole prompt so paths with spaces/quotes don't break the command
    local cmd = "claude " .. vim.fn.shellescape(prompt_prefix .. " " .. file .. ":" .. line)
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
    { "<leader>aE", claude_with_context("Explain this file"), desc = "Claude: Explain file" },
    { "<leader>aF", claude_with_context("Fix the issue in"), desc = "Claude: Fix file" },
    { "<leader>aR", claude_with_context("Refactor"), desc = "Claude: Refactor file" },
  },
}
