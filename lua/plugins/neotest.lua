return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Vitest adapter
      "marilari88/neotest-vitest",
    },
    opts = function()
      -- Auto-detect package manager from package.json
      local function get_package_manager()
        local package_json = vim.fn.getcwd() .. "/package.json"
        if vim.fn.filereadable(package_json) == 1 then
          local content = vim.fn.readfile(package_json)
          local json_str = table.concat(content, "\n")
          -- Simple pattern matching for packageManager field
          local pm = json_str:match('"packageManager"%s*:%s*"([^@"]+)')
          if pm then
            return pm
          end
        end
        -- Default to npm if no packageManager field found
        return "npm"
      end

      local package_manager = get_package_manager()
      local vitest_command = package_manager == "npm" and "npx vitest"
        or (package_manager .. " vitest")

      return {
        adapters = {
          ["neotest-vitest"] = {
            -- Filter for test files
            filter_dir = function(name)
              return name ~= "node_modules" and name ~= ".turbo"
            end,
            -- Auto-detected package manager command
            vitestCommand = vitest_command,
            -- Look for vitest config
            vitestConfigFile = "vitest.config.mts",
          },
        },
      -- Show test status in sign column
      status = {
        enabled = true,
        virtual_text = true,
        signs = true,
      },
      -- Floating window for test output
      output = {
        enabled = true,
        open_on_run = true,
      },
      -- Show diagnostics for failed tests
      diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.ERROR,
      },
      -- Icons for test status
      icons = {
        running = "⟳",
        passed = "✓",
        failed = "✗",
        skipped = "⊘",
        unknown = "?",
      },
    }
    end,
    keys = {
      -- Run nearest test (like VSCode's "Run Test")
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
      },
      -- Run current file tests
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run Current File Tests",
      },
      -- Run all tests in project
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.fn.getcwd())
        end,
        desc = "Run All Tests",
      },
      -- Toggle test summary (like VSCode test explorer)
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Test Summary",
      },
      -- Show test output
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Show Test Output",
      },
      -- Toggle output panel
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Test Output Panel",
      },
      -- Stop running tests
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop Tests",
      },
      -- Watch tests (like VSCode watch mode)
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Watch Mode",
      },
      -- Debug nearest test (requires nvim-dap)
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest Test",
      },
      -- Jump to next failed test
      {
        "]t",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Next Failed Test",
      },
      -- Jump to previous failed test
      {
        "[t",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Previous Failed Test",
      },
    },
    config = function(_, opts)
      -- Setup adapters
      opts.adapters = {
        require("neotest-vitest")(opts.adapters["neotest-vitest"] or {}),
      }

      require("neotest").setup(opts)
    end,
  },
}
