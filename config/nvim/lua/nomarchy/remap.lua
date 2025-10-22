vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>cc", '"+yy')
vim.keymap.set("v", "<leader>cc", '"+y')
vim.keymap.set("n", "<leader>pc", '"*p')
vim.api.nvim_create_autocmd("FileType", {
    pattern = "xml",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "=", "ggVG!xmllint --format -<CR>", { noremap = true, silent = true })
    end
})

