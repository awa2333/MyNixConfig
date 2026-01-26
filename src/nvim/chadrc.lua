---@type ChadrcConfig
return {
	base46 = { hl_override = {
		Comment = {
			italic = true,
		},
		["@comment"] = {
			italic = true,
		},
	} },
	ui = {
		statusline = {
			separator_style = "arrow",
		},
		tabufline = {
			lazyload = false,
		},
	},
	nvdash = {
		load_on_startup = true,
	},
}
