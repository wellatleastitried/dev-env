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
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local mason_path = vim.fn.stdpath("data") .. "/mason"
            local java = vim.fn.trim(vim.fn.system("mise where java@latest")) .. "/bin/java"
            local jdk_home = vim.fn.trim(vim.fn.system("mise where java@latest"))
            local launcher_jar = vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]

            local jdtls = require("jdtls")

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                group = vim.api.nvim_create_augroup("JdtlsStart", { clear = true }),
                callback = function(args)
                    if require("jbang").is_jbang(args.buf) then return end
                    jdtls.start_or_attach({
                        cmd = {
                            java,
                            "-javaagent:" .. vim.fn.stdpath("config") .. "/lib/lsp/java/lombok-1.18.48.jar",
                            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                            "-Dosgi.bundles.defaultStartLevel=4",
                            "-Declipse.product=org.eclipse.jdt.ls.core.product",
                            "-Dlog.protocol=true",
                            "-Dlog.level=ALL",
                            "-Xms1g",
                            "--add-modules=ALL-SYSTEM",
                            "--add-opens", "java.base/java.util=ALL-UNNAMED",
                            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                            "-jar", launcher_jar,
                            "-configuration", mason_path .. "/packages/jdtls/config_linux",
                            "-data", vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
                        },
                        root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
                        settings = {
                            java = {
                                home = jdk_home,
                                configuration = { updateBuildConfiguration = "automatic" },
                                import = {
                                    gradle = {
                                        enabled = true,
                                        wrapper = { enabled = true },
                                        offline = { enabled = false },
                                    },
                                    maven = { enabled = true },
                                },
                                eclipse = { downloadSources = true },
                                maven = {
                                    downloadSources = true,
                                    updateSnapshots = true,
                                },
                                references = { includeDecompiledSources = true },
                                saveActions = { organizeImports = true },
                                completion = { enabled = true },
                            },
                        },
                    })
                end,
            })
            -- config runs after the first java FileType already fired, so handle this buffer too
            if vim.bo.filetype == "java" then
                vim.api.nvim_exec_autocmds("FileType", { group = "JdtlsStart" })
            end
        end,
    },
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"bash-language-server",
				"pyright",
                "clangd",
                "cmake-language-server",
                "css-lsp",
                "gopls",
                "html-lsp",
                "jdtls",
                "just-lsp",
                "perlnavigator",
                "sqls",
                "stylua",
                "textlsp",
                "yaml-language-server",
			},
			autoformat = false,
		},
	},
}
