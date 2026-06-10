return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
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
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = true,
            },
            require('nvim-treesitter.configs').setup {
                rainbow = {
                    enable = true,
                    -- list of languages you want to disable the plugin for
                    disable = { 'jsx', 'cpp' },
                    -- Which query to use for finding delimiters
                    query = 'rainbow-parens',
                    -- Highlight the entire buffer all at once
                    strategy = require('ts-rainbow').strategy.global,
                }
            }
        },
	},
}
