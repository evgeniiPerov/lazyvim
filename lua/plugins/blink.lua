return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      -- next-intl / heavy generic types make tsserver's completion-docs resolve
      -- take seconds -> popup freeze. Show docs only on demand (<C-space>), not auto.
      documentation = {
        auto_show = false,
      },
    },
  },
}
