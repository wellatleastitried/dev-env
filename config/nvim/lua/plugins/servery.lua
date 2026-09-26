return {
    "wurli/servery",
    opts = {
        dirs = { "~" },
        session_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "servery.nvim"),
        ui = {
            -- Options: "builtin" | "snacks" | "fzf" | "telescope" | "mini_pick"
            provider = "telescope",-- ---@type servery.ui_provider

            prompt = "Nvim Sessions",
            icons = {
                current = "",
                active = "",
                inactive = "",
            },
            actions = {
                ["<enter>"] = "switch",
                ["<c-enter>"] = "switch_and_detach",
                ["<c-x>"] = "detach",
                ["<c-s>"] = "spawn",
            },
            -- fzf-lua uses fzf's keymap notation, so it gets its own actions table
            fzf_actions = {
                ["enter"] = "switch",
                ["ctrl-enter"] = "switch_and_detach",
                ["ctrl-x"] = "detach",
                ["ctrl-s"] = "spawn",
            },
        },
    },
    lazy = false
}
