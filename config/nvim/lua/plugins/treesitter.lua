return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "HiPhish/nvim-ts-rainbow2",
        },
        opts = function(_, opts)
            opts.ensure_installed = {
                "javascript",
                "typescript",
                "ruby",
                "python",
                "java",
                "perl",
                "bash",
                "c",
                "lua",
                "query",
                "markdown",
            }
            opts.sync_install = false
            opts.auto_install = true
            opts.highlight = {
                enable = true,
                additional_vim_regex_highlighting = true,
            }
            opts.rainbow = {
                enable = true,
                disable = { "jsx", "cpp" },
                query = "rainbow-parens",
                strategy = require("ts-rainbow").strategy.global,
            }
        end,
    },
}
