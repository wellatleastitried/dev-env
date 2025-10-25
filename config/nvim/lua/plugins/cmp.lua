return {
	"hrsh7th/nvim-cmp",
	ops = function(_, opts)
		local cmp = require("cmp")
		opts.mapping["<CR>"] = nil
	end,
}
