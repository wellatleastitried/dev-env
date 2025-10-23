vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>cc", '"+yy', { desc = "Copy line to system clipboard" })
vim.keymap.set("v", "<leader>cc", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("n", "<leader>pc", '"*p', { desc = "Paste from system clipboard" })

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>E", vim.cmd.Ex, { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex, { desc = "Open file explorer" })

