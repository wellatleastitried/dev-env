return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        keymaps = {
            -- These need to freed because they are harpoon keybinds
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["<C-r>"] = "actions.refresh",
        },
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
}
