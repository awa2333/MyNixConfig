return {
	defaults = {
		lazy = true,
	},
	dev = {
		path = vim.fn.stdpath("data") .. "/site/pack/hm/opt",
		patterns = {
			"",
		},
	},
	change_detection = {
		notify = false,
	},
	install = {
		missing = false,
		colorscheme = {
			"nvchad",
		},
	},
	ui = {
		icons = {
			ft = "",
			lazy = "󰂠 ",
			loaded = "",
			not_loaded = "",
		},
	},
	performance = {
		reset_packpath = true,
		rtp = {
			reset = true,
			disabled_plugins = {
				"2html_plugin",
				"tohtml",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"matchit",
				"tar",
				"tarPlugin",
				"rrhelper",
				"spellfile_plugin",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				"tutor",
				"rplugin",
				"syntax",
				"synmenu",
				"optwin",
				"compiler",
				"bugreport",
				"ftplugin",
			},
		},
	},
}
