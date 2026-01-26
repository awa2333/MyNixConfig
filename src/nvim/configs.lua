require("nvchad.autocmds")

vim.schedule(function()
	local map = vim.keymap.set
	require("nvchad.mappings")
end)

require("nvchad.options")
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.wo.colorcolumn = "160"
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
vim.o.ignorecase = false
vim.o.smartcase = false
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.autoread = true
vim.bo.autoread = true
vim.wo.wrap = false
vim.o.whichwrap = "<,>,[,]"
vim.o.mouse = "a"
vim.o.list = false
vim.o.listchars = "space:·,tab:>-"
vim.o.wildmenu = true
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.cursorline = true
if vim.g.neovide then
	vim.g.neovide_position_animation_length = 0.05
	vim.g.neovide_cursor_antialiasing = true
	vim.g.neovide_cursor_vfx_mode = "pixiedust"
	vim.g.neovide_cursor_vfx_opacity = 200.0
	vim.g.neovide_cursor_vfx_particle_lifetime = 0.5
	vim.g.neovide_cursor_vfx_particle_density = 50
	vim.g.neovide_cursor_vfx_particle_speed = 100.0
	vim.g.neovide_normal_opacity = 0.8
end
