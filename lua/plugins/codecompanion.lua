return {
	"olimorris/codecompanion.nvim",
	enabled = false, -- Disabled in favor of avante.nvim
	lazy = false,
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		{
			"stevearc/dressing.nvim",
			opts = {},
		},
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "ollama",
				},
				inline = {
					adapter = "ollama",
				},
			},
			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "deepseek-coder:latest",
							},
						},
					})
				end,
			},
		})
	end,
	keys = {
		{
			"<leader>cc",
			"<cmd>CodeCompanionChat<cr>",
			mode = { "n", "v" },
			desc = "CodeCompanion: Chat",
		},
		{
			"<leader>ca",
			"<cmd>CodeCompanionActions<cr>",
			mode = { "n", "v" },
			desc = "CodeCompanion: Actions",
		},
		{
			"<leader>ct",
			"<cmd>CodeCompanionChat Toggle<cr>",
			mode = { "n", "v" },
			desc = "CodeCompanion: Toggle",
		},
	},
}
