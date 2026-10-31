return {
	"max397574/better-escape.nvim",
	event = { "CmdLineEnter", "InsertEnter" },
	opts = {
		timeout = vim.o.timeoutlen,
		default_mappings = false,
		mappings = {
			i = {
				j = {
					k = "<Esc>",
				},
			},
			c = {
				j = {
					k = "<C-c>",
				},
			},
			t = {
				k = {
					j = "<C-\\><C-n>",
				},
			},
			s = {
				j = {
					k = "<Esc>",
				},
			},
		},
	},
}
