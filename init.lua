-- Read the .env file and set environment variables
local env_file = io.open(vim.fn.stdpath("config") .. "/.env", "r")
if env_file then
  for line in env_file:lines() do
    local key, value = line:match("([^=]+)=(.*)")
    if key and value then
      -- Remove surrounding quotes from the value
      value = value:gsub('^"', ''):gsub('"', '')
      vim.env[key] = value
    end
  end
  env_file:close()
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
