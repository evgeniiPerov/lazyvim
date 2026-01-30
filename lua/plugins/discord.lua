-- Get project name from package.json or fallback to folder name
local function get_project_name()
  local cwd = vim.fn.getcwd()

  -- Try to read package.json
  local package_json = cwd .. "/package.json"
  local file = io.open(package_json, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local name = content:match('"name"%s*:%s*"([^"]+)"')
    if name then
      return name
    end
  end

  -- Fallback to folder name
  return vim.fn.fnamemodify(cwd, ":t")
end

---@type CordConfig
local opts = {
  enabled = true, -- Enable by default for testing
  display = {
    theme = "default",
    flavor = "dark",
  },
  text = {
    workspace = function()
      return "Working on " .. get_project_name()
    end,
    editing = function(o)
      return "Editing " .. o.filename
    end,
    viewing = function(o)
      return "Viewing " .. o.filename
    end,
  },
  -- Override Angular detection for NestJS projects
  -- Keys must match: filetype, full filename, or extension pattern (e.g., ".module.ts")
}

return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  event = "VeryLazy", -- Load on startup
  opts = opts,
  keys = {
    { "<leader>tc", "<cmd>Cord toggle<cr>", desc = "Toggle Discord Presence" },
  },
}
