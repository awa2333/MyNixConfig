return {
	"mfussenegger/nvim-lint",
	event = { "User FilePost" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			nix = { "statix", "deadnix" },
		}
	end,
}
