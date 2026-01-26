return {
	{ "NvChad/ui", dir = vim.fn.stdpath("data") .. "/plugins/nvchad-ui" },
	{ "L3MON4D3/LuaSnip", dir = vim.fn.stdpath("data") .. "/plugins/luasnip" },
	{ "NvChad/NvChad", dir = vim.fn.stdpath("data") .. "/plugins/nvchad", lazy = false, import = "nvchad.plugins" },
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "nixfmt" },
				javascript = { "biome" },
				bash = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			vim.lsp.enable({ "bashls", "tinymist", "taplo", "ruff", "biome", "nil_ls", "lua_ls", "basedpyright" })
		end,
	},
	{
		import = "nvchad.blink.lazyspec",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{
				"HiPhish/rainbow-delimiters.nvim",
				config = function()
					require("rainbow-delimiters")
					vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/treesitter")
				end,
			},
		},
		opts = {
			auto_install = false,
			ensure_installed = {},
		},
	},
}
