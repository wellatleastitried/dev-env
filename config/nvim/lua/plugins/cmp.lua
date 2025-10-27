return {
	"hrsh7th/nvim-cmp",
	ops = function(_, opts)
		local cmp = require("cmp")
		["C-Space-CR>"] = cmp.mapping.confirm({ select = auto_select }),
	end,
}
