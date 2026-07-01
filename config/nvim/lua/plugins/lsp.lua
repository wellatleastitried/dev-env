return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                ["*"] = {
                    keys = {
                        { "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "Workspace symbol" },
                        { "<leader>vd", vim.diagnostic.open_float, desc = "Open diagnostic float" },
                        { "<leader>vca", vim.lsp.buf.code_action, desc = "Code action" },
                        { "<leader>vrr", vim.lsp.buf.references, desc = "References" },
                        { "<leader>vrn", vim.lsp.buf.rename, desc = "Rename" },
                        { "<C-h>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature help" },
                    },
                },
            },
        },
    },

	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"zls",
				"bash-language-server",
				"pyright",
                "clangd",
                "cmake-language-server",
                "css-lsp",
                "elixir-ls",
                "gopls",
                "groovy-language-server",
                "html-lsp",
                "htmx-lsp",
                "hyprls",
                "jdtls",
                "just-lsp",
                "ocaml-lsp",
                "perlnavigator",
                "solidity-ls",
                "sqls",
                "stylua",
                "textlsp",
                "yaml-language-server",
                "clojure-lsp",
			},
			autoformat = false,
		},
	},
}
