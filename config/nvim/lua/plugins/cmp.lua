return {
	"hrsh7th/nvim-cmp",
	ops = function()
		local cmp = require("cmp")
		cmp.setup({
			completion = {
				autocomplete = false,
			},
		})
	end,
}
