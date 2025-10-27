print("FUCKING CMP LOAD")

return {
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")

			opts.experimental = {
				ghost_text = false,
			}

			opts.mapping = vim.cmp.mapping.preset.insert({
				["<CR>"] = function(fallback)
					fallback()
				end,
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					fallback()
				end),
			})
		end,
	},
}
