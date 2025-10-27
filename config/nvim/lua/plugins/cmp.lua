return {
	"hrsh7th/nvim-cmp",
	ops = function(_, opts)
		local cmp = require("cmp")
        opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        ["<CR>"] = cmp.config.disable,
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        })
	end,
},
