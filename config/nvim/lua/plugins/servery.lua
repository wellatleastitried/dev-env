local function is_git_repo(path)
    return vim.fn.isdirectory(path .. "/.git") == 1
end

local function get_repo_dirs(base)
    local dirs = {}
    local top_level = vim.fn.glob(base .. "/*", true, true)

    for _, path in ipairs(top_level) do
        if vim.fn.isdirectory(path) == 1 then
            if is_git_repo(path) then
                -- It's a repo itself; stop here so we don't descend
                -- into its submodules.
                table.insert(dirs, path)
            else
                -- Not a repo — treat as a container folder, check
                -- one level deeper for nested repos.
                local nested = vim.fn.glob(path .. "/*", true, true)
                for _, subpath in ipairs(nested) do
                    if vim.fn.isdirectory(subpath) == 1 and is_git_repo(subpath) then
                        table.insert(dirs, subpath)
                    end
                end
            end
        end
    end

    return dirs
end

return {
    "wurli/servery.nvim",
    opts = {
        dirs = get_repo_dirs(vim.fn.expand("~/Github")),
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
