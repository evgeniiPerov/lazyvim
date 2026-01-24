---@type CordConfig
local opts = {
  display = {
    theme = "default",
    flavor = "dark",
  },
}

return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  opts = opts,
}
