vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"
vim.g.mapleader = " "
local lazy_config = require("lazy")
if not vim.loop.fs_stat(vim.g.base46_cache) then
	require("base46").load_all_highlights()
end
require("lazy").setup({
	dev = {
		path = vim.fn.stdpath("data") .. "/plugins",
		patterns = {
			"",
		},
	},
	install = {
		missing = false,
	},
	spec = {
		{ import = "plugins" },
	},
}, lazy_config)
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
require("configs")
