--[[
local function is_git_repo(path)
    return vim.fn.isdirectory(path .. "/.git") == 1
end

local function get_repo_dirs(base)
    local dirs = {}

    local function scan(path)
        if is_git_repo(path) then
            table.insert(dirs, path)
            return -- don't recurse into a repo — this is what skips submodules
        end

        local entries = vim.fn.glob(path .. "/*", true, true)
        for _, entry in ipairs(entries) do
            if vim.fn.isdirectory(entry) == 1 then
                scan(entry)
            end
        end
    end

    scan(base)
    return dirs
end
--]]

return {
    --"wurli/servery.nvim",
    "wellatleastitried/servery.nvim",
    branch = "wildcard-expansion",
    opts = {
        --dirs = get_repo_dirs(vim.fn.expand("~/Github")),
        dirs = { "~/Github/*" },
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
