# AGENTS.md — Neovim config

Universal entry doc for this Neovim configuration. Read by any AI agent (Claude Code, Codex, Gemini CLI, Copilot CLI, …). `CLAUDE.md` is a symlink to this file.

> Machine-specific values (absolute paths, system specs, binary locations, theme symlink target) live in **`AGENTS.local.md`** (gitignored). See [Local overrides](#local-overrides).

## Overview

Built on **LazyVim**. Official docs: https://lazyvim.github.io/. nvim **0.12.x**. Lua only, no Vimscript.

## Architecture

- `init.lua` — minimal bootstrap (`require("config.lazy")`).
- `lua/config/` — core:
  - `lazy.lua` — plugin manager bootstrap + settings (`defaults.lazy = false`, update checker on).
  - `options.lua` — `vim.opt`/`vim.o` (incl. `vim.g.autoformat = false`).
  - `keymaps.lua` — custom keybindings (all `vim.keymap.set` with `desc`).
  - `autocmds.lua` — formatting-on-save (conform), `.env` filetype handling, **big-file LSP degrade**.
- `lua/plugins/` — one spec per file (34 specs).
- `lazy-lock.json` — version lockfile.
- `lazyvim.json` — LazyVim extras: `ai.claudecode`, `dap.core`, `editor.neo-tree`, `editor.harpoon2`, `lang.json`, `lang.python`.

To add a plugin: new file in `lua/plugins/` returning a spec table. Disable a plugin: `enabled = false`.

## Key decisions

| Concern | Choice | Notes |
|---|---|---|
| Formatting | **conform.nvim** + custom `BufWritePre` autocmd | LazyVim autoformat off (`vim.g.autoformat = false`). JS/TS: biome if `biome.json`, else prettier. Monorepo root via turbo.json/pnpm-workspace.yaml. `.env` excluded. |
| JS/TS lint | **nvim-eslint** (diagnostics only, `eslint_d`) | nvim-lint disabled for JS/TS to avoid conflict. Skips when `biome.json` present. |
| Testing | **neotest** + neotest-vitest + neotest-jest | `<leader>t*` (VSCode-style, intentionally remapped — `tt`=nearest, `ta`=all). |
| Debugging | **nvim-dap** (dap.core extra) + js-debug-adapter | `lua/plugins/dap-js.lua`. pwa-node + pwa-chrome. main-craft docker via `compose.debug.yml` → attach :9229. See file's bottom comment for per-app start recipes. |
| Terminal | **toggleterm** | `<C-/>` horiz, `<C-\>` float. Overlaps snacks terminal (toggleterm wins; kept for `TermExec`/Claude/test runners). |
| AI | **Claude Code** via toggleterm vertical split | `lua/plugins/codecompanion.lua` (file misnamed — it defines the Claude keymaps, not CodeCompanion). `<leader>a*`. |
| Rust | **rustaceanvim** | No LazyVim rust extra. Configured via `vim.g.rustaceanvim` (NOT `setup()`). |
| Theme | **omarchy** hand-rolled highlights | `lua/plugins/theme.lua` is a symlink into `~/.config/omarchy/...` (path in AGENTS.local.md). Hot-reload via `omarchy-theme-hotreload.lua` on `User LazyReload`. 11 extra colorschemes in `all-themes.lua` (lazy, available for switching). |
| Scrolling | **neoscroll** (animation) + snacks scroll disabled + nvim-scrollview (scrollbar) | Three scroll-related specs are complementary, NOT conflicting. |
| Big files | LSP semantic-tokens + inlay-hints disabled on buffers ≥5000 lines | `autocmds.lua`. vtsls `maxTsServerMemory = 8192`. Treesitter/LSP stay attached. See [[project_bigfile_lsp_lag]] memory. |

## Code style

stylua.toml: 2-space indent, 120 width. Run `~/.local/share/nvim/mason/bin/stylua <files>` (path in AGENTS.local.md).

## Keymaps

See [keymaps.md](keymaps.md) for the custom-keymap reference (regenerate after key changes — see that file's header). Live source of truth is **which-key** (press `<leader>`).

## Audit (2026-06-20)

Full plugin-by-plugin audit run.

**Fixed (mechanical):** invalid `jsx` treesitter parser; redundant treesitter `highlight`; scrollview dead `vim.g.column` + duplicate sign + missing lazy-load; rustaceanvim `opts`→`vim.g.rustaceanvim` (was silently ignored); project.nvim broken telescope keymap → snacks; deprecated `vim.loop.cwd()`→`vim.uv.cwd()` (conform, nvim-eslint); pointless lazydev `enabled` override; mason comment; big-file inlay-hint race.

**Fixed (judgment calls):** AI keymap conflict — native claudecode (`<leader>ac/af/ar/aC`) vs custom Claude actions, moved custom to `<leader>aE/aF/aR`; `codecompanion.lua` deleted (dead Ollama block) → renamed `claude.lua` + shell-quote bug fixed; `screenkey` no longer auto-toggles ON at startup; `git.lua` dropped git-blame.nvim (redundant w/ gitsigns) + gitlinker → maintained `linrongbin16` fork (`<leader>gy/gY`); `neotest` config now preserves all extra-registered adapters (neotest-python kept); `noice` dropped `inc_rename` no-op + removed `<C-f>/<C-b>` (neoscroll owns them); `mcphub` `auto_start=false` (was a no-op under lazy-load); `all-themes` removed no-op `priority`.

**Left alone (needs your call):** `omarchy-theme-hotreload` passes a function colorscheme to string APIs + references a non-existent `plugin/after/transparency.lua` — tied to your external omarchy workflow, too risky to touch blindly. The 11 theme plugins in `all-themes.lua` are kept (omarchy theme-switch may reference them).

## Local overrides

`AGENTS.local.md` (gitignored) holds everything machine-specific: system specs, absolute paths, binary locations, the omarchy theme symlink target. Anything that only matters on THIS PC goes there, not here.
