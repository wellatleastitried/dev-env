local mason_jdtls = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

local java = vim.fn.trim(vim.fn.system("mise where java@latest")) .. "/bin/java"

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
                jdtls = {
                    cmd = {
                        mason_jdtls,
                        "--jvm-arg=-javaagent:" .. vim.fn.stdpath("config") .. "/lib/lsp/java/lombok-1.18.48.jar",
                        "--java-executable",
                        java
                    },
                    init_options = {
                        extendedClientCapabilities = {
                            resolveAdditionalTextEditsSupport = true,
                        },
                        bundles = {},
                    },
                    settings = {
                        java = {
                            configuration = { updateBuildConfiguration = "automatic" },
                            import = {
                                gradle = {
                                    enabled = true,
                                    wrapper = {
                                        enabled = true,
                                    },
                                    offline = {
                                        enabled = false,
                                    },
                                },

                                maven = {
                                    enabled = true,
                                },
                            },
                            eclipse = { downloadSources = true },
                            maven = {
                                downloadSources = true,
                                updateSnapshots = true,
                            },
                            references = {
                                includeDecompiledSources = true,
                                classFileContentsSupport = true,
                            },
                            saveActions = { organizeImports = true },
                            completion = { enabled = true },
                            --[[
                            jdt = {
                                ls = {
                                    vmargs = {
                                        "-javaagent:" .. vim.fn.stdpath("config") .. "/lib/lombok-1.18.48.jar"
                                    }
                                },
                            },
                            ]]
                        },
                    },
                }
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
                "gopls",
                "groovy-language-server",
                "html-lsp",
                "jdtls",
                "just-lsp",
                "perlnavigator",
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
