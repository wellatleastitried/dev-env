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

        view_options = {
            show_hidden = true,
            -- This function defines what is considered a "hidden" file
            is_hidden_file = function(name, bufnr)
                local m = name:match("^%.")
                return m ~= nil
            end,
            -- Sort file names with numbers in a more intuitive order for humans.
            -- Can be "fast", true, or false. "fast" will turn it off for large directories.
            natural_order = "fast",
            -- Sort file and directory names case insensitive
            case_insensitive = true,
            --[[
            sort = {
                -- sort order can be "asc" or "desc"
                -- see :help oil-columns to see which columns are sortable
                { "type", "asc" },
                { "name", "asc" },
            },
            ]]
        },
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
}
