return {
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			vim.list_extend(keys, {
				{ "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "Workspace symbol" },
				{ "<leader>vd", vim.diagnostic.open_float, desc = "Open diagnostic float" },
				{ "<leader>vca", vim.lsp.buf.code_action, desc = "Code action" },
				{ "<leader>vrr", vim.lsp.buf.references, desc = "References" },
				{ "<leader>vrn", vim.lsp.buf.rename, desc = "Rename" },
				{ "<C-h>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature help" },
			})
		end,
	},

	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
			},
		},
	},
}
