local function is_jbang(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)
  for _, line in ipairs(lines) do
    if line:match("^///?usr/bin/env jbang")
      or line:match("^//DEPS ")
      or line:match("^//JAVA ")
      or line:match("^//SOURCES ") then
      return true
    end
  end
  return false
end

_G.is_jbang = is_jbang

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.java",
  group = vim.api.nvim_create_augroup("JBangDetachJdtls", { clear = true }),
  callback = function(args)
    if not is_jbang(args.buf) then
      vim.diagnostic.enable(true, { bufnr = args.buf })
      return
    end
    vim.schedule(function()
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
        if client.name:find("jdt") then
          vim.lsp.buf_detach_client(args.buf, client.id)
        end
      end
      vim.diagnostic.enable(false, { bufnr = args.buf })
    end)
  end,
})

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


            -- TODO: Verify this works
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                group = vim.api.nvim_create_augroup("JdtlsStart", { clear = true }),
                callback = function(args)
                    if _G.is_jbang(args.buf) then
                        vim.diagnostic.enable(false, { bufnr = args.buf })
                        return
                    end
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



            --[[
            -- Bail out if it is a JBang script
            if _G.is_jbang(0) then
                return
            end

            -- Otherwise run normally
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
            ]]
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
