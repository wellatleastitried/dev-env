return {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local rainbow_delimiters = require("rainbow-delimiters")
        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = rainbow_delimiters.strategy.global,
            },
            query = {
                [""] = "rainbow-delimiters",
            },
        }
    end,
}
