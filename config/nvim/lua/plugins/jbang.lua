return {
    dir = "~/Github/jbang-lsp.nvim",
    name = "jbang-lsp.nvim",
    lazy = false,
    opts = {
        jdtls = {
            java = vim.fn.trim(vim.fn.system("mise where java@latest")) .. "/bin/java",
            lombok = vim.fn.stdpath("config") .. "/lib/lsp/java/lombok-1.18.48.jar",
        },
    },
    config = function(_, opts)
        require("jbang").setup(opts)
    end,
}
