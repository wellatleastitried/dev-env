return {
	"hrsh7th/nvim-cmp",
	ops = function()
		local cmp = require("cmp")
		enabled = false
		return {
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-CR>"] = cmp.mapping.abort(),
				["<C-Space-CR>"] = cmp.mapping.confirm({ select = true }),
			}),
		}
	end,
}
