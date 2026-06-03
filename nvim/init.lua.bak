vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
if not vim.loop.fs_stat(vim.g.base46_cache) then
	require("base46").load_all_highlights()
end
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/site/pack/hm/opt/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
local lazy_config = require("lazy-config")
require("lazy").setup({
	{
		"NvChad/NvChad",
		dir = vim.fn.stdpath("data") .. "/site/pack/hm/opt/nvchad",
		lazy = false,
		import = "nvchad.plugins",
	},
	{
		import = "plugins",
	},
}, lazy_config)
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
require("configs")
