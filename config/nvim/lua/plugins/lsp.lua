local mason_jdtls = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
local function resolve_mise_java(root_dir)
    local mise = vim.fn.exepath("mise")
    if mise == "" then
        return nil
    end

    local result = vim.system({ mise, "which", "java" }, { text = true, cwd = root_dir }):wait()
    if result.code ~= 0 then
        return nil
    end

    local java = vim.trim(result.stdout or "")
    if java == "" then
        return nil
    end

    return java
end

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
                    cmd = { mason_jdtls },
                    on_new_config = function(new_config, new_root_dir)
                        local java = resolve_mise_java(new_root_dir)
                        if java ~= nil then
                            new_config.cmd = { mason_jdtls, "--java-executable", java }
                            return
                        end

                        new_config.cmd = { mason_jdtls }
                    end,
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
