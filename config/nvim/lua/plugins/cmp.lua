return {
	"hrsh7th/nvim-cmp",
	enabled = false,
	ops = function(_, opts)
		local cmp = require("cmp")
		cmp.mapping["<CR>"] = nil
	end,
}
