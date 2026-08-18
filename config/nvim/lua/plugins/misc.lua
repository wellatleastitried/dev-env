return {
    {
        "github/copilot.vim",
        event = "VeryLazy",
    },
    {
        "tpope/vim-dispatch",
        cmd = { "Dispatch", "Make", "Focus", "Start" },
    },
    {
        "monkoose/nvlime",
        dependencies = {
            "monkoose/parsley",
        },
        ft = { "lisp" },

        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "lisp",
                desc = "Banner reminder to start the Nvlime server",
                callback = function()
                    vim.notify(
                        "Lisp file detected.\nPress \\rr to start the Nvlime server!",
                        vim.log.levels.INFO,
                        { title = "Nvlime Setup" }
                    )
                end,
            })
        end,
    },
}
