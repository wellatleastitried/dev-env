print("Fuck blink.cmp")

return {
	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				ghost_text = {
					enabled = false,
				},
			},
			keymap = {
				preset = "default",
				["<CR>"] = {}, -- Disable the worst default keybind in existence
				["<C-y>"] = { "accept", "fallback" },
				["<Tab>"] = { "fallback" },
			},
		},
	},
}
