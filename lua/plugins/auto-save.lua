return {
  "Pocco81/auto-save.nvim",
  config = function()
    require("auto-save").setup({
      enabled = true, -- Starts enabled
      execution_message = {
        message = function()
          return ""
        end, -- Disable message
      },
      events = { "InsertLeave", "TextChanged" }, -- Save after edits
      conditions = {
        exists = true, -- Only if file exists
        filename_is_not = {}, -- Skip specific filenames
        filetype_is_not = { "lazy" }, -- Skip specific filetypes
      },
      write_all_buffers = false, -- Save only the current buffer
    })
  end,
}
