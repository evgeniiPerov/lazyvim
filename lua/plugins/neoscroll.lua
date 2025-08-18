return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    local neoscroll = require("neoscroll")

    neoscroll.setup({
      -- keep your prefs
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = true,
      cursor_scrolls_alone = true,
      easing = "quadratic", -- renamed in latest README from easing_function
      duration_multiplier = 1.0, -- global multiplier if you want to tweak speed
    })

    -- Use helper functions instead of set_mappings()
    local map = function(keys, fn)
      vim.keymap.set({ "n", "v", "x" }, keys, fn, { silent = true })
    end

    -- half-page up/down with 120ms
    map("<C-u>", function()
      neoscroll.ctrl_u({ duration = 120 })
    end)
    map("<C-d>", function()
      neoscroll.ctrl_d({ duration = 120 })
    end)

    -- full-page up/down with 160ms
    map("<C-b>", function()
      neoscroll.ctrl_b({ duration = 160 })
    end)
    map("<C-f>", function()
      neoscroll.ctrl_f({ duration = 160 })
    end)

    -- zt/zz/zb with ~140ms (uses half_win_duration)
    map("zt", function()
      neoscroll.zt({ half_win_duration = 140 })
    end)
    map("zz", function()
      neoscroll.zz({ half_win_duration = 140 })
    end)
    map("zb", function()
      neoscroll.zb({ half_win_duration = 140 })
    end)
  end,
}
