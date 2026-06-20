-- JS/TS debugging via js-debug-adapter (= VSCode's vscode-js-debug, same engine).
-- Pairs with the lazyvim dap.core extra (nvim-dap + dap-ui).
--
-- The configs here are GENERIC — they apply to every TS/JS repo (main-craft,
-- cms-administration, mexanika-landing, shelter, notification-service, ...).
-- What differs per app is only HOW you start it (see the start recipes in the
-- comment block at the bottom). Per-repo `.vscode/launch.json` files are also
-- auto-loaded, so app-specific configs can live in each repo and stay shared
-- with VSCode users.
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      local server = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      -- pwa-node = server-side node (NestJS, Next.js server, scripts).
      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = { command = "node", args = { server, "${port}" } },
        }
      end
      -- pwa-chrome = client-side (browser) — Next.js React components.
      if not dap.adapters["pwa-chrome"] then
        dap.adapters["pwa-chrome"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = { command = "node", args = { server, "${port}" } },
        }
      end
      -- aliases so older .vscode/launch.json files using type "node"/"chrome" resolve too
      dap.adapters["node"] = dap.adapters["node"] or dap.adapters["pwa-node"]
      dap.adapters["chrome"] = dap.adapters["chrome"] or dap.adapters["pwa-chrome"]

      -- ---- server-side (node) configs: apply to every JS/TS filetype ----
      local node_configs = {
        -- Attach to any running `node --inspect` process (pick from a list). Host apps.
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach: pick process (host)",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        -- Attach to an inspector port you type in. Works for any app/port.
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach: port (prompt)",
          address = "localhost",
          port = function()
            return tonumber(vim.fn.input("inspector port: ", "9229")) or 9229
          end,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          restart = true,
        },
        -- main-craft in docker (bind-mounted at /application -> map back to host).
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach: main-craft docker :9229",
          address = "localhost",
          port = 9229,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          restart = true,
          localRoot = "${workspaceFolder}",
          remoteRoot = "/application",
        },
        -- Launch the current file directly.
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch current file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
      }

      -- ---- client-side (browser) config: only for React filetypes ----
      local chrome_config = {
        type = "pwa-chrome",
        request = "launch",
        name = "Next.js client (chrome)",
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
      }

      for _, lang in ipairs({ "typescript", "javascript" }) do
        dap.configurations[lang] = node_configs
      end
      for _, lang in ipairs({ "typescriptreact", "javascriptreact" }) do
        dap.configurations[lang] = vim.list_extend({ chrome_config }, node_configs)
      end

      -- Also load any repo's .vscode/launch.json (shared with VSCode).
      local ok, vscode = pcall(require, "dap.ext.vscode")
      if ok then
        local map = {
          ["pwa-node"] = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
          ["pwa-chrome"] = { "typescriptreact", "javascriptreact" },
          ["node"] = { "typescript", "javascript" },
          ["chrome"] = { "typescriptreact", "javascriptreact" },
        }
        pcall(vscode.load_launchjs, nil, map)
      end
    end,
  },
}

-- START RECIPES (how to make each app debuggable) ---------------------------
--
--  HOST-run node apps (frontends run locally with `pnpm dev`):
--    NODE_OPTIONS='--inspect' pnpm dev      # Next.js server (cms-administration, mexanika-landing, shelter)
--    -> nvim: <leader>dc -> "Attach: pick process (host)"  (no path map needed)
--
--  Next.js CLIENT (browser/React) debugging:
--    pnpm dev   (normal)  -> <leader>dc -> "Next.js client (chrome)"  (needs chrome/chromium)
--
--  DOCKER node apps (main-craft):
--    docker compose -f compose.yml -f compose.debug.yml up
--    -> <leader>dc -> "Attach: main-craft docker :9229"
--    For OTHER dockerized apps: copy the compose.debug.yml pattern (expose 9229,
--    start node with --inspect=0.0.0.0:9229) and use "Attach: port (prompt)",
--    setting localRoot/remoteRoot in a per-repo .vscode/launch.json if the
--    container path differs from /application.
