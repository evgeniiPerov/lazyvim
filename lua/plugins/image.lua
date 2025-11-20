return {
  "3rd/image.nvim",
  event = "VeryLazy",
  build = false,
  opts = {
    backend = "kitty",
    integrations = {},
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 50,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = false,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = false,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  },
}
