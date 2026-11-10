return {
	"mfussenegger/nvim-lint",
	event = { "User FilePost" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			nix = { "statix", "deadnix" },
		}
		lint.try_lint()
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			callback = function()
				if vim.opt_local.modifiable:get() then
					lint.try_lint()
				end
			end,
		})
	end,
}
